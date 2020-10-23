---
author: lunar
date: Fri 23 Oct 2020 08:14:00 PM CST
---

### 解决Linux QQ闪退的问题

一开始从Linux QQ转到了wine TIM，但是TIM这玩意CPU占太多了。又转到了Linux QQ，现在找到了解决Linux QQ扫码闪退的问题。

- 在/usr/share/applications/qq.desktop文件中将 Exec行为修改为 Exec=/opt/tencent-qq/qq %U --no-sandbox

- 删除~/.config/tencent-qq

第二种方法会删除你的QQ配置文件，所以需要备份的话注意备份。

当再次进入后，又会建立一个~/.config/tencent-qq文件夹.
