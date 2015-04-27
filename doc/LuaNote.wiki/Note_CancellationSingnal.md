CancellationSignal


import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.hardware.Camera.AutoFocusCallback;
import android.hardware.Camera.AutoFocusMoveCallback;
import android.hardware.Camera.ErrorCallback;
import android.hardware.Camera.FaceDetectionListener;
import android.hardware.Camera.OnZoomChangeListener;
import android.hardware.Camera.Parameters;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.PreviewCallback;
import android.hardware.Camera.ShutterCallback;
import android.os.ConditionVariable;


	//	MonthDisplayHelper
		
	//	TimingLogger
		//	A utility class to help log timings splits throughout a method call. Typical usage is:
		//
		//	     TimingLogger timings = new TimingLogger(TAG, "methodA");
		//	     // ... do some work A ...
		//	     timings.addSplit("work A");
		//	     // ... do some work B ...
		//	     timings.addSplit("work B");
		//	     // ... do some work C ...
		//	     timings.addSplit("work C");
		//	     timings.dumpToLog();
		//	 
		//	The dumpToLog call would add the following to the log:
		//
		//	     D/TAG     ( 3459): methodA: begin
		//	     D/TAG     ( 3459): methodA:      9 ms, work A
		//	     D/TAG     ( 3459): methodA:      1 ms, work B
		//	     D/TAG     ( 3459): methodA:      6 ms, work C
		//	     D/TAG     ( 3459): methodA: end, 16 ms
		
		
		
	//	FloatMath
		
	//	DebugUtils
	
	//Select TextView instances: TextView
	//Select TextView instances of text "Loading" and bottom offset of 22: TextView@text=Loading.*@bottom=22
	//The class name and the values are regular expressions.
	//
	//This class is useful for debugging and logging purpose:
	//
	// if (DEBUG) {
	//   if (DebugUtils.isObjectSelected(childView) && LOGV_ENABLED) {
	//     Log.v(TAG, "Object " + childView + " logged!");
	//   }
	// }
	 
	//	AtomicFile
		
	//	ArrayMap
		
	//	LruCache
		
	//	Configuration
		
	//	MountService( 1693): getVolumeState(/mnt/sdcard): Unknown volume
		
		
	//	public static boolean isLoggable (String tag, int level)
	//
	//	Added in API level 1
	//	Checks to see whether or not a log for the specified tag is loggable at the specified level. The default level of any tag is set to INFO. This means that any level above and including INFO will be logged. Before you make any calls to a logging method you should check to see if your tag should be logged. You can change the default level by setting a system property: 'setprop log.tag.<YOUR_LOG_TAG> <LEVEL>' Where level is either VERBOSE, DEBUG, INFO, WARN, ERROR, ASSERT, or SUPPRESS. SUPPRESS will turn off all logging for your tag. You can also create a local.prop file that with the following in it: 'log.tag.<YOUR_LOG_TAG>=<LEVEL>' and place that in /data/local.prop.
	
	
		
		
	//	private static final String BASEBAND_VERSION = "gsm.version.baseband";
	//
	//	/**
	//	     * Returns a SystemProperty
	//	     *
	//	     * @param propName The Property to retrieve
	//	     * @return The Property, or NULL if not found
	//	     */
	//	    public static String getSystemProperty(String propName) {
	//	        String TAG = "TEst";
	//	        String line;
	//	        BufferedReader input = null;
	//	        try {
	//	            Process p = Runtime.getRuntime().exec("getprop " + propName);
	//	            input = new BufferedReader(new InputStreamReader(p.getInputStream()), 1024);
	//	            line = input.readLine();
	//	            input.close();
	//	        }
	//	        catch (IOException ex) {
	//	            Log.e(TAG, "Unable to read sysprop " + propName, ex);
	//	            return null;
	//	        }
	//	        finally {
	//	            if (input != null) {
	//	                try {
	//	                    input.close();
	//	                }
	//	                catch (IOException e) {
	//	                    Log.e(TAG, "Exception while closing InputStream", e);
	//	                }
	//	            }
	//	        }
	//	        return line;
	//	    }
	//	    String basebandVersion = getSystemProperty(BASEBAND_VERSION);
		    
		 
	//	Using Android Debug Bridge (ADB) via TCP/IP
	//
	//	On the device running Android (using the serial console):
	//	netcfg eth0 up                 #get your eth network up
	//	netcfg eth0 dhcp                 #get your dhcp ip for eth0 intergace
	//	ifconfig eth0                       #confirm your board IP 
	//	echo 0>/sys/class/android_usb/android0/enable  #enable adb via IP
	//	stop adbd
	//	setprop service.adb.tcp.port 6565
	//	start adbd
	//	On your host machine (assuming the its reachable via tcpip):
	//	export ADBHOST=<board's IP>
	//	sudo android-sdk-linux_x86/platform-tools/adb start-server
	//	android-sdk-linux_x86/platform-tools/adb connect <board's IP>:6565
	//	android-sdk-linux_x86/platform-tools/adb shell
	//	Note: default adb port is 5555, and using another value is trivial security measure. However, adb access at all, and networked access foremostly, is utterly insecure and intended to be used only on development-only devices in a physically and networkedly controlled environment. Never enable those on a production-use device or on a device which may contain sensitive data. The same goes for unauthenticated root access.
	
		
	//	private String cpuinfo() {
	//		String arch = System.getProperty("os.arch");
	//		String arc = arch.substring(0, 3).toUpperCase();
	//		String rarc = "";
	//		if (arc.equals("ARM")) {
	//			rarc = "This is ARM";
	//		} else if (arc.equals("MIP")) {
	//			rarc = "This is MIPS";
	//		} else if (arc.equals("X86")) {
	//			rarc = "This is X86";
	//		}
	//		return rarc;
	//	}
	//	
	//	//cat /proc/cpuinfo
	//	
	//	
	//			/** The name of the instruction set (CPU type + ABI convention) of native code. */
	//		    //public static final String CPU_ABI = getString("ro.product.cpu.abi");
	//		    /** The name of the second instruction set (CPU type + ABI convention) of native code. */
	//		    //public static final String CPU_ABI2 = getString("ro.product.cpu.abi2");