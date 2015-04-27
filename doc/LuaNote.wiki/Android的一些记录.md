###Message的另外一种使用方式
```
mHandler.obtainMessage(ADAPTER_CREATED, adapter).sendToTarget();
```

###ContentObserver和DataSetObserver的使用
```
mCursor = b.managedQuery(Browser.BOOKMARKS_URI,
                Browser.HISTORY_PROJECTION, whereClause, null, orderBy);
        mCursor.registerContentObserver(new ChangeObserver());
        mCursor.registerDataSetObserver(new MyDataSetObserver());

        mDataValid = true;
        notifyDataSetChanged();
        
        
private class ChangeObserver extends ContentObserver {
        public ChangeObserver() {
            super(new Handler(Looper.getMainLooper()));
        }

        @Override
        public boolean deliverSelfNotifications() {
            return true;
        }

        @Override
        public void onChange(boolean selfChange) {
            refreshList();
        }
    }
    
    private class MyDataSetObserver extends DataSetObserver {
        @Override
        public void onChanged() {
            mDataValid = true;
            notifyDataSetChanged();
        }

        @Override
        public void onInvalidated() {
            mDataValid = false;
            notifyDataSetInvalidated();
        }
    }
     /**
     *  Refresh list to recognize a change in the database.
     */
    public void refreshList() {
        mCursor.requery();
        mCount = mCursor.getCount() + mExtraOffset;
        notifyDataSetChanged();
    }
    
    
```   
###Handler移除回调
```
1.
mHandler.removeCallbacksAndMessages(null);

2.
private void scheduleAdvance() {
        mHandler.postDelayed(mAdvanceTicker, TICKER_SEGMENT_DELAY);
}
void halt() {
        mHandler.removeCallbacks(mAdvanceTicker);
        mSegments.clear();
        tickerHalting();
}
```


    
###线程等待

A common replacement for wait/notify is CountDownLatch. (From java.util.concurrent as well but working kind of inverse of Semaphore - see answer by Tom)

You initialize it to the amount of steps required, threads that have finished count down and some other place waits for the countdown to reach 0.

```
void doFoo() {
    final CountDownLatch latch = new CountDownLatch(1);
    new Thread(new Runnable() {

        @Override
        public void run() {
            //this is a http request
            appSignInfo = getAPKSignature(context, pkinfo.packageName);
            latch.countDown();
        }
    }).start();
    try {
        latch.await();
    } catch (InterruptedException e) {
        e.printStackTrace();
    }

    if (appSignInfo == null) {
        return ret;
    }
}
```
From the docs: "Each acquire() blocks if necessary until a permit is available, and then takes it.".

