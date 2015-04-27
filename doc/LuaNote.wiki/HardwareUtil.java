package com.opt.utils;

import java.lang.reflect.Method;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.net.wifi.WifiManager;
import android.provider.Settings;
import android.provider.Settings.SettingNotFoundException;
import android.telephony.TelephonyManager;
import android.view.WindowManager;

public class HardwareUtil extends Activity {
	
	/**
	 * 操作wifi
	 * 
	 * @param context
	 * @param state
	 * @return
	 */
	public static boolean operateWifi(Context context, boolean state) {
		try {
			WifiManager wifiManager = (WifiManager) context
					.getSystemService(Context.WIFI_SERVICE);
			if (WifiManager.WIFI_STATE_UNKNOWN == wifiManager.getWifiState()) {
				return false;
			}
			if (state == true) {
				openWifi(wifiManager);
			} else {
				closeWifi(wifiManager);
			}
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 获取wifi状态
	 * 
	 * @param context
	 * @return
	 */
	public static boolean getWifiState(Context context) {
		WifiManager wifiManager = (WifiManager) context
				.getSystemService(Context.WIFI_SERVICE);
		switch (wifiManager.getWifiState()) {
			case WifiManager.WIFI_STATE_ENABLED:
				return true;
			case WifiManager.WIFI_STATE_DISABLED:
				return false;
			default:
				return false;
		}
	}

	/**
	 * 开启wifi
	 * 
	 * @param wifiManager
	 * @return
	 */
	private static boolean openWifi(WifiManager wifiManager) {
		if (!wifiManager.isWifiEnabled()) {
			return wifiManager.setWifiEnabled(true);
		} else {
			return false;
		}
	}

	/**
	 * 关闭wifi
	 * 
	 * @param wifiManager
	 * @return
	 */
	private static boolean closeWifi(WifiManager wifiManager) {
		if (!wifiManager.isWifiEnabled()) {
			return true;
		} else {
			return wifiManager.setWifiEnabled(false);
		}
	}

	/**
	 * 操作蓝牙
	 * 
	 * @param context
	 * @param state
	 * @return
	 */
	public static boolean operateBluetooth(Context context, boolean state) {
		if (isBluetoothEnable(context) == -1) {
			return false;
		}
		if (state && isBluetoothEnable(context) == 0) {
			if (Integer.valueOf(android.os.Build.VERSION.SDK) >= 5) {
				return enableBluetooth(context);
			} else {
				return toggleBluetooth(context);
			}
		} else if (!state && isBluetoothEnable(context) == 1) {
			if (Integer.valueOf(android.os.Build.VERSION.SDK) >= 5) {
				return disableBluetooth(context);
			} else {
				return toggleBluetooth(context);
			}
		}
		return true;
	}

	/**
	 * 启动蓝牙
	 * 
	 * @param context
	 * @return
	 */
	private static boolean enableBluetooth(Context context) {
		Object device = null;
		Method enableMethod = null;
		try {
			device = context.getSystemService("bluetooth");
			Class c1 = device.getClass();
			enableMethod = c1.getMethod("enable", new Class[0]);
			enableMethod.setAccessible(true);
		} catch (Exception e) {
			try {
				Class c2 = ClassLoader.getSystemClassLoader().loadClass(
						"android.bluetooth.BluetoothAdapter");
				Method localMethod = c2.getMethod("getDefaultAdapter",
						new Class[0]);
				device = localMethod.invoke(null, new Object[0]);
				enableMethod = c2.getMethod("enable", new Class[0]);
			} catch (Exception e1) {
			}
		}
		if (device != null && enableMethod != null) {
			try {
				enableMethod.invoke(device, new Object[0]);
				return true;
			} catch (Exception e) {
			}
		}
		return false;
	}

	/**
	 * 关闭蓝牙
	 * 
	 * @param context
	 * @return
	 */
	private static boolean disableBluetooth(Context context) {
		Object device = null;
		Method disableMethod = null;
		try {
			device = context.getSystemService("bluetooth");
			Class c1 = device.getClass();
			disableMethod = c1.getMethod("disable", new Class[0]);
			disableMethod.setAccessible(true);
		} catch (Exception e) {
			try {
				Class c2 = ClassLoader.getSystemClassLoader().loadClass(
						"android.bluetooth.BluetoothAdapter");
				Method localMethod = c2.getMethod("getDefaultAdapter",
						new Class[0]);
				device = localMethod.invoke(null, new Object[0]);
				disableMethod = c2.getMethod("disable", new Class[0]);
			} catch (Exception e1) {
			}
		}
		if (device != null && disableMethod != null) {
			try {
				disableMethod.invoke(device, new Object[0]);
				return true;
			} catch (Exception e) {
			}
		}
		return false;
	}

	/**
	 * 操作蓝牙
	 * 
	 * @param context
	 * @return
	 */
	private static boolean toggleBluetooth(Context context) {
		try {
			Intent bluetoothIntent = new Intent();
			bluetoothIntent.setClassName("com.android.settings",
					"com.android.settings.widget.SettingsAppWidgetProvider");
			bluetoothIntent.addCategory("android.intent.category.ALTERNATIVE");
			bluetoothIntent.setData(Uri.parse("custom:4"));
			PendingIntent.getBroadcast(context, 0, bluetoothIntent, 0).send();
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 获取蓝牙的状态
	 * 
	 * @param context
	 * @return
	 */
	public static int isBluetoothEnable(Context context) {
		try {
			String str = Settings.Secure.getString(
					context.getContentResolver(), Settings.Secure.BLUETOOTH_ON);
			if (str != null && str.contains("1")) {
				return 1;
			} else {
				return 0;
			}
		} catch (Exception e) {
		}
		return 0;
	}

	/**
	 * 操作gps
	 * 
	 * @param context
	 * @param state
	 * @return
	 */
	public static boolean operateGPS(Context context, boolean state) {
		try {
			if (state && !isGPSEnable(context)) {
				toggleGPS(context);
			} else if (!state && isGPSEnable(context)) {
				toggleGPS(context);
			}
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 操作gps
	 * 
	 * @param context
	 * @throws Exception
	 */
	private static void toggleGPS(Context context) throws Exception {
		Intent gpsIntent = new Intent();
		gpsIntent.setClassName("com.android.settings",
				"com.android.settings.widget.SettingsAppWidgetProvider");
		gpsIntent.addCategory("android.intent.category.ALTERNATIVE");
		gpsIntent.setData(Uri.parse("custom:3"));
		PendingIntent.getBroadcast(context, 0, gpsIntent, 0).send();
	}

	/**
	 * 获取gps的状态
	 * 
	 * @param context
	 * @return
	 */
	public static boolean isGPSEnable(Context context) {
		String str = Settings.Secure.getString(context.getContentResolver(),
				Settings.Secure.LOCATION_PROVIDERS_ALLOWED);
		if (str != null) {
			return str.contains("gps");
		} else {
			return false;
		}
	}

	/**
	 * 操作同步
	 * 
	 * @param context
	 * @param state
	 * @return
	 */
	public static boolean operateSyn(Context context, boolean state) {
		if (isSynEnable(context) == -1) {
			return false;
		}
		if (state && isSynEnable(context) == 0) {
			return setMasterSyncAutomatically(state);
		} else if (!state && isSynEnable(context) == 1) {
			return setMasterSyncAutomatically(state);
		}
		return true;
	}

	
	private static boolean toggleSyn(Context context) {
		try {
			Intent synIntent = new Intent();
			synIntent.setClassName("com.android.settings",
					"com.android.settings.widget.SettingsAppWidgetProvider");
			synIntent.addCategory("android.intent.category.ALTERNATIVE");
			synIntent.setData(Uri.parse("custom:2"));
			PendingIntent.getBroadcast(context, 0, synIntent, 0).send();
			return true;
		} catch (Exception e) { 
		}
		return false;
	}

	/**
	 * 操作同步
	 * 
	 * @param state
	 * @return
	 */
	private static boolean setMasterSyncAutomatically(boolean state) {
		try {
			Method method = ContentResolver.class.getMethod(
					"setMasterSyncAutomatically", boolean.class);
			method.invoke(null, state);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * 获取同步状态
	 * 
	 * @param context
	 * @return
	 */
	public static int isSynEnable(Context context) {
		int temp = -1;
		try {
			Method method = ContentResolver.class.getMethod(
					"getMasterSyncAutomatically", new Class[0]);
			boolean b = ((Boolean) method.invoke(ContentResolver.class,
					new Object[0])).booleanValue();
			temp = b ? 1 : 0;
		} catch (Exception e) {
			return -1;
		}
		return temp;
	}

	/**
	 * 设置声音振动模式
	 * 
	 * @param mAudioManager
	 * @param silent
	 * @param vibrate
	 * @return
	 */
	public static boolean operateRingerMode(AudioManager mAudioManager,
			boolean silent, boolean vibrate) {
		try {
			if (!silent) {
				mAudioManager
						.setRingerMode(vibrate ? AudioManager.RINGER_MODE_VIBRATE
								: AudioManager.RINGER_MODE_SILENT);
			} else {
				mAudioManager.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
				mAudioManager.setVibrateSetting(
						AudioManager.VIBRATE_TYPE_RINGER,
						vibrate ? AudioManager.VIBRATE_SETTING_ON
								: AudioManager.VIBRATE_SETTING_OFF);
			}
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 设置声音振动模式
	 * 
	 * @param context
	 * @param silent
	 * @param vibrate
	 */
	public static void operateRingerMode(Context context, boolean silent,
			boolean vibrate) {
		AudioManager audiomanage = (AudioManager) context
				.getSystemService(Context.AUDIO_SERVICE);
		try {
			if (silent) {
				audiomanage
						.setRingerMode(vibrate ? AudioManager.RINGER_MODE_VIBRATE
								: AudioManager.RINGER_MODE_SILENT);
			} else {
				audiomanage.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
				audiomanage.setVibrateSetting(AudioManager.VIBRATE_TYPE_RINGER,
						vibrate ? AudioManager.VIBRATE_SETTING_ON
								: AudioManager.VIBRATE_SETTING_OFF);
			}
		} catch (Exception e) {
		}
	}

	/**
	 * 获取声音模式
	 * 
	 * @param context
	 * @return
	 */
	public static boolean isSilent(Context context) {
		AudioManager audiomanage = (AudioManager) context
				.getSystemService(Context.AUDIO_SERVICE);
		int mode = audiomanage.getRingerMode();
		if (mode == AudioManager.RINGER_MODE_VIBRATE
				|| mode == AudioManager.RINGER_MODE_SILENT) {
			return true;
		}
		return false;
	}

	/**
	 * 获取振动模式
	 * 
	 * @param context
	 * @return
	 */
	public static boolean isVibrate(Context context) {
		AudioManager audiomanage = (AudioManager) context
				.getSystemService(Context.AUDIO_SERVICE);
		int mode = audiomanage.getRingerMode();
		if (mode == AudioManager.RINGER_MODE_VIBRATE) {
			return true;
		} else if (mode == AudioManager.RINGER_MODE_NORMAL) {
			if (audiomanage.getVibrateSetting(AudioManager.VIBRATE_TYPE_RINGER) == AudioManager.VIBRATE_SETTING_OFF) {
				return false;
			} else {
				return true;
			}
		} else {
			return false;
		}
	}

	/**
	 * 设置屏幕亮度
	 * 
	 * @param context
	 * @param brightness
	 * @return
	 */
	public static boolean operateBrightness(Context context, float brightness) {
		try {
			if (brightness < 0) {
				brightness = 0.05f;
			}
			if (brightness > 1) {
				brightness = 0.95f;
			}
			WindowManager.LayoutParams lp = ((Activity) context).getWindow()
					.getAttributes();
			lp.screenBrightness = brightness;
			((Activity) context).getWindow().setAttributes(lp);
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 获取屏幕亮度值，-1表示屏幕亮度自动调节
	 * 
	 * @param context
	 * @return
	 */
	public static int getScreenLight(Context context) {
		try {
			if (Settings.System.getInt(context.getContentResolver(),
					Settings.System.SCREEN_BRIGHTNESS_MODE) == 1) {
				return -1;
			}
		} catch (SettingNotFoundException e) {
		}
		return Settings.System.getInt(context.getContentResolver(),
				Settings.System.SCREEN_BRIGHTNESS, 0);
	}

	/**
	 * 设置屏幕亮度值
	 * 
	 * @param activity
	 * @param value
	 *            范围0~255，如为-1表示屏幕亮度自动调节
	 */
	public static void setScreenLight(Activity activity, int value) {
		if (value == -1) {
			Settings.System.putInt(activity.getContentResolver(),
					Settings.System.SCREEN_BRIGHTNESS_MODE, 1);
			WindowManager.LayoutParams lp = activity.getWindow()
					.getAttributes();
			lp.screenBrightness = 0.5f;
			activity.getWindow().setAttributes(lp);
		} else {
			if (value < 0) {
				value = 5;
			}
			if (value > 255) {
				value = 250;
			}
			Settings.System.putInt(activity.getContentResolver(),
					Settings.System.SCREEN_BRIGHTNESS_MODE, 0);
			Settings.System.putInt(activity.getContentResolver(),
					Settings.System.SCREEN_BRIGHTNESS, value);
			WindowManager.LayoutParams lp = activity.getWindow()
					.getAttributes();
			float brightness = value / 255f;
			lp.screenBrightness = brightness;
			activity.getWindow().setAttributes(lp);
		}
	}

	/**
	 * 获取飞行模式的状态
	 * 
	 * @param context
	 * @return
	 */
	public static boolean isAirplaneModeOn(Context context) {
		int modeIdx = Settings.System.getInt(context.getContentResolver(),
				Settings.System.AIRPLANE_MODE_ON, 0);
		return (modeIdx == 1);
	}

	/**
	 * 设置飞行模式，需要权限 android.permission.WRITE_SETTINGS
	 * 
	 * @param context
	 *            Context
	 * @param enabling
	 *            true表示开启飞行模式
	 * @since HardwareHelper 1.0
	 */
	public static void setAirplaneMode(Context context, boolean enabling) {
		Settings.System.putInt(context.getContentResolver(),
				Settings.System.AIRPLANE_MODE_ON, enabling ? 1 : 0);
		Intent intent = new Intent(Intent.ACTION_AIRPLANE_MODE_CHANGED);
		intent.putExtra("state", enabling);
		context.sendBroadcast(intent);
	}

	/**
	 * 开启、关闭移动数据
	 * 
	 * @param context
	 * @param enabling
	 */
	public static void operateMobileData(Context context, boolean enabling) {
		try {
			Object[] arg = null;
			invokeBooleanArgMethod(context, "setMobileDataEnabled", enabling);
		} catch (Exception e) {
			e.printStackTrace();
		}

		Method dataConnSwitchmethod;
		Class telephonyManagerClass;
		Object ITelephonyStub;
		Class ITelephonyClass;
		TelephonyManager telephonyManager = (TelephonyManager) context
				.getSystemService(Context.TELEPHONY_SERVICE);
		try {
			telephonyManagerClass = Class.forName(telephonyManager.getClass()
					.getName());
			Method getITelephonyMethod = telephonyManagerClass
					.getDeclaredMethod("getITelephony");
			getITelephonyMethod.setAccessible(true);
			ITelephonyStub = getITelephonyMethod.invoke(telephonyManager);
			ITelephonyClass = Class
					.forName(ITelephonyStub.getClass().getName());

			if (!enabling) {
				dataConnSwitchmethod = ITelephonyClass
						.getDeclaredMethod("disableDataConnectivity");
			} else {
				dataConnSwitchmethod = ITelephonyClass
						.getDeclaredMethod("enableDataConnectivity");
			}
			dataConnSwitchmethod.setAccessible(true);
			dataConnSwitchmethod.invoke(ITelephonyStub);
		} catch (Exception e) {
		}
	}

	private static Object invokeBooleanArgMethod(Context context,
			String methodName, boolean value) throws Exception {
		ConnectivityManager mConnectivityManager = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		Class ownerClass = mConnectivityManager.getClass();
		Class[] argsClass = new Class[1];
		argsClass[0] = boolean.class;
		Method method = ownerClass.getMethod(methodName, argsClass);
		return method.invoke(mConnectivityManager, value);
	}

	/**
	 * 获取移动数据的状态
	 * 
	 * @param context
	 * @return
	 */
	public static boolean getMobileDataState(Context context) {
		ConnectivityManager mag = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo mobInfo = mag
				.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
		if (mobInfo.getState() == NetworkInfo.State.CONNECTED
				|| mobInfo.getState() == NetworkInfo.State.CONNECTING) {
			return true;
		}
		return false;
	}

	/**
	 * 设置屏幕待机时间
	 * 
	 * @param context
	 * @param value
	 */
	public static void setScreenTimeOut(Context context, int value) {
		try {
			Settings.System.putInt(context.getContentResolver(),
					android.provider.Settings.System.SCREEN_OFF_TIMEOUT, value);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 获取屏幕待机时间
	 * 
	 * @param context
	 * @return
	 */
	public static int getScreenTimeOut(Context context) {
		try {
			return Settings.System.getInt(context.getContentResolver(),
					android.provider.Settings.System.SCREEN_OFF_TIMEOUT);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

}
