##Get CPU abi
```
adb shell getprop ro.product.cpu.abi
adb shell getprop | grep abi
```

###用linux的方法获取设备的唯一号码

```
 1,cpu号：
 文件在： /proc/cpuinfo
 通过Adb shell 查看：
 adb shell cat /proc/cpuinfo

 2, mac 地址或者网卡地址
 文件路径 /sys/class/net/wlan0/address、/sys/class/net/eth0/address
 adb shell cat /sys/class/net/wlan0/address
 adb shell cat /sys/class/net/eth0/address
```

###获取存储卡路径

#####一、adb shell cat /system/etc/vold.fstab 
```
dev_mount usb	/mnt/USB	auto /devices/pci0000:00/0000:00:06.0/usb1
```

#####二、mount
```
rootfs / rootfs ro,relatime 0 0
tmpfs /dev tmpfs rw,nosuid,relatime,mode=755 0 0
devpts /dev/pts devpts rw,relatime,mode=600 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
tmpfs /mnt/secure tmpfs rw,relatime,mode=700 0 0
tmpfs /mnt/asec tmpfs rw,relatime,mode=755,gid=1000 0 0
tmpfs /mnt/obb tmpfs rw,relatime,mode=755,gid=1000 0 0
/dev/block/sda6 /system ext4 ro,relatime,data=ordered 0 0
/dev/block/sdb1 /cache ext4 rw,nosuid,nodev,relatime,data=ordered 0 0
/dev/block/sdb3 /data ext4 rw,nosuid,nodev,relatime,data=ordered 0 0
/dev/block/sdc /mnt/shell/emulated vfat rw,relatime,fmask=0000,dmask=0000,allow_utime=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
```

#####三、cat /proc/mounts
```
rootfs / rootfs ro,relatime 0 0
tmpfs /dev tmpfs rw,nosuid,relatime,mode=755 0 0
devpts /dev/pts devpts rw,relatime,mode=600 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
tmpfs /mnt/secure tmpfs rw,relatime,mode=700 0 0
tmpfs /mnt/asec tmpfs rw,relatime,mode=755,gid=1000 0 0
tmpfs /mnt/obb tmpfs rw,relatime,mode=755,gid=1000 0 0
/dev/block/sda6 /system ext4 ro,relatime,data=ordered 0 0
/dev/block/sdb1 /cache ext4 rw,nosuid,nodev,relatime,data=ordered 0 0
/dev/block/sdb3 /data ext4 rw,nosuid,nodev,relatime,data=ordered 0 0
/dev/block/sdc /mnt/shell/emulated vfat rw,relatime,fmask=0000,dmask=0000,allow_utime=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
```

######代码的方式
-------
```
rootfs / rootfs ro,relatime 0 0
tmpfs /dev tmpfs rw,nosuid,relatime,mode=755 0 0
devpts /dev/pts devpts rw,relatime,mode=600 0 0
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
tmpfs /mnt/secure tmpfs rw,relatime,mode=700 0 0
tmpfs /mnt/asec tmpfs rw,relatime,mode=755,gid=1000 0 0
tmpfs /mnt/obb tmpfs rw,relatime,mode=755,gid=1000 0 0
/dev/block/sda6 /system ext4 ro,nosuid,nodev,relatime,data=ordered 0 0
/dev/block/sdb1 /cache ext4 rw,nosuid,nodev,relatime,data=ordered 0 0
/dev/block/sdb3 /data ext4 rw,nosuid,nodev,relatime,data=ordered 0 0
/dev/block/sdc /mnt/shell/emulated vfat rw,relatime,fmask=0000,dmask=0000,allow_utime=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
tmpfs /storage/emulated tmpfs rw,nosuid,nodev,relatime,mode=050,gid=1028 0 0
/dev/block/sdc /storage/emulated/0 vfat rw,relatime,fmask=0000,dmask=0000,allow_utime=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
/dev/block/sdc /storage/emulated/0/Android/obb vfat rw,relatime,fmask=0000,dmask=0000,allow_utime=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
/dev/block/sdc /storage/emulated/legacy vfat rw,relatime,fmask=0000,dmask=0000,allow_utime=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
/dev/block/sdc /storage/emulated/legacy/Android/obb vfat rw,relatime,fmask=0000,dmask=0000,allow_utime=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
latime,data=ordered 0 0
/dev/block/sdb3 /data ext4 rw,nosuid,nodev,relatime,data=ordered 0 0
/dev/block/sdc /mnt/shell/emulated vfat rw,relatime,fmask=0000,dmask=0000,allow_utime=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
tmpfs /storage/emulated tmpfs rw,nosuid,nodev,relatime,mode=050,gid=1028 0 0
/dev/block/sdc /storage/emulated/0 vfat rw,relatime,fmask=0000,dmask=0000,allow_utime=0022,codepage=cp437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
/dev/block/sdc /storage/emulated/0/Android/obb vfat rw,
```
#####四、EXTERNAL_STORAGE
```
echo $EXTERNAL_STORAGE
/storage/emulated/legacy

echo $SECONDARY_STORAGE
(返回空)
```