But there are other choices too- I strongly recommend using this where possible, as you should avoid lots of pit falls as in your case.

        Semaphore semaphore = new Semaphore(0);
        new Thread(new Runnable() {

            @Override
            public void run() {
                //this is a http request
                appSignInfo = getAPKSignature(context, pkinfo.packageName);
                semaphore.release();
            }
        }).start();
        try {
            semaphore.acquire();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
This is wrong:

synchronized(foo) {
    foo.wait();
}
The problem is, what's going to wake this thread up? That is to say, how do you guarantee that the other thread won't call foo.notify() before the first thread calls foo.wait()? That's important because the foo object will not remember that it was notified if the notify call happens first. If there's only one notify(), and if it happens before the wait(), then the wait() will never return.

Here's how wait and notify were meant to be used:

```
private Queue<Product> q = ...;
private Object lock = new Object();

void produceSomething(...) {
    Product p = reallyProduceSomething();
    synchronized(lock) {
        q.add(p);
        lock.notify();
    }
}

void consumeSomething(...) {
    Product p = null;
    synchronized(lock) {
        while (q.peek() == null) {
            lock.wait();
        }
        p = q.remove();
    }
    reallyConsume(p);
}

```
The most important things to to note in this example are that there is an explicit test for the condition (i.e., q.peek() != null), and that nobody changes the condition without locking the lock.

If the consumer is called first, then it will find the queue empty, and it will wait. There is no moment when the producer can slip in, add a Product to the queue, and then notify the lock until the consumer is ready to receive that notification.

On the other hand, if the producer is called first, then the consumer is guaranteed not to call wait().

The loop in the consumer is important for two reasons: One is that, if there is more than one consumer thread, then it is possible for one consumer to receive a notification, but then another consumer sneaks in and steals the Product from the queue. The only reasonable thing for the fist consumer to do in that case is wait again for the next Product. The other reason that the loop is important is that the Javadoc says Object.wait() is allowed to return even when the object has not been notified. That is called a "spurious wakeup", and the correct way to handle it is to go back and wait again.

Also note: The lock is private and the queue is private. That guarantees that no other compilation unit is going to interfere with the synchronization in this compilation unit.

And note: The lock is a different object from the queue itself. That guarantees that synchronization in this compilation unit will not interfere with whatever synchronization that the Queue implementation does (if any).

NOTE: My example re-invents a wheel to prove a point. In real code, you would use the put() and take() methods of an ArrayBlockingQueue which would take care of all of the waiting and notifying for you.


###Activity生命周期方法
onResume--onPause(Activity进入到前台--后台，注意不是不可见，只要前台显示不的是此activity就是到后台)
onStart--onStop(Activity可见--不可见)

onResume/onPause可以注册监听器或者Receiver或者埋点,刷新view

```
    @Override
    public void onStart() {
        // Hide wallpaper if it's not a static image
        if (forceOpaqueBackground(this)) {
            updateWallpaperVisibility(false);
        } else {
            updateWallpaperVisibility(true);
        }
        mShowing = true;
        if (mRecentsPanel != null) {
            mRecentsPanel.refreshViews();
        }
        super.onStart();
    }

    @Override
    public void onResume() {
        mForeground = true;
        super.onResume();
    }
    
    @Override
    public void onPause() {
    	// 到后台，切换动画
        overridePendingTransition(
                R.anim.recents_return_to_launcher_enter,
                R.anim.recents_return_to_launcher_exit);
        mForeground = false;
        super.onPause();
    }

    @Override
    public void onStop() {
        mShowing = false;
        if (mRecentsPanel != null) {
            mRecentsPanel.onUiHidden();
        }
        super.onStop();
    }
    
```
###View的onAttachedToWindow
```
 @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();

        if (!mAttached) {
            mAttached = true;
            IntentFilter filter = new IntentFilter();

            filter.addAction(Intent.ACTION_TIME_TICK);
            filter.addAction(Intent.ACTION_TIME_CHANGED);
            filter.addAction(Intent.ACTION_TIMEZONE_CHANGED);
            filter.addAction(Intent.ACTION_CONFIGURATION_CHANGED);

            getContext().registerReceiver(mIntentReceiver, filter, null, getHandler());
        }

        // NOTE: It's safe to do these after registering the receiver since the receiver always runs
        // in the main thread, therefore the receiver can't run before this method returns.

        // The time zone may have changed while the receiver wasn't registered, so update the Time
        mCalendar = Calendar.getInstance(TimeZone.getDefault());

        // Make sure we update to the current time
        updateClock();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mAttached) {
            getContext().unregisterReceiver(mIntentReceiver);
            mAttached = false;
        }
    }

2
@Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        mAttached = true;
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mAnim != null) {
            mAnim.stop();
        }
        mAttached = false;
    }

    @Override
    protected void onVisibilityChanged(View changedView, int vis) {
        super.onVisibilityChanged(changedView, vis);
        if (mAnim != null) {
            if (isShown()) {
                mAnim.start();
            } else {
                mAnim.stop();
            }
        }
    }
3
    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();

        if (!mAttached) {
            mAttached = true;
            IntentFilter filter = new IntentFilter();
            filter.addAction(Telephony.Intents.SPN_STRINGS_UPDATED_ACTION);
            getContext().registerReceiver(mIntentReceiver, filter, null, getHandler());
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (mAttached) {
            getContext().unregisterReceiver(mIntentReceiver);
            mAttached = false;
        }
    }
```
    
###TaskStackBuilder 
```
1.
ActionBarCompat.setDisplayHomeAsUpEnabled(this, true);      

当该app是当前task的owner时，可以使用NavUtils.navigateUpFromSameTask(),如果这个activity可以由其它的app启动，则必须判断是否需要重建back stack(http://blog.csdn.net/liangtb/article/details/17147035)




@Override  
public boolean onOptionsItemSelected(MenuItem item) {  
    switch (item.getItemId()) {  
    // Respond to the action bar's Up/Home button  
    case android.R.id.home:  
        Intent upIntent = NavUtils.getParentActivityIntent(this);  
        if (NavUtils.shouldUpRecreateTask(this, upIntent)) {  
            // This activity is NOT part of this app's task, so create a new task  
            // when navigating up, with a synthesized back stack.  
            TaskStackBuilder.create(this)  
                    // Add all of this activity's parents to the back stack  
                    .addNextIntentWithParentStack(upIntent)  
                    // Navigate up to the closest parent  
                    .startActivities();  
					//intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
        } else {  
            // This activity is part of this app's task, so simply  
            // navigate up to the logical parent activity.  
            NavUtils.navigateUpTo(this, upIntent);  
        }  
        return true;  
    }  
    return super.onOptionsItemSelected(item);  
}


2.
private void startApplicationDetailsActivity(String packageName) {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                Uri.fromParts("package", packageName, null));
        intent.setComponent(intent.resolveActivity(mContext.getPackageManager()));
        TaskStackBuilder.create(getContext())
                .addNextIntentWithParentStack(intent).startActivities();
    }
```


###Selector
```
state_selected is used when an item is selected using a keyboard/dpad/trackball/etc.
state_activated is used when View.setActivated(true) is called. This is used for "persistent selection" (see Settings on tablet for instance)
state_pressed is used when the user is pressing the item either through touch or a keyboard or a mouse
state_focused is used if the item is marked focusable and it receives focus either through the user of a keyboard/dpad/trackball/etc. or if the item is focusable in touch mode



tab_indicator.xml

<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Non focused states -->
    <item android:state_focused="false" android:state_selected="false" android:state_pressed="false" android:drawable="@drawable/tab_unselected" />
    <item android:state_focused="false" android:state_selected="true" android:state_pressed="false" android:drawable="@drawable/tab_selected" />

    <!-- Focused states -->
    <item android:state_focused="true" android:state_selected="false" android:state_pressed="false" android:drawable="@drawable/tab_focus" />
    <item android:state_focused="true" android:state_selected="true" android:state_pressed="false" android:drawable="@drawable/tab_focus" />

    <!-- Pressed -->
    <item android:state_pressed="true" android:drawable="@drawable/tab_press" />
</selector>
```

###TypedArray
```
		// Get system attrs (android:textSize and android:textColor)
		
		
		private static final int[] ATTRS = new int[] {
			android.R.attr.textSize,
			android.R.attr.textColor
    	};
    	
    	// attrs包含一堆属性，obtainStyledAttributes是获取这一堆属性中的两个
    	// 得到一个属性值数组，通过index获取
		TypedArray a = context.obtainStyledAttributes(attrs, ATTRS);

		tabTextSize = a.getDimensionPixelSize(0, tabTextSize);
		tabTextColor = a.getColor(1, tabTextColor);
		
		
		attrs.xml
		<declare-styleable name="PullToRefresh">
		        
		<!-- Must be one or more (separated by '|') of the following constant values. -->
		<attr name="ptrMode">
            <flag name="disabled" value="0x0" />
            <flag name="pullFromStart" value="0x1" />
            <flag name="pullFromEnd" value="0x2" />
            <flag name="both" value="0x3" />
            <flag name="manualOnly" value="0x4" />

            <!-- These last two are depreacted -->
            <flag name="pullDownFromTop" value="0x1" />
            <flag name="pullUpFromBottom" value="0x2" />
        </attr>
        <attr name="ptrHeaderTextAppearance" format="reference" />
        <attr name="ptrDrawable" format="reference" />
        <attr name="ptrRefreshableViewBackground" format="reference|color" />
		</declare-styleable>
        
        R.java生成了属性数组和每个属性的索引：
        public static final int[] PullToRefresh = {
            0x7f010000, 0x7f010001, 0x7f010002, 0x7f010003,
            0x7f010004, 0x7f010005, 0x7f010006, 0x7f010007,
            0x7f010008, 0x7f010009, 0x7f01000a, 0x7f01000b,
            0x7f01000c, 0x7f01000d, 0x7f01000e, 0x7f01000f,
            0x7f010010, 0x7f010011, 0x7f010012
        };
        
        public static final int PullToRefresh_ptrMode = 4;
        
        
	    layout.xml
        <com.duoku.gamesearch.view.pull.PullToRefreshListView
        xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:ptr="http://schemas.android.com/apk/res-auto"
        android:id="@+id/pull_refresh_list"
        style="@style/content_list"
        android:fadingEdge="none"
        android:scrollbars="none"
        ptr:ptrAnimationStyle="flip"
        ptr:ptrHeaderTextAppearance="@style/pull_header_TextAppearance"
        ptr:ptrListViewExtrasEnabled="false"
        ptr:ptrMode="pullFromStart"
        ptr:ptrOverScroll="false"
        ptr:ptrScrollingWhileRefreshingEnabled="true"
        ptr:ptrShowIndicator="false"
       />

		<style name="pull_header_TextAppearance" parent="@android:style/TextAppearance.Small">
        <item name="android:textColor">#6666</item>
        <item name="android:textSize">13sp</item>
        <item name="android:textStyle">normal</item>
    </style>
    
        代码
        // 通过属性数组获取属性值数组
        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.PullToRefresh);
        //通过index从属性值数组获取属性值
        int mode = a.getInteger(R.styleable.PullToRefresh_ptrMode, 0)
        
        TypedValue styleID = new TypedValue();
		a.getValue(R.styleable.PullToRefresh_ptrHeaderTextAppearance, styleID);
		setTextAppearance(styleID.data);
			
        imageDrawable = attrs.getDrawable(R.styleable.PullToRefresh_ptrDrawable);
        Drawable background = a.getDrawable(R.styleable.PullToRefresh_ptrRefreshableViewBackground);
        
        
        
        
        
        <attr name="tabBackground" format="reference" />
        tabBackgroundResId = a.getResourceId(R.styleable.PagerSlidingTabStrip_tabBackground, tabBackgroundResId);
        
        getLayoutDimension
        
        getString/getText
        
```

###Blur
```
@SuppressLint("NewApi")
	public static Bitmap blur(Context context, Bitmap bkg, float radius) {
		Bitmap overlay = Bitmap.createBitmap(bkg.getWidth(), bkg.getHeight(),
				Bitmap.Config.ARGB_8888);
		Canvas canvas = new Canvas(overlay);
		canvas.drawBitmap(bkg, 0.0F, 0.0F, null);
		RenderScript rs = RenderScript.create(context);
		Allocation overlayAlloc = Allocation.createFromBitmap(rs, overlay);
		ScriptIntrinsicBlur blur = ScriptIntrinsicBlur.create(rs,
				overlayAlloc.getElement());
		blur.setInput(overlayAlloc);
		blur.setRadius(radius);
		blur.forEach(overlayAlloc);
		overlayAlloc.copyTo(overlay);

		rs.destroy();
		return overlay;
	}
  public static void blurBitmap(Context context, Bitmap overlay, float radius)
  {
    RenderScript rs = RenderScript.create(context);
    Allocation overlayAlloc = Allocation.createFromBitmap(
      rs, overlay);
    ScriptIntrinsicBlur blur = ScriptIntrinsicBlur.create(
      rs, overlayAlloc.getElement());
    blur.setInput(overlayAlloc);
    blur.setRadius(radius);
    blur.forEach(overlayAlloc);
    overlayAlloc.copyTo(overlay);
    rs.destroy();
  }
}

```
线程操作经常用到wait和notify，用起来稍显繁琐，而Android给我们封装好了一个ConditionVariable类，用于线程同步。提供了三个方法`block`()、`open`()、`close`()

- void `block`()
	阻塞当前线程，直到条件为open
- boolean `block`(long timeout)
	阻塞当前线程，直到条件为open(返回true)或超时(返回false)
- void `open`()
	释放所有阻塞的线程
- void `close`()
	将条件重置为close
	
```
// variable which controls the notification thread 
    private ConditionVariable mCondition;
 
    @Override
    public void onCreate() {
        mNM = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

        // Start up the thread running the service.  Note that we create a
        // separate thread because the service normally runs in the process's
        // main thread, which we don't want to block.
        Thread notifyingThread = new Thread(null, mTask, "NotifyingService");
        mCondition = new ConditionVariable(false);
        notifyingThread.start();
    }

    @Override
    public void onDestroy() {
        // Cancel the persistent notification.
        mNM.cancel(MOOD_NOTIFICATIONS);
        // Stop the thread from generating further notifications
        mCondition.open();
    }

    private Runnable mTask = new Runnable() {
        public void run() {
            for (int i = 0; i < 4; ++i) {
                showNotification(R.drawable.stat_happy,
                        R.string.status_bar_notifications_happy_message);
                if (mCondition.block(5 * 1000)) 
                    break;
                showNotification(R.drawable.stat_neutral,
                        R.string.status_bar_notifications_ok_message);
                if (mCondition.block(5 * 1000)) 
                    break;
                showNotification(R.drawable.stat_sad,
                        R.string.status_bar_notifications_sad_message);
                if (mCondition.block(5 * 1000)) 
                    break;
            }
            // Done with our work...  stop the service!
            NotifyingService.this.stopSelf();
        }
    };

```

Fragment真正意义上的onResume和onPause
@Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
        if (isVisibleToUser) {
            //相当于Fragment的onResume
        } else {
            //相当于Fragment的onPause
        }
    }
