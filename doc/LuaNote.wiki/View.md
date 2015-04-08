TouchEventTest
TouchView.java
SplitTouchView.java
MultiTouchView.java

###DirectionalViewPager
```
/**
 * Layout manager that allows the user to flip left and right
 * through pages of data.  You supply an implementation of a
 * {@link PagerAdapter} to generate the pages that the view shows.
 *
 * <p>Note this class is currently under early design and
 * development.  The API will likely change in later updates of
 * the compatibility library, requiring changes to the source code
 * of apps when they are compiled against the newer version.</p>
 *
 * <p>ViewPager is most often used in conjunction with {@link android.app.Fragment},
 * which is a convenient way to supply and manage the lifecycle of each page.
 * There are standard adapters implemented for using fragments with the ViewPager,
 * which cover the most common use cases.  These are
 * {@link android.support.v4.app.FragmentPagerAdapter} and 
 * {@link android.support.v4.app.FragmentStatePagerAdapter}; each of these
 * classes have simple code showing how to build a full user interface
 * with them.
 *
 * <p>Here is a more complicated example of ViewPager, using it in conjuction
 * with {@link android.app.ActionBar} tabs.  You can find other examples of using
 * ViewPager in the API 4+ Support Demos and API 13+ Support Demos sample code.
 *
 * {@sample development/samples/Support13Demos/src/com/example/android/supportv13/app/ActionBarTabsPager.java
 *      complete}
 */
```
 ###CheckableRelativeLayout
```
package com.manuelpeinado.multichoiceadapter;

import org.ligi.fast.R;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Checkable;
import android.widget.RelativeLayout;


public class CheckableRelativeLayout extends RelativeLayout implements Checkable {

    private boolean mChecked;

    private static final int[] CHECKED_STATE_SET = { android.R.attr.state_checked };

    public CheckableRelativeLayout(Context context) {
        this(context, null);
        init();
    }

    public CheckableRelativeLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        //        setClickable(true);
        if (getBackground() == null) {
            setBackgroundResource(R.drawable.mca__list_item_selector);
        }
    }

    /**********************/
    /** Handle clicks **/
    /**********************/

    @Override
    public boolean performClick() {
        toggle();
        return super.performClick();
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        return onTouchEvent(ev);
    }

    /**************************/
    /** Checkable **/
    /**************************/

    public void toggle() {
        setChecked(!mChecked);
    }

    public boolean isChecked() {
        return mChecked;
    }

    public void setChecked(boolean checked) {
        if (mChecked != checked) {
            mChecked = checked;
            refreshDrawableState();
            setCheckedRecursive(this, checked);
        }
    }

    private void setCheckedRecursive(ViewGroup parent, boolean checked) {
        int count = parent.getChildCount();
        for (int i = 0; i < count; i++) {
            View v = parent.getChildAt(i);
            if (v instanceof Checkable) {
                ((Checkable) v).setChecked(checked);
            }

            if (v instanceof ViewGroup) {
                setCheckedRecursive((ViewGroup) v, checked);
            }
        }
    }

    /**************************/
    /** Drawable States **/
    /**************************/

    @Override
    protected int[] onCreateDrawableState(int extraSpace) {
        final int[] drawableState = super.onCreateDrawableState(extraSpace + 1);
        if (isChecked()) {
            mergeDrawableStates(drawableState, CHECKED_STATE_SET);
        }
        return drawableState;
    }

    @Override
    protected void drawableStateChanged() {
        super.drawableStateChanged();

        Drawable drawable = getBackground();
        if (drawable != null) {
            int[] myDrawableState = getDrawableState();
            drawable.setState(myDrawableState);
            invalidate();
        }
    }
}
```
###CheckableLinearLayout
```
package com.manuelpeinado.multichoiceadapter;

import org.ligi.fast.R;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Checkable;
import android.widget.LinearLayout;

public class CheckableLinearLayout extends LinearLayout implements Checkable {

    private boolean mChecked;

    private static final int[] CHECKED_STATE_SET = { android.R.attr.state_checked };

    public CheckableLinearLayout(Context context) {
        this(context, null);
        init();
    }

    public CheckableLinearLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    private void init() {
        //        setClickable(true);
        if (getBackground() == null) {
            setBackgroundResource(R.drawable.mca__list_item_selector);
        }
    }

    /**********************/
    /** Handle clicks **/
    /**********************/

    @Override
    public boolean performClick() {
        toggle();
        return super.performClick();
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        return onTouchEvent(ev);
    }

    /**************************/
    /** Checkable **/
    /**************************/

    public void toggle() {
        setChecked(!mChecked);
    }

    public boolean isChecked() {
        return mChecked;
    }

    public void setChecked(boolean checked) {
        if (mChecked != checked) {
            mChecked = checked;
            refreshDrawableState();
            setCheckedRecursive(this, checked);
        }
    }

    private void setCheckedRecursive(ViewGroup parent, boolean checked) {
        int count = parent.getChildCount();
        for (int i = 0; i < count; i++) {
            View v = parent.getChildAt(i);
            if (v instanceof Checkable) {
                ((Checkable) v).setChecked(checked);
            }

            if (v instanceof ViewGroup) {
                setCheckedRecursive((ViewGroup) v, checked);
            }
        }
    }

    /**************************/
    /** Drawable States **/
    /**************************/

    @Override
    protected int[] onCreateDrawableState(int extraSpace) {
        final int[] drawableState = super.onCreateDrawableState(extraSpace + 1);
        if (isChecked()) {
            mergeDrawableStates(drawableState, CHECKED_STATE_SET);
        }
        return drawableState;
    }

    @Override
    protected void drawableStateChanged() {
        super.drawableStateChanged();

        Drawable drawable = getBackground();
        if (drawable != null) {
            int[] myDrawableState = getDrawableState();
            drawable.setState(myDrawableState);
            invalidate();
        }
    }
}
```
###GestureOverlayView
```
A transparent overlay for gesture input that can be placed on top of other
 * widgets or contain other widgets.
```

