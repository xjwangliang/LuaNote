/*
*
*
*/
package com.opt.utils;

import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.ContentObserver;
import android.net.wifi.WifiManager;
import android.os.Handler;
import android.provider.Settings;
import android.util.Log;

/**
 * wifi状态变化监听类
 * @author     jason
 * @date       2012-9-25
 * 
 */

public class HardwareStateUtil {
	/**
	 * 意图过滤器
	 */
	private IntentFilter mFilter;
	
	private Context mContext;
	/**
	 * 硬件状态变化广播接收器
	 */
	private HardwareStateChangeReceiver mHardwareStateChangeReceiver;
	/**
	 * 硬件状态变化回调接口
	 */
	private HardwareStateChangeCallback mHardwareStateChangeCallback;
	
	private Handler mHandler;
	
	public interface HardwareStateChangeCallback{
		/**
		 * wifi开启
		 */
		public void wifiStateEnabled();
		/**
		 * wifi关闭
		 */
		public void wifiStateDisabled();
		/**
		 * 飞行模式开启
		 */
		public void airplaneEnabled();
		/**
		 * 飞行模式关闭
		 */
		public void airplaneDisabled();
		/**
		 * 蓝牙开启
		 */
		public void bluetoothEnabled();
		/**
		 * 蓝牙关闭
		 */
		public void bluetoothDisabled();
		/**
		 * gps开启
		 */
		public void gpsEnabled();
		/**
		 * gps关闭
		 */
		public void gpsDisabled();
		/**
		 * 屏幕亮度改变
		 */
		public void brightnessChanged();
	}
	
