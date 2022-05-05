### 在Arch/Manjaro 环境下使用stm32flash 对stm32进行串口下载

由于我们老师给我们的stm32带了一个扩展板，扩展板上带了一个CH340烧录电路，所以只能使用ISP下载。

Linux下想要直接在命令行进行串口烧录需要先下载 `stm32flash` 工具，Arch系可以直接从AUR仓库下载。

下载了以后直接连接电脑和板子（注意要检查你的板子有没有CH340烧录芯片，没有的话就不要看了）。然后输入`lsusb` 会发现已经有了一个名为 `CH340 serial converter` 的usb设备，但是这时候如果你输入 `ls /dev` 会发现找不到名为`ttyUSB0` 的设备文件，我们需要这个设备文件来进行烧录，如果找不到的话就无法继续进行。

这时你如果输入 `desmg | grep tty` 会发现下面的输出：

```
[1182096.667353] usb 1-9: ch341-uart converter now attached to ttyUSB0
[1182096.729868] audit: type=1130 audit(1637925474.011:3648): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=brltty-device@sys-devices-pci0000:00-0000:00:14.0-usb1-1\x2d9 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[1182096.800144] audit: type=1130 audit(1637925474.081:3649): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=brltty@-sys-devices-pci0000:00-0000:00:14.0-usb1-1\x2d9 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[1182096.803145] usb 1-9: usbfs: interface 0 claimed by ch341 while 'brltty' sets config #1
[1182096.803731] ch341-uart ttyUSB0: ch341-uart converter now disconnected from ttyUSB0
```

具体就是串口设备刚刚连接电脑就自动断开了，具体原因我也不清楚。

于是我找了好多帖子，最终在一个Manjaro论坛中找到了这篇[帖子](https://forum.manjaro.org/t/cant-connect-serial-port-error-ch341-uart-disconnected-from-ttyusb0/87208)，好像是需要移除一些udev 规则才能正常工作，具体命令如下：

```shell
sudo mv /usr/lib/udev/rules.d/90-brltty-device.rules /usr/lib/udev/rules.d/90-brltty-device.rules.disabled
sudo mv /usr/lib/udev/rules.d/90-brltty-uinput.rules /usr/lib/udev/rules.d/90-brltty-uinput.rules.disabled
sudo udevadm control --reload-rules
```

运行后应该可以在/dev文件夹下找到名为`ttyUSB0` 的设备文件。

然后运行 `sudo stm32flash /dev/ttyUSB0`（注意必须要获取root权限），正常应该会显示如下结果：

```shell
stm32flash 0.6

http://stm32flash.sourceforge.net/

Interface serial_posix: 57600 8E1
Version      : 0x22
Option 1     : 0x00
Option 2     : 0x00
Device ID    : 0x0410 (STM32F10xxx Medium-density)
- RAM        : Up to 20KiB  (512b reserved by bootloader)
- Flash      : Up to 128KiB (size first sector: 4x1024)
- Option RAM : 16b
- System RAM : 2KiB
```

这样就说明成功了。

接着你可以试着通过命令 `sudo stm32flash -w proj.hex /dev/ttyUSB0` 进行烧录。