###DisableableViewPager
```
package com.airlocksoftware.holo.webview;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;

/** Extends ViewPager to allow you to enable / disable swiping between fragments by calling setPagingEnable(). **/
public class DisableableViewPager extends ViewPager {

	private boolean mEnabled = true;

	public DisableableViewPager(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	@Override
	public boolean onTouchEvent(MotionEvent event) {
		if (mEnabled) return super.onTouchEvent(event);
		else return false;
	}

	@Override
	public boolean onInterceptTouchEvent(MotionEvent event) {
		if (mEnabled) return super.onInterceptTouchEvent(event);
		else return false;
	}

	/** Whether or not you can swipe between pages **/
	public void setPagingEnabled(boolean enabled) {
		this.mEnabled = enabled;
	}

}
```
###HackyViewPager
```
uk.co.senab.photoview.sample
/**
 * Hacky fix for Issue #4 and
 * http://code.google.com/p/android/issues/detail?id=18990
 * <p/>
 * ScaleGestureDetector seems to mess up the touch events, which means that
 * ViewGroups which make use of onInterceptTouchEvent throw a lot of
 * IllegalArgumentException: pointerIndex out of range.
 * <p/>
 * There's not much I can do in my code for now, but we can mask the result by
 * just catching the problem and ignoring it.
 *
 * @author Chris Banes
 */
public class HackyViewPager extends ViewPager {

    public HackyViewPager(Context context) {
        super(context);
    }

    public HackyViewPager(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        try {
            return super.onInterceptTouchEvent(ev);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            return false;
        }
    }

}

```

