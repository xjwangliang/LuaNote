package org.wangliang.doc;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.ComponentCallbacks2;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.drawable.ColorDrawable;
import android.provider.Settings;
import android.provider.Settings.SettingNotFoundException;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.animation.TranslateAnimation;

public class Util {

	//android.os.ConditionVariable;
	

	
	/**
	 * 若之前是自动调节则恢复
	 */
	private void recoverScreenBrightness(Context context, boolean mode){
		if(mode) Settings.System.putInt(context.getContentResolver(), "screen_brightness_mode", 1);
	}
	
	/**
	 * 修改当前屏幕亮度
	 * 只在当前页面起作用
	 */
	private void modifyScreenBrightness(Activity context, boolean mode,int brightness){
		if(brightness<10) brightness = 10;
		if(mode) Settings.System.putInt(context.getContentResolver(), "screen_brightness_mode", 0);
		WindowManager.LayoutParams lp = context.getWindow().getAttributes();
		lp.screenBrightness = brightness / 100f;
		context.getWindow().setAttributes(lp);
	}
	
	private boolean isAutoBrightness(Context context) throws SettingNotFoundException{
		/*try {
			int i = Settings.System.getInt(
					context.getContentResolver(), "screen_brightness");
		} catch (SettingNotFoundException e) {
			e.printStackTrace();
		}*/
		
		if(Settings.System.getInt(context.getContentResolver(),"screen_brightness_mode")==1){
			return true;
		}else{
			return false;
		}
	}
	
	@SuppressLint("NewApi")
	private void registerComponent(Context context) {
		context.registerComponentCallbacks(new ComponentCallbacks2() {
			
			@Override
			public void onLowMemory() {
			}
			
			@Override
			public void onConfigurationChanged(Configuration newConfig) {
				
			}

			@Override
			public void onTrimMemory(int level) {
				
			}
		});
	}
	
	
	// QQ Translation
		private void testQQ(Activity context) {
			int ANIM_DURATION = 600;
			View view = ((ViewGroup) context.getWindow().getDecorView()).getChildAt(0);
			Dialog dialog = new Dialog(context);
			dialog.setCanceledOnTouchOutside(true);
			int i = 10;// this.jdField_a_of_type_ComTencentMobileqqWidgetMyWorkspace.getTop();
			TranslateAnimation animUp = new TranslateAnimation(0.0F, 0.0F, 0.0F, -i);
			animUp.setDuration(ANIM_DURATION);
			animUp.setFillAfter(true);
			view.startAnimation(animUp);
			
			dialog.requestWindowFeature(1);// R.style.Default.NoTitleBar
			dialog.getWindow().setSoftInputMode(4);
			dialog.setContentView(2130903090);

			dialog.findViewById(2131624205).setVisibility(8);
			WindowManager.LayoutParams lp = dialog.getWindow().getAttributes();
			lp.x = 0;
			lp.y = 0;
			lp.width = -1;
			lp.windowAnimations = android.R.style.Animation ;//16973824;
			lp.gravity = 51;

			dialog.getWindow().setBackgroundDrawable(new ColorDrawable());
			TranslateAnimation animDown = new TranslateAnimation(0.0F, 0.0F, -i,
					0.0F);

			animDown.setDuration(ANIM_DURATION);
			// animUp.setAnimationListener(localjt);
			// animDown.setAnimationListener(localjt);
			// dialog.setOnDismissListener(new ju(this, localView, animDown));
		}

}
