ModernAsyncTask



String newLine = System.getProperty("line.separator");

Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse("about:blank"));
setActivityIntent(i);

String currDir = System.getProperty("user.dir");

 public static String getProp(String propKey) {
        Process p = null;
        String propVal = "";
        try {
            p = new ProcessBuilder("/system/bin/getprop", propKey)
            .redirectErrorStream(true).start();
            BufferedReader br = new BufferedReader(new InputStreamReader(
                    p.getInputStream()));
            String line = "";
            while ((line = br.readLine()) != null) {
                propVal = line;
            }
            p.destroy();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return propVal;
    }
    
proc/cpuinfo
proc/meminfo

jieyaming/dj2@Jf1



adb shell su 0 cat /proc/xxx/maps

adb forward tcp:23946 tcp:23946

adb shell am start -D -n com.example.mytestcm/.MainActivity

jdb -connect com.sun.jdi.SocketAttach:hostname=127.0.0.1,port=8700其中port=8700是从ddms中看到的



简单来说，就是要提高自己进程的权限，这样就不会被随随便便杀掉了。

第一步(不建议加，可忽略)
让你的service是系统进程，例如

引用:
<service
     android:name="com.example.service.MyService"
     android:process="system" />
第二步
让你的UID为1000，也就是和System共享ID
方法很简单，AndroidManifest.xml中的manifest标签下加一个属性android:sharedUserId="android.uid.system"，例如

引用:
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example"
    android:versionCode="1"
    android:versionName="1.0.0"
    android:sharedUserId="android.uid.system" >
第三步，最关键
APK编出来后，用signapk.jar和platform的key对你的APK重新签名。
signapk和platform的key(有两个文件，platform.pk8和platform .x509.pem)都是Android源码下面现成的，如果楼主没有Android源码，这三个文件也可以在网上找到。
当然，如果楼主有Android源码，直接在Android.mk里面指定LOCAL_CERTIFICATE为platform，然后mm就可以了。

需要注意的是，楼主需要保证自己的Service健壮性，因为成为加了android:process="system"而成为system进程之后，你的Service挂掉，将会导致整个系统Crash，对于用户来说就是看到开机动画重新跑一遍。。。 


目前尝试了N多办法还是未能解决。盒子已经ROOT，而且已经尝试过 安装 xposed 框架 设置 内存常驻、提升service权重、安装内存锁等等 都失效了。包括android上面的 数字助手、LBE大师之类的安全软件 上了小米盒子全部 武功全废。
  目前我发现的唯一的一款软件能够避免被杀死的应用就是 安全管家 了，我用了他的应用锁对 当前的桌面启动器设置了之后 返回桌面  安全管家 会隔断时间 就要求我输入密码。我特意看了下他的权限  也没什么 特别的呀。不知道他是什么实现的？