	private class HardwareStateChangeReceiver extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			if(WifiManager.WIFI_STATE_CHANGED_ACTION.equals(intent.getAction())){
				switch(intent.getIntExtra(WifiManager.EXTRA_WIFI_STATE, WifiManager.WIFI_STATE_UNKNOWN)){
					case WifiManager.WIFI_STATE_ENABLED:
						onWifiStateEnabled();
						break;
					case WifiManager.WIFI_STATE_DISABLED:
						onWifiStateDisabled();
						break;
					case WifiManager.WIFI_STATE_ENABLING:
						onWifiStateEnabled();
						break;
					case WifiManager.WIFI_STATE_DISABLING:
						onWifiStateDisabled();
						break;
					default:
						break;
				}
			}
			else if(Intent.ACTION_AIRPLANE_MODE_CHANGED.equals(intent.getAction())){
				boolean state = intent.getBooleanExtra("state", false);
				if(state){
					onAirplaneEnabled();
				}
				else{
					onAirplaneDisabled();
				}
			}
			else if(BluetoothAdapter.ACTION_STATE_CHANGED.equals(intent.getAction())){
				switch(intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR)){
					case BluetoothAdapter.STATE_ON:
						onBluetoothEnabled();
						break;
					case BluetoothAdapter.STATE_OFF:
						onBluetoothDisabled();
						break;
					case BluetoothAdapter.STATE_TURNING_ON:
						onBluetoothEnabled();
						break;
					case BluetoothAdapter.STATE_TURNING_OFF:
						onBluetoothDisabled();
						break;
					default:
						break;
				}
			}
		}
		
	}
	
	/**
	 * 监听gps状态变化
	 */
	private ContentObserver mGpsObserver = new ContentObserver(new Handler()) {

         @Override
         public void onChange(boolean selfChange) {
                 super.onChange(selfChange);
                 if(HardwareUtil.isGPSEnable(mContext)){
                	 onGpsEnabled();
                 }
                 else{
                	 onGpsDisabled();
                 }
         }
         
 	};
 	
 	/**
	 * 监听屏幕亮度变化
	 */
 	private ContentObserver mBrightnessObserver = new ContentObserver(new Handler()) {

        @Override
        public void onChange(boolean selfChange) {
                super.onChange(selfChange);
                onBrightnessChanged();
        }
        
	};
	
	public void onWifiStateEnabled(){
		if(mHandler==null){
			Log.e(HardwareStateUtil.class.getSimpleName(), "mHandler is null");
			return;
		}
		mHandler.post(new Runnable() {
			
			public void run() {
				if(mHardwareStateChangeCallback==null){
					Log.e(HardwareStateUtil.class.getSimpleName(), "mHardwareStateChangeCallback is null");
					return;
				}
				mHardwareStateChangeCallback.wifiStateEnabled();
			}
		});
	}
	
	public void onWifiStateDisabled(){
		if(mHandler==null){
			Log.e(HardwareStateUtil.class.getSimpleName(), "mHandler is null");
			return;
		}
		mHandler.post(new Runnable() {
			
			public void run() {
				if(mHardwareStateChangeCallback==null){
					Log.e(HardwareStateUtil.class.getSimpleName(), "mHardwareStateChangeCallback is null");
					return;
				}
				mHardwareStateChangeCallback.wifiStateDisabled();
			}
		});
	}
	
	public void onAirplaneEnabled(){
		if(mHandler==null){
			Log.e(HardwareStateUtil.class.getSimpleName(), "mHandler is null");
			return;
		}
		mHandler.post(new Runnable() {
			
			public void run() {
				if(mHardwareStateChangeCallback==null){
					Log.e(HardwareStateUtil.class.getSimpleName(), "mHardwareStateChangeCallback is null");
					return;
				}
				mHardwareStateChangeCallback.airplaneEnabled();
			}
		});
	}
	
	public void onAirplaneDisabled(){
		if(mHandler==null){
			Log.e(HardwareStateUtil.class.getSimpleName(), "mHandler is null");
			return;
		}
		mHandler.post(new Runnable() {
			
			public void run() {
				if(mHardwareStateChangeCallback==null){
					Log.e(HardwareStateUtil.class.getSimpleName(), "mHardwareStateChangeCallback is null");
					return;
				}
				mHardwareStateChangeCallback.airplaneDisabled();
			}
		});
	}
	
	public void onBluetoothEnabled(){
		if(mHandler==null){
			Log.e(HardwareStateUtil.class.getSimpleName(), "mHandler is null");
			return;
		}
		mHandler.post(new Runnable() {
			
			public void run() {
				if(mHardwareStateChangeCallback==null){
					Log.e(HardwareStateUtil.class.getSimpleName(), "mHardwareStateChangeCallback is null");
					return;
				}
				mHardwareStateChangeCallback.bluetoothEnabled();
			}
		});
	}
	
	public void onBluetoothDisabled(){
		if(mHandler==null){
			Log.e(HardwareStateUtil.class.getSimpleName(), "mHandler is null");
			return;
		}
		mHandler.post(new Runnable() {
			
			public void run() {
				if(mHardwareStateChangeCallback==null){
					Log.e(HardwareStateUtil.class.getSimpleName(), "mHardwareStateChangeCallback is null");
					return;
				}
				mHardwareStateChangeCallback.bluetoothDisabled();
			}
		});
	}
	
	private void onGpsEnabled(){
		if(mHandler==null){
			Log.e(HardwareStateUtil.class.getSimpleName(), "mHandler is null");
			return;
		}
		mHandler.post(new Runnable() {
			
			public void run() {
				if(mHardwareStateChangeCallback==null){
					Log.e(HardwareStateUtil.class.getSimpleName(), "mHardwareStateChangeCallback is null");
					return;
				}
				mHardwareStateChangeCallback.gpsEnabled();
			}
		});
	}
	
	private void onGpsDisabled(){
		if(mHandler==null){
			Log.e(HardwareStateUtil.class.getSimpleName(), "mHandler is null");
			return;
		}
		mHandler.post(new Runnable() {
			
			public void run() {
				if(mHardwareStateChangeCallback==null){
					Log.e(HardwareStateUtil.class.getSimpleName(), "mHardwareStateChangeCallback is null");
					return;
				}
				mHardwareStateChangeCallback.gpsDisabled();
			}
		});
	}
	
	private void onBrightnessChanged(){
		if(mHandler==null){
			Log.e(HardwareStateUtil.class.getSimpleName(), "mHandler is null");
			return;
		}
		mHandler.post(new Runnable() {
			
			public void run() {
				if(mHardwareStateChangeCallback==null){
					Log.e(HardwareStateUtil.class.getSimpleName(), "mHardwareStateChangeCallback is null");
					return;
				}
				mHardwareStateChangeCallback.brightnessChanged();
			}
		});
	}
	
	public HardwareStateUtil(Context context, Handler handler){
		mContext = context;
		mHandler = handler;
		mFilter = new IntentFilter();
		mFilter.addAction(WifiManager.WIFI_STATE_CHANGED_ACTION);
		mFilter.addAction(Intent.ACTION_AIRPLANE_MODE_CHANGED);
		mFilter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
		mHardwareStateChangeReceiver = new HardwareStateChangeReceiver();
	}
	
	public void setmHardwareStateChangeCallback(
			HardwareStateChangeCallback mHardwareStateChangeCallback) {
		this.mHardwareStateChangeCallback = mHardwareStateChangeCallback;
	}
	
	
	/**
	 * 注册监听广播
	 */
	public void register(){
		mContext.registerReceiver(mHardwareStateChangeReceiver, mFilter);
		mContext.getContentResolver().registerContentObserver(Settings.Secure.CONTENT_URI, true, mGpsObserver);
		mContext.getContentResolver().registerContentObserver(Settings.System.CONTENT_URI, true, mBrightnessObserver);
	}
	
	/**
	 * 注销监听广播
	 */
	public void unregister(){
		mContext.unregisterReceiver(mHardwareStateChangeReceiver);
		mContext.getContentResolver().unregisterContentObserver(mGpsObserver);
		mContext.getContentResolver().unregisterContentObserver(mBrightnessObserver);
	}

}