###ShowHideMasterLayout
```


package com.google.android.apps.iosched.ui.widget;

import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.util.AttributeSet;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.ViewGroup;

import static com.google.android.apps.iosched.util.LogUtils.LOGW;
import static com.google.android.apps.iosched.util.LogUtils.makeLogTag;

/**
 * A layout that supports the Show/Hide pattern for portrait tablet layouts. See <a
 * href="http://developer.android.com/design/patterns/multi-pane-layouts.html#orientation">Android
 * Design &gt; Patterns &gt; Multi-pane Layouts & gt; Compound Views and Orientation Changes</a> for
 * more details on this pattern. This layout should normally be used in association with the Up
 * button. Specifically, show the master pane using {@link #showMaster(boolean, int)} when the Up
 * button is pressed. If the master pane is visible, defer to normal Up behavior.
 *
 * <p>TODO: swiping should be more tactile and actually follow the user's finger.
 *
 * <p>Requires API level 11
 */
@TargetApi(Build.VERSION_CODES.HONEYCOMB)
public class ShowHideMasterLayout extends ViewGroup implements Animator.AnimatorListener {

    private static final String TAG = makeLogTag(ShowHideMasterLayout.class);

    /**
     * A flag for {@link #showMaster(boolean, int)} indicating that the change in visiblity should
     * not be animated.
     */
    public static final int FLAG_IMMEDIATE = 0x1;

    private boolean mFirstShow = true;
    private boolean mMasterVisible = true;

    private View mMasterView;
    private View mDetailView;

    private OnMasterVisibilityChangedListener mOnMasterVisibilityChangedListener;

    private GestureDetector mGestureDetector;
    private boolean mFlingToExposeMaster;

    private boolean mIsAnimating;
    private Runnable mShowMasterCompleteRunnable;

    // The last measured master width, including its margins.
    private int mTranslateAmount;

    public interface OnMasterVisibilityChangedListener {
        public void onMasterVisibilityChanged(boolean visible);
    }

    public ShowHideMasterLayout(Context context) {
        super(context);
        init();
    }

    public ShowHideMasterLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public ShowHideMasterLayout(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init();
    }

    private void init() {
        mGestureDetector = new GestureDetector(getContext(), mGestureListener);
    }

    @Override
    public LayoutParams generateLayoutParams(AttributeSet attrs) {
        return new MarginLayoutParams(getContext(), attrs);
    }

    @Override
    protected LayoutParams generateLayoutParams(LayoutParams p) {
        return new MarginLayoutParams(p);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int count = getChildCount();

        // Measure once to find the maximum child size.
        int maxHeight = 0;
        int maxWidth = 0;
        int childState = 0;

        for (int i = 0; i < count; i++) {
            final View child = getChildAt(i);
            if (child.getVisibility() == GONE) {
                continue;
            }

            measureChildWithMargins(child, widthMeasureSpec, 0, heightMeasureSpec, 0);
            final MarginLayoutParams lp = (MarginLayoutParams) child.getLayoutParams();
            maxWidth = Math.max(maxWidth, child.getMeasuredWidth()
                    + lp.leftMargin + lp.rightMargin);
            maxHeight = Math.max(maxHeight, child.getMeasuredHeight()
                    + lp.topMargin + lp.bottomMargin);
            childState = combineMeasuredStates(childState, child.getMeasuredState());
        }

        // Account for padding too
        maxWidth += getPaddingLeft() + getPaddingRight();
        maxHeight += getPaddingLeft() + getPaddingRight();

        // Check against our minimum height and width
        maxHeight = Math.max(maxHeight, getSuggestedMinimumHeight());
        maxWidth = Math.max(maxWidth, getSuggestedMinimumWidth());

        // Set our own measured size
        setMeasuredDimension(
                resolveSizeAndState(maxWidth, widthMeasureSpec, childState),
                resolveSizeAndState(maxHeight, heightMeasureSpec,
                        childState << MEASURED_HEIGHT_STATE_SHIFT));

        // Measure children for them to set their measured dimensions
        for (int i = 0; i < count; i++) {
            final View child = getChildAt(i);
            if (child.getVisibility() == GONE) {
                continue;
            }

            final MarginLayoutParams lp = (MarginLayoutParams) child.getLayoutParams();

            int childWidthMeasureSpec;
            int childHeightMeasureSpec;

            if (lp.width == LayoutParams.MATCH_PARENT) {
                childWidthMeasureSpec = MeasureSpec.makeMeasureSpec(getMeasuredWidth() -
                        getPaddingLeft() - getPaddingRight() -
                        lp.leftMargin - lp.rightMargin,
                        MeasureSpec.EXACTLY);
            } else {
                childWidthMeasureSpec = getChildMeasureSpec(widthMeasureSpec,
                        getPaddingLeft() + getPaddingRight() + lp.leftMargin + lp.rightMargin,
                        lp.width);
            }

            if (lp.height == LayoutParams.MATCH_PARENT) {
                childHeightMeasureSpec = MeasureSpec.makeMeasureSpec(getMeasuredHeight() -
                        getPaddingTop() - getPaddingBottom() -
                        lp.topMargin - lp.bottomMargin,
                        MeasureSpec.EXACTLY);
            } else {
                childHeightMeasureSpec = getChildMeasureSpec(heightMeasureSpec,
                        getPaddingTop() + getPaddingBottom() + lp.topMargin + lp.bottomMargin,
                        lp.height);
            }

            child.measure(childWidthMeasureSpec, childHeightMeasureSpec);
        }
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        updateChildReferences();

        if (mMasterView == null || mDetailView == null) {
            LOGW(TAG, "Master or detail is missing (need 2 children), can't layout.");
            return;
        }

        int masterWidth = mMasterView.getMeasuredWidth();
        MarginLayoutParams masterLp = (MarginLayoutParams) mMasterView.getLayoutParams();
        MarginLayoutParams detailLp = (MarginLayoutParams) mDetailView.getLayoutParams();

        mTranslateAmount = masterWidth + masterLp.leftMargin + masterLp.rightMargin;

        mMasterView.layout(
                l + masterLp.leftMargin,
                t + masterLp.topMargin,
                l + masterLp.leftMargin + masterWidth,
                b - masterLp.bottomMargin);

        mDetailView.layout(
                l + detailLp.leftMargin + mTranslateAmount,
                t + detailLp.topMargin,
                r - detailLp.rightMargin + mTranslateAmount,
                b - detailLp.bottomMargin);

        // Update translationX values
        if (!mIsAnimating) {
            final float translationX = mMasterVisible ? 0 : -mTranslateAmount;
            mMasterView.setTranslationX(translationX);
            mDetailView.setTranslationX(translationX);
        }
    }

    private void updateChildReferences() {
        int childCount = getChildCount();
        mMasterView = (childCount > 0) ? getChildAt(0) : null;
        mDetailView = (childCount > 1) ? getChildAt(1) : null;
    }

    /**
     * Allow or disallow the user to flick right on the detail pane to expose the master pane.
     * @param enabled Whether or not to enable this interaction.
     */
    public void setFlingToExposeMasterEnabled(boolean enabled) {
        mFlingToExposeMaster = enabled;
    }

    /**
     * Request the given listener be notified when the master pane is shown or hidden.
     *
     * @param listener The listener to notify when the master pane is shown or hidden.
     */
    public void setOnMasterVisibilityChangedListener(OnMasterVisibilityChangedListener listener) {
        mOnMasterVisibilityChangedListener = listener;
    }

    /**
     * Returns whether or not the master pane is visible.
     *
     * @return True if the master pane is visible.
     */
    public boolean isMasterVisible() {
        return mMasterVisible;
    }

    /**
     * Calls {@link #showMaster(boolean, int, Runnable)} with a null runnable.
     */
    public void showMaster(boolean show, int flags) {
        showMaster(show, flags, null);
    }

    /**
     * Shows or hides the master pane.
     *
     * @param show  Whether or not to show the master pane.
     * @param flags {@link #FLAG_IMMEDIATE} to show/hide immediately, or 0 to animate.
     * @param completeRunnable An optional runnable to run when any animations related to this are
     *                         complete.
     */
    public void showMaster(boolean show, int flags, Runnable completeRunnable) {
        if (!mFirstShow && mMasterVisible == show) {
            return;
        }

        mShowMasterCompleteRunnable = completeRunnable;
        mFirstShow = false;

        mMasterVisible = show;
        if (mOnMasterVisibilityChangedListener != null) {
            mOnMasterVisibilityChangedListener.onMasterVisibilityChanged(show);
        }

        updateChildReferences();

        if (mMasterView == null || mDetailView == null) {
            LOGW(TAG, "Master or detail is missing (need 2 children), can't change translation.");
            return;
        }

        final float translationX = show ? 0 : -mTranslateAmount;

        if ((flags & FLAG_IMMEDIATE) != 0) {
            mMasterView.setTranslationX(translationX);
            mDetailView.setTranslationX(translationX);
            if (mShowMasterCompleteRunnable != null) {
                mShowMasterCompleteRunnable.run();
                mShowMasterCompleteRunnable = null;
            }
        } else {
            final long duration = getResources().getInteger(android.R.integer.config_shortAnimTime);

            // Animate if we have Honeycomb APIs, don't animate otherwise
            mIsAnimating = true;
            AnimatorSet animatorSet = new AnimatorSet();
            mMasterView.setLayerType(LAYER_TYPE_HARDWARE, null);
            mDetailView.setLayerType(LAYER_TYPE_HARDWARE, null);
            animatorSet
                    .play(ObjectAnimator
                            .ofFloat(mMasterView, "translationX", translationX)
                            .setDuration(duration))
                    .with(ObjectAnimator
                            .ofFloat(mDetailView, "translationX", translationX)
                            .setDuration(duration));
            animatorSet.addListener(this);
            animatorSet.start();

            // For API level 12+, use this instead:
            // mMasterView.animate().translationX().setDuration(duration);
            // mDetailView.animate().translationX(show ? masterWidth : 0).setDuration(duration);
        }
    }

    @Override
    public void requestDisallowInterceptTouchEvent(boolean disallowIntercept) {
        // Really bad hack... we really shouldn't do this.
        //super.requestDisallowInterceptTouchEvent(disallowIntercept);
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent event) {
        if (mFlingToExposeMaster
                && !mMasterVisible) {
            mGestureDetector.onTouchEvent(event);
        }

        if (event.getAction() == MotionEvent.ACTION_DOWN && mMasterView != null && mMasterVisible) {
            // If the master is visible, touching in the detail area should hide the master.
            if (event.getX() > mTranslateAmount) {
                return true;
            }
        }
        return super.onInterceptTouchEvent(event);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (mFlingToExposeMaster
                && !mMasterVisible
                && mGestureDetector.onTouchEvent(event)) {
            return true;
        }

        if (event.getAction() == MotionEvent.ACTION_DOWN && mMasterView != null && mMasterVisible) {
            // If the master is visible, touching in the detail area should hide the master.
            if (event.getX() > mTranslateAmount) {
                showMaster(false, 0);
                return true;
            }
        }
        return super.onTouchEvent(event);
    }

    @Override
    public void onAnimationStart(Animator animator) {
    }

    @Override
    public void onAnimationEnd(Animator animator) {
        mIsAnimating = false;
        mMasterView.setLayerType(LAYER_TYPE_NONE, null);
        mDetailView.setLayerType(LAYER_TYPE_NONE, null);
        requestLayout();
        if (mShowMasterCompleteRunnable != null) {
            mShowMasterCompleteRunnable.run();
            mShowMasterCompleteRunnable = null;
        }
    }

    @Override
    public void onAnimationCancel(Animator animator) {
        mIsAnimating = false;
        mMasterView.setLayerType(LAYER_TYPE_NONE, null);
        mDetailView.setLayerType(LAYER_TYPE_NONE, null);
        requestLayout();
        if (mShowMasterCompleteRunnable != null) {
            mShowMasterCompleteRunnable.run();
            mShowMasterCompleteRunnable = null;
        }
    }

    @Override
    public void onAnimationRepeat(Animator animator) {
    }

    private final GestureDetector.OnGestureListener mGestureListener =
            new GestureDetector.SimpleOnGestureListener() {
                @Override
                public boolean onDown(MotionEvent e) {
                    return true;
                }

                @Override
                public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX,
                        float velocityY) {
                    ViewConfiguration viewConfig = ViewConfiguration.get(getContext());
                    float absVelocityX = Math.abs(velocityX);
                    float absVelocityY = Math.abs(velocityY);
                    if (mFlingToExposeMaster
                            && !mMasterVisible
                            && velocityX > 0
                            && absVelocityX >= absVelocityY // Fling at least as hard in X as in Y
                            && absVelocityX > viewConfig.getScaledMinimumFlingVelocity()
                            && absVelocityX < viewConfig.getScaledMaximumFlingVelocity()) {
                        showMaster(true, 0);
                        return true;
                    }
                    return super.onFling(e1, e2, velocityX, velocityY);
                }
            };
}

```