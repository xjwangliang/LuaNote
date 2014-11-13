http://developer.android.com/guide/components/aidl.html
http://developer.android.com/guide/components/bound-services.html
http://developer.android.com/training/articles/security-tips.html
http://developer.android.com/guide/components/processes-and-threads.html
http://developer.android.com/training/articles/security-ssl.html


Android system, or the user, may terminate a service at any time. For this reason if you want to ensure something is always running, you can schedule a periodic restart by means of AlarmManager class. The following code demonstrates how to do this.

```
Calendar cal = Calendar.getInstance();

Intent intent = new Intent(this, MyService.class);
PendingIntent pintent = PendingIntent.getService(this, 0, intent, 0);

AlarmManager alarm = (AlarmManager)getSystemService(Context.ALARM_SERVICE);
// Start every minute
alarm.setRepeating(AlarmManager.RTC_WAKEUP, cal.getTimeInMillis(), 60*1000, pintent); 
```
You can run this code when the user starts the app (i.e. in the oncreate of the first activity) but you have to check if it is already done, so probably it will be better if you create a broadcast receiver, than launches this code on system reboot.



###Service的用处

Thus a Service itself is actually very simple, providing two main features:

* A facility for the application to tell the system about something it wants to be doing in the background (even when the user is not directly interacting with the application). This corresponds to calls to Context.startService(), which ask the system to schedule work for the service, to be run until the service or someone else explicitly stop it.

* A facility for an application to expose some of its functionality to other applications. This corresponds to calls to Context.bindService(), which allows a long-standing connection to be made to the service in order to interact with it.

###public int onStartCommand (Intent intent, int flags, int startId)
* `intent`	The Intent supplied to startService(Intent), as given. This may be null if the service is being restarted after its process has gone away, and it had previously returned anything except START_STICKY_COMPATIBILITY.

* `flags`	Additional data about this start request. Currently either 0, START_FLAG_REDELIVERY, or START_FLAG_RETRY.
 
* `startId`	A unique integer representing this specific request to start. Use with stopSelfResult(int).

* `Returns`
The return value indicates what semantics the system should use for the service's current started state. It may be one of the constants associated with the START_CONTINUATION_MASK bits.


onStartCommand有4种返回值：   

*  `START_STICKY`：如果service进程被kill掉，保留service的状态为开始状态，但不保留递送的intent对象。随后系统会尝试重新创建service，由于服务状态为开始状态，所以创建服务后一定会调用onStartCommand(Intent,int,int)方法。如果在此期间没有任何启动命令被传递到service，那么参数Intent将为null。
* `START_NOT_STICKY`：“非粘性的”。使用这个返回值时，如果在执行完onStartCommand后，服务被异常kill掉，系统不会自动重启该服务。
* `START_REDELIVER_INTENT`：重传Intent。使用这个返回值时，如果在执行完onStartCommand后，服务被异常kill掉，系统会自动重启该服务，并将Intent的值传入。
* `START_STICKY_COMPATIBILITY`：START_STICKY的兼容版本，但不保证服务被kill后一定能重启。


```
// This is the old onStart method that will be called on the pre-2.0
// platform.  On 2.0 or later we override onStartCommand() so this
// method will not be called.
@Override
public void onStart(Intent intent, int startId) {
    handleCommand(intent);
}

@Override
public int onStartCommand(Intent intent, int flags, int startId) {
    handleCommand(intent);
    // We want this service to continue running until it is explicitly
    // stopped, so return sticky.
    return START_STICKY;
}
```
* 不能unbindService两次，可以bind多次).如果只有bindService,没有startService，那么unbindService之后service会destroy，否则不会.
 
* local service启动之后被kill（不会执行onDestroy），会立即执行onCreate和onStartCommand


###public final void startForeground (int id, Notification notification)

Make this service run in the foreground, supplying the ongoing notification to be shown to the user while in this state. By default services are background, meaning that if the system needs to kill them to reclaim more memory (such as to display a large page in a web browser), they can be killed without too much harm. You can set this flag if killing your service would be disruptive to the user, such as if your service is performing background music playback, so the user would notice if their music stopped playing.

If you need your application to run on platform versions prior to API level 5, you can use the following model to call the the older setForeground() or this modern method as appropriate:

```


private static final Class<?>[] mSetForegroundSignature = new Class[] {
    boolean.class};
private static final Class<?>[] mStartForegroundSignature = new Class[] {
    int.class, Notification.class};
private static final Class<?>[] mStopForegroundSignature = new Class[] {
    boolean.class};

private NotificationManager mNM;
private Method mSetForeground;
private Method mStartForeground;
private Method mStopForeground;
private Object[] mSetForegroundArgs = new Object[1];
private Object[] mStartForegroundArgs = new Object[2];
private Object[] mStopForegroundArgs = new Object[1];

void invokeMethod(Method method, Object[] args) {
    try {
        method.invoke(this, args);
    } catch (InvocationTargetException e) {
        // Should not happen.
        Log.w("ApiDemos", "Unable to invoke method", e);
    } catch (IllegalAccessException e) {
        // Should not happen.
        Log.w("ApiDemos", "Unable to invoke method", e);
    }
}

/**
 * This is a wrapper around the new startForeground method, using the older
 * APIs if it is not available.
 */
void startForegroundCompat(int id, Notification notification) {
    // If we have the new startForeground API, then use it.
    if (mStartForeground != null) {
        mStartForegroundArgs[0] = Integer.valueOf(id);
        mStartForegroundArgs[1] = notification;
        invokeMethod(mStartForeground, mStartForegroundArgs);
        return;
    }

    // Fall back on the old API.
    mSetForegroundArgs[0] = Boolean.TRUE;
    invokeMethod(mSetForeground, mSetForegroundArgs);
    mNM.notify(id, notification);
}

/**
 * This is a wrapper around the new stopForeground method, using the older
 * APIs if it is not available.
 */
void stopForegroundCompat(int id) {
    // If we have the new stopForeground API, then use it.
    if (mStopForeground != null) {
        mStopForegroundArgs[0] = Boolean.TRUE;
        invokeMethod(mStopForeground, mStopForegroundArgs);
        return;
    }

    // Fall back on the old API.  Note to cancel BEFORE changing the
    // foreground state, since we could be killed at that point.
    mNM.cancel(id);
    mSetForegroundArgs[0] = Boolean.FALSE;
    invokeMethod(mSetForeground, mSetForegroundArgs);
}

@Override
public void onCreate() {
    mNM = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
    try {
        mStartForeground = getClass().getMethod("startForeground",
                mStartForegroundSignature);
        mStopForeground = getClass().getMethod("stopForeground",
                mStopForegroundSignature);
        return;
    } catch (NoSuchMethodException e) {
        // Running on an older platform.
        mStartForeground = mStopForeground = null;
    }
    try {
        mSetForeground = getClass().getMethod("setForeground",
                mSetForegroundSignature);
    } catch (NoSuchMethodException e) {
        throw new IllegalStateException(
                "OS doesn't have Service.startForeground OR Service.setForeground!");
    }
}

@Override
public void onDestroy() {
    // Make sure our notification is gone.
    stopForegroundCompat(R.string.foreground_service_started);
}
```
####stopSelf(int)

services can use their `stopSelf(int)` method to ensure the service is not stopped until started intents have been processed.