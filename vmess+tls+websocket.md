### vmess + tls + websocket

#### centos开放端口方法

以80端口为例：`firewall-cmd --zone=public --add-port 80/tcp --permanent`

重载以生效：`firewall-cmd --reload`

若是 Arch Linux, 则可以用 `iptables -I INPUT -p tcp --dport 80 -j ACCEPT` 开放80端口。

#### SSL证书获取

首先保证购买到一个域名并将域名的DNS解析指向你的服务器IP。

其次安装acme.sh用于获取免费SSL证书

`curl https://get.acme.sh | sh`

下载到的shell文件在当前路径下的.acme.sh文件夹下。其次，需要更改acme的默认证书服务器为letsencrypt: `./acme.sh --set-default-ca --server letsencrypt`

安装nginx，在centos下的默认配置文件路径为`/etc/nginx/nginx.conf`，修改配置文件监听80端口，因为acme.sh需要检测域名对应IP的服务器是否为你所有，acme.sh会在服务器的一定路径下创建一些文件并通过域名进行下载，可以下载成功才可能认证成功。

在`/etc/nginx/nginx.conf`下添加一个server, 或者直接修改默认配置文件也可以：

```nginx
server {
    listen 80;
    server_name domain.name;
   	location / {
    	/usr/share/nginx/html
	}
}
```

注意`domain.name`改为你的域名，如果你要获取多个域名则可以在后面继续添加，空格空开。

保证nginx正在运行，且80端口已经开放。然后运行命令：`./acme.sh --issue -d domain.name --nginx`

正常情况下SSL证书应该已经生成，程序会给出证书的路径，需要用到的是两个文件：

- fullchain.cer：证书文件
- domain.name.key: 私钥

接下来在nginx配置文件中添加https的server，这个比较复杂，这里给出我的：

```nginx
 server {
	  listen 443 ssl;
	  listen [::]:443 ssl;

	  ssl_certificate       /path/to/fullchain.cer;#添加证书文件绝对路径
	  ssl_certificate_key   /path/to/private.key;#添加私钥文件绝对路径
	  ssl_session_timeout 1d;
	  ssl_session_cache shared:MozSSL:10m;
	  ssl_session_tickets off;

	  ssl_protocols         TLSv1.2 TLSv1.3;
	  ssl_ciphers           ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
	  ssl_prefer_server_ciphers off;

	  server_name            domain.name;
	  location / {
          root /usr/share/nginx/html;
      }
}
```

其次还有很重要的一步是**开放443端口**。

接下来可以上[sslshopper.com](sslshopper.com)之内的网站检验一下，也可以直接在浏览器输入https://domain.name, 如果出现nginx的欢迎界面说明证书有效。

#### nginx配置转发

nginx有一个特点是可以实现特定路径的请求转发，这正是vmess+tls+websocket的精髓所在，我们只需要在nginx中指定一个特定的路径将请求转发给v2ray就可以实现科学上网，而别人如果不知道这个路径看起来还是一个正常的网站。

在nginx配置文件中监听443端口的server中添加：

```nginx
location /ray { #路径可以自己定义
	    if ($http_upgrade != "websocket") { # WebSocket协商失败时返回404
		return 404;
	    }
	    proxy_redirect off;
	    proxy_pass http://127.0.0.1:9900; # 假设WebSocket监听在环回地址的9900端口上
	    proxy_http_version 1.1;
	    proxy_set_header Upgrade $http_upgrade;
	    proxy_set_header Connection "upgrade";
	    proxy_set_header Host $host;
	    # Show real IP in v2ray access.log
	    proxy_set_header X-Real-IP $remote_addr;
	    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	  }
}
```

这里需要注意的两个点：一个是路径，另一个是转发的端口，都需要与v2ray的server配置文件相对应。

#### 获取v2ray

`bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)`

#### server config.json

```json
{
    "log": {
        "loglevel": "info"
    },
    "routing": {
        "domainStrategy": "AsIs",
        "rules": [
            {
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "blocked",
                "type": "field"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "127.0.0.1",
            "port": 9900,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "...",
                        "alterId": 0
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/ray"
                }
           }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        },
        {
            "protocol": "blackhole",
            "tag": "blocked"
        }
    ]
}
```

这里的流配置中网络设置为 `ws`，即websocket

#### client config.json

```json
{
	"log": {
		"loglevel": "info"
	},
    "routing": {
        "domainStrategy": "IPOnDemand",
        "rules": [
            {
                "type": "field",
                "outboundTag": "direct",
                "domain": ["geosite:cn"]
            },
            {
                "type": "field",
                "outboundTag": "direct",
                "ip": [
                    "geoip:cn",
                    "geoip:private"
                ]
            },
            {
                "type": "field",
                "outboundTag": "proxy",
                "network": "udp, tcp"
            }
        ]
    },
	"inbounds": [
        {
            "port": 1196,
            "protocol": "http",
            "settings": {
                "auth": "noauth"
            },
            "tag": "http"
        }
	],
	"outbounds": [
		{
			"protocol": "vmess",
			"settings": {
				"vnext": [
					{
						"users": [
							{
                                "id": "...",
								"alterId": 64,
                                "encryption": "none"
							}
						],
						"port": 443,
						"address": "domain.name"
					}
				]
			},
            "tag": "proxy",
            "streamSettings": {
                "network": "ws",
                "security": "tls",
                "wsSettings": {
                    "path": "/ray"
                }
            }
		},
		{
			"protocol": "freedom",
			"tag": "direct"
		}
	]
}
```

这里需要注意的一点是outbounds的端口要设置为443端口，即https的端口，而不是server config.json中指定的端口，因为请求需要先发送给nginx进行转发，address也是设置为域名而不是ip地址。

### Tips

#### 系统时间同步问题

服务器时间和客户端时间的同步对于 v2ray 的正常工作非常重要，而且本地时间必须是硬件时间（通过 `hwclock --verbose` 显示的时间）。今天（2022/5/5）就是因为从 Linux 换到 Windows 用了几个小时导致 Linux 重新开机后系统时间出现了差错，导致 websocket 一直无法连接，搞得我快抑郁了。

同步方法：Windows 可以在系统设置里直接同步，Linux 首先在系统设置里将系统时间改回正常时间，然后通过命令 `sudo hwclock --systohc` 将硬件时间改回來就可以了。