通过阅读ViewPager和PageAdapter相关的代码，切换Fragment实际上就是通过设置setUserVisibleHint和setMenuVisibility来实现的，调用这个方法时并不会释放掉Fragment（即不会执行onDestoryView）。


//  public void dismissAndGoHome() {
//  if (mRecentsPanel != null) {
//      Intent homeIntent = new Intent(Intent.ACTION_MAIN, null);
//      homeIntent.addCategory(Intent.CATEGORY_HOME);
//      homeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK
//              | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
//      startActivityAsUser(homeIntent, new UserHandle(UserHandle.USER_CURRENT));
//      mRecentsPanel.show(false);
//  }
//}

//public void dismissAndGoBack() {
//  if (mRecentsPanel != null) {
//      final ActivityManager am = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
//
//      final List<ActivityManager.RecentTaskInfo> recentTasks =
//              am.getRecentTasks(2,
//                      ActivityManager.RECENT_WITH_EXCLUDED |
//                      ActivityManager.RECENT_IGNORE_UNAVAILABLE);
//      if (recentTasks.size() > 1 &&
//              mRecentsPanel.simulateClick(recentTasks.get(1).persistentId)) {
//          // recents panel will take care of calling show(false) through simulateClick
//          return;
//      }
//      mRecentsPanel.show(false);
//  }
//  finish();
//}

//    public class TouchOutsideListener implements View.OnTouchListener {
//        private StatusBarPanel mPanel;
//
//        public TouchOutsideListener(StatusBarPanel panel) {
//            mPanel = panel;
//        }
//
//        public boolean onTouch(View v, MotionEvent ev) {
//            final int action = ev.getAction();
//            if (action == MotionEvent.ACTION_OUTSIDE
//                    || (action == MotionEvent.ACTION_DOWN
//                    && !mPanel.isInContentArea((int) ev.getX(), (int) ev.getY()))) {
//                dismissAndGoHome();
//                return true;
//            }
//            return false;
//        }
//    }





    
  final LayoutTransition transitioner = new LayoutTransition();
            ((ViewGroup)mRecentsContainer).setLayoutTransition(transitioner);
            createCustomAnimations(transitioner);
    private void createCustomAnimations(LayoutTransition transitioner) {
        transitioner.setDuration(200);
        transitioner.setStartDelay(LayoutTransition.CHANGE_DISAPPEARING, 0);
        transitioner.setAnimator(LayoutTransition.DISAPPEARING, null);
    }


