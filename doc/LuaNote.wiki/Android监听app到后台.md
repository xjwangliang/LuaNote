http://www.vogella.com/tutorials/AndroidServices/article.html

Android offers a “service” component. Unlike “activities” (screens) that interact directly with the user, services are more for managing background operations. The quintessential example is a music player, continuing to play tunes while its UI is not running.

Some developers then make the leap from “it is possible” to “it is a really good idea and should be used wherever”. Many people on Android Google Groups or StackOverflow propose to create services that “run forever” and ask how to prevent them from being killed off, and such.

These developers appear to ignore the costs of this approach:

While running, a service consumes one process’ worth of memory, which is a substantial chunk, despite Dalvik’s heavy use of copy-on-write techniques to share memory between processes. A single service hogging memory is not that big of a deal; a dozen such services will prevent the Android device from being usable. Hence, even if the memory footprint does not impact the developer directly, it impacts the users indirectly — much like how pollution benefits the polluter with a corresponding cost to society.
While running, the service will need to fight Android, which will want to shut down the service if RAM gets too tight. While Android should, in principle, restart the service once memory is plentiful again, the developer will have no control over the timing of this.
While running, the service will need to fight its own users, who may elect to shut down the service via the Manage Applications screen, or through a third-party task manager. In this case, Android will not restart the service automatically.
The service will fall asleep when the device falls asleep and shuts down the CPU, which means even if the service “runs forever”, it will not be able to run forever, unless it prevents the CPU from stopping, which wrecks battery life.
The recommended alternative is to use AlarmManager, as described in a previous post and in finer Android programming books. Think of your Android service as a cron job or Windows scheduled task, not as a persistent daemon or Windows service. This approach works much better with Android’s framework and device limitations:

The service only uses memory when it is actually doing something, not just sitting around waiting.
The odds that Android will need to kill off the service decreases, in part because the service will not be “old” and other services are likely to be killed first.
The odds that the user will need to kill off the service decreases, because the service is less likely to cause any pollution that may cause the user problems.
The service can hold a WakeLock for the duration of its bit of work to keep the CPU running for a short period
Now, the AlarmManager API is not the friendliest. Some developers get tripped up while trying to handle multiple outstanding alarms. While there are ways to deal with this (via careful construction of PendingIntent objects), sometimes you do not truly need more than one alarm. If you have code that you want to run every 15 minutes, and other code that you want to run every 24 hours, use one 15-minute alarm and trigger the once-every-24-hours code every 96th time the 15-minute alarm goes off.

I encourage Android developers to try to avoid long-running services wherever possible. If you are uncertain how to design an app to avoid the long-running service, post a clear description of the business scenario (not just low-level technical stuff) to the [android-developers] group or to StackOverflow with the #android tag. We can try to help you find ways of achieving your business objectives in an Android-friendly fashion.



In the Code Pollution series, I’ll be writing about topics where a coding anti-pattern may work tactically for an individual application, but strategically will be bad for Android as a whole, just as pollution may benefit one firm while harming many others.

In the previous post in the Code Pollution series, I pointed out how it is possible for background processes, such as those driven by AlarmManager, can wind up with foreground priority and impact real-time games. Poor frame rates is not the only reason that a user might be concerned about your application’s use of background operations, though.

A popular application category on the Android Market is the so-called “task killer” app. These apps exploit some Android API loopholes to kill off everything associated with an application: services, activities, AlarmManager alarms, etc. Many developers decry these tools, complaining that users then gripe that the developers’ apps do not work, when it was the users themselves (with the task killer’s help) that broke the apps in the first place.

While I agree that the task killers are probably overused, there is also little question that some Android apps are not “good citizens” when it comes to their use of background operations. Perhaps they try to have everlasting services, or perhaps they poll too frequently, or try to do too much in the foreground windows, or something.

In the end, user satisfaction is dependent upon Android apps being responsible in their use of background operations. Here are some tips on how to stay in your users’ good graces.

First, avoid those everlasting services. Users get nervous if they see your service hanging around in memory all the time, particularly if they think they are experiencing performance issues. Users might use a task killer to shut down your service, or they might use the Settings application in newer versions of Android. To the greatest extent possible, architect your application to run on a scheduled basis using the AlarmManager, rather than assuming you will be successful in keeping your service in RAM indefinitely.

Therefore, you might decide that you want the AlarmManager to invoke your service frequently, such as every minute. That may make sense to you. It might not make sense to your users. Make your alarm periods configurable. Even if you elect to choose an aggressive default, let the user choose something that is less frequent. You can cancel and re-establish your alarm when the user changes the setting.

One special case of configurable alarm periods is infinity — in other words, allow the user to disable your background operations altogether. Yes, background work is sexy. On the other hand, as of the time of this writing, iPhone does not support background operations for third-party applications. The fact that iPhone apps can be successful without background operations means you can be successful as well by letting the user choose to forgo such background work. You might want to pop up a dialog or something to warn the user of lost functionality if they disable it, but still let them disable it.

Understand that, even with this configurability, the user might still nuke your app via a task killer. Do not fight the user. The user knows what the user wants. It is up to you to deliver. If the user wants your background operations disabled and chooses to do that via a task killer than your preference activity, so be it. In fact, if you have a good way to check to see that you were killed (e.g., the time gap between your last background run and now is well over the alarm period), you might even pop up a dialog saying something to the effect of “I see you used a task killer to get rid of me. Would you like my background operations to be disabled?”. That way, you turn a negative (user feeling a task killer is appropriate for your app) into a positive (you demonstrate that you are aware of their interest and can be configured the way they want).

