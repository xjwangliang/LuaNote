###style
```
  <!-- For API level 11 or later, the Holo theme is available and we prefer that. -->
    <style name="ThemeHolo" parent="android:Theme.Holo">
    </style>

    <!-- For API level 11 or later, the Holo theme is available and we prefer that. -->
    <style name="ThemeHoloDialog" parent="android:Theme.Holo.Dialog">
    </style>

    <!-- For API level 11 or later, we can use the magical DialogWhenLarge theme. -->
    <style name="ThemeDialogWhenLarge" parent="android:style/Theme.Holo.DialogWhenLarge">
    </style>
    
<!-- Widget Styles -->
<!-- Text Appearance Styles -->
<!-- Preference Styles -->
<!-- AlertDialog Styles -->
<!-- Animation Styles -->
<!-- DialogWindowTitle Styles -->
<!-- WindowTitle Styles -->
<!-- Other Styles -->
```    

###Honeycomb holographic theme (dark version)

```
Honeycomb holographic theme (dark version).
This is the default system theme for apps that target API level 11 - 13. Starting
         with API level 14, the default system theme is supplied by {@link #Theme_DeviceDefault},
         which might apply a different style on different devices. If you want to ensure that your
         app consistenly uses the Holo theme at all times, you must explicitly declare it in your
         manifest. For example, {@code &lt;application android:theme="@android:style/Theme.Holo"&gt;}.
         For more information, read <a
         href="http://android-developers.blogspot.com/2012/01/holo-everywhere.html">Holo
         Everywhere</a>.</p>
         <p>The widgets in the holographic theme are translucent on their brackground, so
         applications must ensure that any background they use with this theme is itself
         dark; otherwise, it will be difficult to see the widgets. This UI style also includes a
         full action bar by default.</p>

Styles used by the Holo theme are named using the convention Type.Holo.Etc
         (for example, {@code Widget.Holo.Button} and {@code
         TextAppearance.Holo.Widget.PopupMenu.Large}).
         Specific resources used by Holo are named using the convention @type/foo_bar_baz_holo
         with trailing _dark or _light specifiers if they are not shared between both light and
         dark versions of the theme.         
         <style name="Theme.Holo">
```


###The default theme for apps that target API level 14 and higher
```
 <!-- The default theme for apps that target API level 14 and higher.
         <p>The DeviceDefault themes are aliases for a specific device’s native look and feel. The
         DeviceDefault theme family and widget style family offer ways for you to target your app
         to a device’s native theme with all device customizations intact.</p>
         <p>For example, when you set your app's {@code targetSdkVersion} to 14 or higher, this
         theme is applied to your application by default. As such, your app might appear with the
         {@link #Theme_Holo Holo} styles on one device, but with a different set of styles on
         another device. This is great if you want your app to fit with the device's native look and
         feel. If, however, you prefer to keep your UI style the same across all devices, you should
         apply a specific theme such as {@link #Theme_Holo Holo} or one of your own design. For more
         information, read <a
         href="http://android-developers.blogspot.com/2012/01/holo-everywhere.html">Holo
         Everywhere</a>.</p>
         <p>Styles used by the DeviceDefault theme are named using the convention
         Type.DeviceDefault.Etc (for example, {@code Widget.DeviceDefault.Button} and
         {@code TextAppearance.DeviceDefault.Widget.PopupMenu.Large}).</p>
          -->
    <style name="Theme.DeviceDefault" parent="Theme.Holo" >
    
```
