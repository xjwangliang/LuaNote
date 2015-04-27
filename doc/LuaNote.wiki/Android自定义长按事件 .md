Android自定义长按事件

http://chroya.iteye.com/blog/804706
Android系统自带了长按事件，setOnLongClickListener即可监听。但是有时候，你不希望用系统的长按事件，比如当希望长按的时间更长一点的时候。这时候就需要自己来定义这个长按事件了
 

主要思路是在down的时候，让一个Runnable一段时间后执行，如果时间到了，没有移动超过定义的阈值，也没有释放，则触发长按事件。在真实环境中，当长按触发之后，还需要将后来的move和up事件屏蔽掉。此处是示例，就略去了。

```
package chroya.fun;

import android.content.Context;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;

public class LongPressView1 extends View{
	private int mLastMotionX, mLastMotionY;
	//是否移动了
	private boolean isMoved;
	//是否释放了
	private boolean isReleased;
	//计数器，防止多次点击导致最后一次形成longpress的时间变短
	private int mCounter;
	//长按的runnable
	private Runnable mLongPressRunnable;
	//移动的阈值
	private static final int TOUCH_SLOP = 20;

	public LongPressView1(Context context) {
		super(context);
		mLongPressRunnable = new Runnable() {
			
			@Override
			public void run() {
				mCounter--;
				//计数器大于0，说明当前执行的Runnable不是最后一次down产生的。
				if(mCounter>0 || isReleased || isMoved) return;
				performLongClick();
			}
		};
	}

	public boolean dispatchTouchEvent(MotionEvent event) {
		int x = (int) event.getX();
		int y = (int) event.getY();
		
		switch(event.getAction()) {
		case MotionEvent.ACTION_DOWN:
			mLastMotionX = x;
			mLastMotionY = y;
			mCounter++;
			isReleased = false;
			isMoved = false;
			postDelayed(mLongPressRunnable, ViewConfiguration.getLongPressTimeout());
			break;
		case MotionEvent.ACTION_MOVE:
			if(isMoved) break;
			if(Math.abs(mLastMotionX-x) > TOUCH_SLOP 
					|| Math.abs(mLastMotionY-y) > TOUCH_SLOP) {
				//移动超过阈值，则表示移动了
				isMoved = true;
			}
			break;
		case MotionEvent.ACTION_UP:
			//释放了
			isReleased = true;
			break;
		}
		return true;
	}
}

```

思路跟第一种差不多，不过，在移动超过阈值和释放之后，会将Runnable从事件队列中remove掉，长按事件也就不会再触发了。源码中实现长按的原理也基本如此

```
package chroya.fun;

import android.content.Context;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;

public class LongPressView2 extends View{
	private int mLastMotionX, mLastMotionY;
	//是否移动了
	private boolean isMoved;
	//长按的runnable
	private Runnable mLongPressRunnable;
	//移动的阈值
	private static final int TOUCH_SLOP = 20;

	public LongPressView2(Context context) {
		super(context);
		mLongPressRunnable = new Runnable() {
			
			@Override
			public void run() {				
				performLongClick();
			}
		};
	}

	public boolean dispatchTouchEvent(MotionEvent event) {
		int x = (int) event.getX();
		int y = (int) event.getY();
		
		switch(event.getAction()) {
		case MotionEvent.ACTION_DOWN:
			mLastMotionX = x;
			mLastMotionY = y;
			isMoved = false;
			postDelayed(mLongPressRunnable, ViewConfiguration.getLongPressTimeout());
			break;
		case MotionEvent.ACTION_MOVE:
			if(isMoved) break;
			if(Math.abs(mLastMotionX-x) > TOUCH_SLOP 
					|| Math.abs(mLastMotionY-y) > TOUCH_SLOP) {
				//移动超过阈值，则表示移动了
				isMoved = true;
				removeCallbacks(mLongPressRunnable);
			}
			break;
		case MotionEvent.ACTION_UP:
			//释放了
			removeCallbacks(mLongPressRunnable);
			break;
		}
		return true;
	}
}
```
 原理是这样的：down的时候，重置ConditionVariable的状态，开启一个线程，线程里面将阻塞指定的时间。如果阻塞时间已到，线程醒了，还未up，则形成长按。如果在线程醒来之前就释放了，则当到线程醒来的时候，执行判断，得知已经up，则未形成长按。
    每次down都创建一个线程，很浪费资源，所以这不是自定义长按事件的好方法，好方法在上一篇博文中，这仅为讲解ConditionVariable用。

```
package chroya.fun;

import android.content.Context;
import android.os.ConditionVariable;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;

public class LongPressView3 extends View{
	private ConditionVariable cv = new ConditionVariable();
	private Thread longPressThread;
	private Runnable longPressRunnable;
	//是否释放
	private boolean isReleased;

	public LongPressView3(Context context) {
		super(context);
		longPressRunnable = new Runnable() {
			public void run() {
				//阻塞指定的时间
				cv.block(ViewConfiguration.getLongPressTimeout());
				if(!isReleased) {
					//还没up，则触发长按
					performLongClick();
				}
			}
		};
		createThread();
		post(null);		
	}
	
	private void createThread() {		
		longPressThread = new Thread(longPressRunnable);
	}

	@Override
	public boolean dispatchTouchEvent(MotionEvent event) {
		int action = event.getAction();
		switch(action) {
		case MotionEvent.ACTION_DOWN:
			isReleased = false;
			//重置为close状态
			cv.close();	
			createThread();
			longPressThread.start();
			break;
		case MotionEvent.ACTION_MOVE:
			break;			
		case MotionEvent.ACTION_UP:
			//up掉
			isReleased = true;
			//打开阻塞的线程
			cv.open();
			break;			
		}
		return true;
	}	
}

```