That is one facet of a bigger issue: do not assume you know best. Yes, you like your app. Yes, you think all users will like your app and want to use it the same way you do. That rarely works out in reality. Even some things you might consider essential may not be. For example, one argument for using an everlasting service is a VOIP app — after all, there is no other way to receive an incoming call if there is no service with a socket watching for calls from the SIP server. However, that assumes the user wants incoming calls. Perhaps they do not, wanting VOIP just for outbound calls. If you do not let this be configurable, they will be inclined to smack your app around via a task killer to get rid of the service.

Some mobile operating systems preclude background operations. Android does not, but that does not mean background operations are always a good thing. Let the user decide. The more developers do this, the less of a problem task killers will pose for everyone.



Read more: http://www.androidguys.com/2010/03/29/code-pollution-background-control/#ixzz3I02ifswV 
Follow us: @androidguys on Twitter | AndroidGuys on Facebook




registerActivityLifecycleCallbacks
@Override
public void onCreate() {
    super.onCreate();
    registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {
        @Override
        public void onActivityStopped(Activity activity) {
        }

        @Override
        public void onActivityStarted(Activity activity) {
        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        }

        @Override
        public void onActivityResumed(Activity activity) {
        }

        @Override
        public void onActivityPaused(Activity activity) {
        }

        @Override
        public void onActivityDestroyed(Activity activity) {
        }

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
            if (activity.isTaskRoot() && !(activity instanceof SwitchActivity)) {
                Log.e(HangApp.TAG, "Reload defaults on restoring from background.");
                loadDefaults(new Call(3));
            }
        }
    });
}

---
Consider using onUserLeaveHint. This will only be called when your app goes into the background. onPause will have corner cases to handle, since it can be called for other reasons; for example if the user opens another activity in your app such as your settings page, your main activity's onPause method will be called even though they are still in your app; tracking what is going in will lead to bugs when you can instead simply use the onUserLeaveHint callback which does what you are asking.

When on UserLeaveHint is called, you can set a boolean inBackground flag to true. When onResume is called, only assume you came back into the foreground if the inBackground flag is set. This is because onResume will also be called on your main activity if the user was just in your settings menu and never left the app.

Remember that if the user hits the home button while in your settings screen, onUserLeaveHint will be called in your settings activity, and when they return onResume will be called in your settings activity. If you only have this detection code in your main activity you will miss this use case. To have this code in all your activities without duplicating code, have an abstract activity class which extends Activity, and put your common code in it. Then each activity you have can extend this abstract activity.

For example:

public abstract AbstractActivity extends Activity {
    private static boolean inBackground = false;

    @Override
    public void onResume() {
        if (inBackground) {
            // You just came from the background
            inBackground = false;
        }
        else {
            // You just returned from another activity within your own app
        }
    }

    @Override
    public void onUserLeaveHint() {
        inBackground = true;
    }
}

public abstract MainActivity extends AbstractActivity {
    ...
}

public abstract SettingsActivity extends AbstractActivity {
    ...
}

---
My solution to detect if application entered the foreground is this:

Create a class that extends the Application class (lets say MyApplication).
Register MyApplication class into AndroidManifest.xml
Create a public staticå List of all Activities in it.
Create a method (lets say wasInBackground) that checks if the application returned from the background.
Create a class that extends Activity class (lets say BaseActivity).
Override its onCreate method and add this activity into the List of Activities in MyApplication class.
Make all your Activities override BaseActivity instead of Activity class.
Now in any Activity where you want to check if application entered into foreground, simply call wasInBackground in onResume method of that Activity.
Here is the sample code of above mentioned steps:

MyApplication.java

public class MyApplication extends Application {

    // List of all created activities in the app
    public static List<Activity> activities = new ArrayList();

    // method to check if the app returned to foreground or not
    public static boolean wasInBackground() {
        for (Activity activity : activities) {
            if (activity.hasWindowFocus()) {
                return false;
            }
        }
        return true;
    }
}
BaseActivity.java

// the Activity that will be extended by all other Activities instead of Activity class 
public class BaseActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ApplicationContext.activities.add(this); // Add the activity to activities List 
    }
}
MainActivity.java

// An activity where we want to check if the app entered from the background
public class MainActivity extends BaseActivity {

    @Override
    protected void onResume() {
        super.onResume();

        if (ApplicationContext.wasInBackground()) {  // this will only be true if app returns from background
            Toast.makeText(this, "Returned from background", Toast.LENGTH_SHORT).show();
        }
    }
}

http://stackoverflow.com/questions/4414171/how-to-detect-when-an-android-app-goes-to-the-background-and-come-back-to-the-fo

http://stackoverflow.com/questions/18038399/how-to-check-if-activity-is-in-foreground-or-in-visible-background

http://steveliles.github.io/is_my_android_app_currently_foreground_or_background.html


http://stackoverflow.com/questions/6693896/home-key-press-event-listener



http://862123204-qq-com.iteye.com/blog/1888532
http://blog.csdn.net/com360/article/details/6663586
http://blog.csdn.net/zhaohw_lenovo/article/details/8178204