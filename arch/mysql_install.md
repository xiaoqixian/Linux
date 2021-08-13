### **Manjaro安装MySQL服务**

看起来这个是个很简单的事，但是由于之前失误过一次，所以还是将正确方式记录下来。

我采用的是pacman自动安装的方式。

1. `sudo pacman -S mysql`

2. 初始化MySQL

   `sudo mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql`

   这时在末尾会输出一个`A temporay password is generated for root@localhost：×××××`，这个就是初始的MySQL root密码，需要记住，**否则第一次无法进入**MySQL服务

3. 设置开机启动MySQL服务三连击

   ```bash
   sudo systemctl enable mysqld.service
   sudo systemctl daemon-reload
   sudo systemctl start mysqld.service
   ```

4. 使用第二步的密码进入MySQL

   `mysql -u root -p`

5. 修改root密码

   由于初始root密码是随机生成的，难以记住，所以需要修改。

   很多博主给出的修改命令都是下面这句：

   `ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_password';`

   但是我用了出现了语法错误，后来用下面这句成功了：

   `SET PASSWORD = 'new_password';`