#####五、StorageManager
```
try {
	StorageManager sm = (StorageManager) getSystemService(Context.STORAGE_SERVICE);
	// 获取sdcard的路径：外置和内置
	String[] paths = (String[]) sm.getClass().getMethod("getVolumePaths", null).invoke(sm, null);
} catch (Exception e1) {
	e1.printStackTrace();
} 

```

结果:

```
XIAOMI盒子
[/storage/emulated/0, /storage/external_storage/sdcard1]

tmall盒子
[/mnt/sdcard, /mnt/extsd, /mnt/usbhost1, /mnt/usbhost0]

LETV盒子
[/storage/emulated/0, /storage/sdcard0, /storage/external_storage/sda1]

Nexus 7
[/storage/emulated/0]
```

######ls /mnt   

```
USB
asec
obb
sdcard  # sdcard -> /storage/emulated/legacy
secure
shared
shell
```

######ls /storage

```
emulated
sdcard0    # sdcard0 -> /storage/emulated/legacy

```
其中：

```
legacy -> /mnt/shell/emulated/0
```

```
getFilesDir()-->/data/data/package_name/files
getExternalFilesDir("exter_test")-->根目录/Android/data/package_name/files/exter_test
Environment.getDownloadCacheDirectory()--->/cache
Environment.getDataDirectory()-->/data
Environment.getRootDirectory()-->/system
context.getCacheDir()-->/data/data/package_name/cache
context.getExternalCacheDir()-->/mnt/sdcard/Android/data/package_name/cache
```

google在4.2中考虑多用户的问题，对每个用户（user）来说，看各自的文件夹可以，但对于数据文件夹的处理就稍微麻烦了，所以调整了数据的挂载结构，如使用fuse技术/dev/fuse 会被挂载到/storage/emulated/0 目录，为了兼容以前，同时挂载到 /storage/emulated/legacy （故名思议，传统的），还建立三个软连接 /storage/sdcard0 ，/sdcard，/mnt/sdcard ，都指向  /storage/emulated/legacy/，（链接参见：http://bbs.gfan.com/android-5382920-1-1.html），但是就可能造成获取文件目录中的文件（如image）时，会出现相同的图片./mnt/shell/ 是为了多用户准备的，因为linux的多用户是基于shell实现的。


Environment.getExternalStorageDirectory()方法得到的大多数是手机内部对应的SD卡.一些较常见的外部SD卡的路径:

```
/mnt/sdcard2                 
/mnt/sdcard-ext     
/mnt/ext_sdcard    
/mnt/sdcard/SD_CARD
/mnt/sdcard/extra_sd   
/mnt/extrasd_bind   
/mnt/sdcard/ext_sd
/mnt/sdcard/external_SD    
/storage/sdcard1   
/storage/extSdCard 
/mnt/usbhost1
/mnt/usbhost0
/mnt/extsd
```
如何直接取，而不是hardcode来定死呢，用StorageManager的getVolumePaths，通过反射机制得到路径，然后判断即可



####总结一下：

一部分手机将eMMC存储挂载到 /mnt/external_sd 、/mnt/sdcard2 等节点，而将外置的SD卡挂载到 Environment.getExternalStorageDirectory()这个结点。
此时，调用Environment.getExternalStorageDirectory()，则返回外置的SD的路径。


而另一部分手机直接将eMMC存储挂载在Environment.getExternalStorageDirectory()这个节点，而将真正的外置SD卡挂载到/mnt/external_sd、/mnt/sdcard2 等节点。
此时，调用Environment.getExternalStorageDirectory()，则返回内置的SD的路径。

至此就能解释为都是无外置SD卡的情况下，在中兴手机上，调用

打印 Environment.getExternalStorageState()，却返回 ”removed“，在索尼、MOTO G上就返回：“mounted”

原因已经知道了，可是如何在无外置SD卡的时候，获取到这个内置eMMC存储的具体路径呢？

比如，我这个中兴手机，既然使用 Environment.getExternalStorageDirectory() 获取到的是外置SD卡路径，但是我又没有插入SD卡，这个时候我想使用内置的eMMC存储来存储一些程序中用到的数据，我怎么去获取这个eMMC存储的路径呢？

答案是：通过扫描系统文件"system/etc/vold.fstab”来实现。


```
http://my.oschina.net/liucundong/blog/288183
http://stackoverflow.com/questions/5694933/find-an-external-sd-card-location
http://www.doubleencore.com/2014/03/android-external-storage/
http://padbbs.zol.com.cn/1/229_1206.html
http://padbbs.zol.com.cn/1/229_218.html
https://source.android.com/devices/tech/storage/config-example.html
http://sapienmobile.com/?p=204

http://blog.csdn.net/jamikabin/article/details/18814031 android vold.fstab的生成过程
```