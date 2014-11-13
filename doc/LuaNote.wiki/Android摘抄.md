####android:allowTaskReparenting
场景：For example, if an e-mail message contains a link to a web page, clicking the link brings up an activity that can display the page. That activity is defined by the browser application, but is launched as part of the e-mail task. If it's reparented to the browser task, it will be shown when the browser next comes to the front, and will be absent when the e-mail task again comes forward.

####android:alwaysRetainTaskState
默认是false。只对root activity有用。一般30分钟之后，当用户从桌面重新启动一个任务，系统将清除task(removes all activities from the stack above the root activity)。场景：浏览器程序，root activity设置android:alwaysRetainTaskState="true",就不会丢失上次的状态。


####android:clearTaskOnLaunch
只对启动新的task的activity(root activity)有用。每次离开task，所有位于root activity之上的activity下次启动的时候将会清除。场景：Suppose, for example, that someone launches activity P from the home screen, and from there goes to activity Q. The user next presses Home, and then returns to activity P. Normally, the user would see activity Q, since that is what they were last doing in P's task. However, if P set this flag to "true", all of the activities on top of it (Q in this case) were removed when the user pressed Home and the task went to the background. So the user sees only P when returning to the task.

####android:finishOnTaskLaunch

###程序全屏
让程序全屏的方法，大家都知道，那是静态的，程序运行之初就申明了。但是如果有这样的需求：要在程序运行的过程中，执行了某个操作而使之全屏，然后还需要退出全屏，怎么做？如下：
``` 
WindowManager.LayoutParams attrs = getWindow().getAttributes();  
attrs.flags |= WindowManager.LayoutParams.FLAG_FULLSCREEN;  
getWindow().setAttributes(attrs);  
getWindow().addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);  
```
    
修改window的LayoutParams参数，然后加上FLAG_LAYOUT_NO_LIMITS标志，就OK了。window会自动重新布局，呈现全屏的状态。要退出全屏，只需要清除刚才加上的FLAG_FULLSCREEN参数，然后去掉FLAG_LAYOUT_NO_LIMITS标志。如下：
```
WindowManager.LayoutParams attrs = getWindow().getAttributes();  
attrs.flags &= (~WindowManager.LayoutParams.FLAG_FULLSCREEN);  
getWindow().setAttributes(attrs);  
getWindow().clearFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS); 
```