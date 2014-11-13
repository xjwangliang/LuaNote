###EventProxy
```
framework/cc/EventProxy就是一个工具类（包装类），调用eventDispatcher同名方法

function EventProxy:addEventListener(eventName, listener, data)
    local handle = self.eventDispatcher_:addEventListener(eventName, listener, data)
    self.handles_[#self.handles_ + 1] = {eventName, handle}
    return self
end
```
###cc函数与GameObject
```
cc(node):addComponent("components.behavior.EventProtocol"):exportMethods()
实现原理（framework/cc/init.lua）

-- cc = cc.GameObject.extend()
local GameObject ={}
GameObject.extend = function (target)
  print("extend target", target)
  return target;
end
  
local ccmt = {}
ccmt.__call = function(self, target)
    if target then
        return GameObject.extend(target)
    end
    print("cc() - invalid target")
end
setmetatable(cc, ccmt)

测试：OK
local app =  {}
cc(app)

cc.GameObject.extend()所做的工作为：
function GameObject.extend(target)
    target.components_ = {}

    function target:checkComponent(name)
        return self.components_[name] ~= nil
    end

    function target:addComponent(name)
        local component = Registry.newObject(name)
        self.components_[name] = component
        component:bind_(self)
        return component
    end

    function target:removeComponent(name)
        local component = self.components_[name]
        if component then component:unbind_() end
        self.components_[name] = nil
    end

    function target:getComponent(name)
        return self.components_[name]
    end

    return target
end

为目标添加components_变量，以及添加(以及Component绑定)、删除(以及Component解绑)、获取、检查Component的方法。
```

###Component

```
framework/cc/components/Component
导出函数，绑定target之后，让tartet拥有组件的导出函数.export之后,Component中的方法中self不是扩展后的对象，而是Component

function Component:exportMethods_(methods)
    self.exportedMethods_ = methods
    local target = self.target_
    local com = self
    for _, key in ipairs(methods) do
        if not target[key] then
            local m = com[key]
            target[key] = function(__, ...)
            print("exportMethods_ component is" , com)
                --将第一个参数由self(扩展后的对象)替换成component本身
                return m(com, ...)
            end
        end
    end
    return self
end

绑定方法，将组件绑定到一个target上面，只能绑定到一个target（但是一个target可以包含多个组件）。如果target已经拥有同名组件，不在绑定（通过GameObject.extend之后的对象才可以调用的此方法）
function Component:bind_(target)
    self.target_ = target
    for _, name in ipairs(self.depends_) do
        if not target:checkComponent(name) then
            target:addComponent(name)
        end
    end
    self:onBind_(target)
end

解绑，若此组件有导出函数，则将绑定的target删除到处函数
function Component:unbind_()
    if self.exportedMethods_ then
        local target = self.target_
        for _, key in ipairs(self.exportedMethods_) do
            target[key] = nil
        end
    end
    self:onUnbind_()
end
```

###常用组件
```
framework/cc/init包含以下代码：
-- init components
local components = {
    "components.behavior.StateMachine",
    "components.behavior.EventProtocol",
    "components.ui.BasicLayoutProtocol",
    "components.ui.LayoutProtocol",
}
for _, packageName in ipairs(components) do
    cc.Registry.add(import("." .. packageName, CURRENT_MODULE_NAME), packageName)
end

```


####EventProtocol

```
--components/behavior/EventProtocol
function EventProtocol:exportMethods()
    self:exportMethods_({
        "addEventListener",
        "dispatchEvent",
        "removeEventListener",
        "removeEventListenersByTag",
        "removeEventListenersByEvent",
        "removeAllEventListenersForEvent",
        "removeAllEventListeners",
        "hasEventListener",
        "dumpAllEventListeners",
    })
    return self.target_
end



1，addEventListener(eventName, listener, tag)
同一个事件注意注册多个监听，其中将listener添加到isteners_中。EventProtocol的listeners结构如下：

EventProtocol.listeners_ = {
	EVENT_A = {
		autoincreated_handle = { listener, tag },
		autoincreated_handle = { listener, tag }
	},
	EVENT_B = {}
}


2，EventProtocol:dispatchEvent(event)
分发事件，event至少需要包含name字段。经过处理之后，listener接受到event的数据结构如下（我们可以添加其他属性）：
event = {
	name =  "NAME",
	target = target,
	stop_ = false,
	stop = function(self)
        	self.stop_ = true
    		end
}




```


####ModelBase天生就具有EventProtocol组件的方法：

```
function ModelBase:ctor(properties)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    self.isModelBase_ = true
    if type(properties) ~= "table" then properties = {} end
    self:setProperties(properties)
end

```




###cocos2dx扩展

```
--framework/cocos2dx.lua
针对 cocos2d-x 的一些封装和扩展

预定义的节点事件(在framework/cocos2dx/Event.lua)：
-   cc.NODE_EVENT - enter, exit 等事件
-   cc.NODE_ENTER_FRAME_EVENT - 帧事件
-   cc.NODE_TOUCH_EVENT - 触摸事件
-   cc.NODE_TOUCH_CAPTURE_EVENT - 捕获触摸事件

预定义的层事件(在framework/cocos2dx/Event.lua)：
-   cc.ACCELERATE_EVENT - 重力感应事件
-   cc.KEYPAD_EVENT - 硬件按键事件

预定义的菜单事件(在framework/cocos2dx/Event.lua)：
-   cc.MENU_ITEM_CLICKED_EVENT - CCMenu 菜单项点击事件

预定义的触摸模式(在framework/cocos2dx/Event.lua)：
-   cc.TOUCH_MODE_ALL_AT_ONCE - 多点触摸
-   cc.TOUCH_MODE_ONE_BY_ONE - 单点触摸

cocos2dx 中的全局函数(在framework/cocos2dx/Global.lua)
cc.Node/Scene(在framework/cocos2dx/ObjectBinding.lua)

引入其他扩展：
require(p .. "Global")
require(p .. "ObjectBinding")
require(p .. "OpenGL")
require(p .. "Geometry")
require(p .. "Event")
require(p .. "NodeEx")
require(p .. "LayerEx")
require(p .. "SceneEx")
require(p .. "SpriteEx")
require(p .. "DrawNodeEx")
require(p .. "MenuItemEx")

```


###Node以及扩展
``` 

--framework/cocos2dx/NodeEx.lua

增加了许多：onEnter/onExit/onEnterTransitionFinish/onExitTransitionStart/performWithDelay/setNodeEventEnabled

function Node:addTouchEventListener(handler)
    PRINT_DEPRECATED("Node.addTouchEventListener() is deprecated, please use Node.addNodeEventListener()")
    return self:addNodeEventListener(c.NODE_TOUCH_EVENT, function(event)
        return handler(event.name, event.x, event.y, event.prevX, event.prevY)
    end)
end
为所有Node增加了Node:addTouchEventListener（以及registerScriptHandler、scheduleUpdate等等），这些都是调用addNodeEventListener函数，而他不是CCNode所拥有的，而是Quick扩展的。


-- lib/cocos2d-x/scripting/lua/LuaCocos2d.cpp包含如下代码

cocos2dx_supporttolua_function(tolua_S,"addNodeEventListener",tolua_Cocos2d_CCScriptEventDispatcher_addNodeEventListener00);
   tolua_function(tolua_S,"removeNodeEventListener",tolua_Cocos2d_CCScriptEventDispatcher_removeNodeEventListener00);
   tolua_function(tolua_S,"removeNodeEventListenersByEvent",tolua_Cocos2d_CCScriptEventDispatcher_removeNodeEventListenersByEvent00);
   tolua_function(tolua_S,"removeNodeEventListenersByTag",tolua_Cocos2d_CCScriptEventDispatcher_removeNodeEventListenersByTag00);
   tolua_function(tolua_S,"removeAllNodeEventListeners",tolua_Cocos2d_CCScriptEventDispatcher_removeAllNodeEventListeners00);
tolua_endmodule(tolua_S);

查看代码，发现与CCScriptEventDispatcher有关：
--lib/cocos2d-x/cocos2dx/cocoa/CCScriptEventDispatcher.cpp包含如下代码
  
int addScriptEventListener(int event, int listener, int tag = 0);
    void removeScriptEventListener(unsigned int handle);
    void removeScriptEventListenersByEvent(int event);
    void removeScriptEventListenersByTag(int tag);
    void removeAllScriptEventListeners();

    CCArray *getAllScriptEventListeners()
    {
        return m_scriptEventListeners;
    }
    
```


####1.registerScriptHandler
```
过时的用法:
node:registerScriptHandler(function(event)
    print(event)
end)

新用法:
node:addNodeEventListener(cc.NODE_EVENT, function(event)
     event.name 的值是下列之一：
     enter 节点进入场景
     exit 节点退出场景
     cleanup 节点进行清理
     enterTransitionFinish 节点进入场景的变换完成
     exitTransitionStart 节点退出场景的变换开始
    print(event.name)
end)
```
####2.scheduleUpdate
```
过时的用法：
node:scheduleUpdate(function(dt)
    print(dt)
end)

新用法：
self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
     dt 是上一帧到这一帧之间的间隔事件，通常为 60 分之一秒
    print(dt)
end)
self:scheduleUpdate()
```

####3.registerScriptTouchHandler
```
过时的用法：

node:registerScriptTouchHandler(function(event, x, y)
end)

新用法:

 设置触摸模式
node:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)  单点触摸
 或者
node:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)  多点触摸
 
 是否启用触摸
 默认值： false
node:setTouchEnabled(true)
 
 是否允许当前 node 和所有子 node 捕获触摸事件
 默认值： true
node:setTouchCaptureEnabled(true)
 
 如果当前 node 响应了触摸，是否吞噬触摸事件（阻止事件继续传递）
 默认值： true
node:setTouchSwallowEnabled(true)
 
 添加触摸事件处理函数
node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
     event.phase 的值是：
     cc.NODE_TOUCH_TARGETING_PHASE
 
     event.mode 的值是下列之一：
     cc.TOUCH_MODE_ONE_BY_ONE 单点触摸
     cc.TOUCH_MODE_ALL_AT_ONCE 多点触摸
 
     event.name 的值是下列之一：
     began 触摸开始
     moved 触摸点移动
     ended 触摸结束
     cancelled 触摸被取消
 
     如果是单点触摸：
     event.x, event.y 是触摸点位置
     event.prevX, event.prevY 是触摸点之前的位置
 
     如果是多点触摸：
     event.points 包含了所有触摸点的信息
     event.points = {point, point, ...}
     每一个触摸点的值包含：
     point.x, point.y 触摸点的当前位置
     point.prevX, point.prevY 触摸点之前的位置
     point.id 触摸点 id，用于确定触摸点的变化
 
    if event.name == "began" then
         在单点触摸模式下：在触摸事件开始时，必须返回 true
         返回 true 表示响应本次触摸事件，并且接收后续状态更新
        return true
    end
end)
 
 添加触摸事件捕获函数
node:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
     event.phase 的值是：
     cc.NODE_TOUCH_CAPTURING_PHASE
 
     event.mode 的值是下列之一：
     cc.TOUCH_MODE_ONE_BY_ONE 单点触摸
     cc.TOUCH_MODE_ALL_AT_ONCE 多点触摸
 
     event.name 的值是下列之一：
     began 触摸开始
     moved 触摸点移动
     ended 触摸结束
     cancelled 触摸被取消
 
     如果是单点触摸：
     event.x, event.y 是触摸点位置
     event.prevX, event.prevY 是触摸点之前的位置
 
     如果是多点触摸：
     event.points 包含了所有触摸点的信息
     event.points = {point, point, ...}
     每一个触摸点的值包含：
     point.x, point.y 触摸点的当前位置
     point.prevX, point.prevY 触摸点之前的位置
     point.id 触摸点 id，用于确定触摸点的变化
 
    if event.name == "began" then
         在单点触摸模式下：在触摸事件开始捕获时，必须返回 true
         返回 true 表示要捕获本次触摸事件
        return true
    end
end)
```

####4.扩展功能的变化
```
过时的用法：
api.EventProtocol.extend(target)

新用法：
cc(target)
    :addComponent("components.behavior.EventProtocol")
    :exportMethods()
    
```  


```
-- 八大类型：thread/function/table/userdata/string/number/boolean/nil
-- false和nil为假，其余全部为真(包括空字符串和0)
```

```
--\不能单独使用（invalid escape sequence near '\ '）
--必须\n,\t,\",\'是搭配
--\.也是不行，必须改成%.（将.保留原始字符）

local line = "wang.liang"
line2 = string.gsub(line,"%.","|");

```

```
#array才有意义
```
### 自动载入的模块

框架初始化时，会自动载入以下基本模块：

-   debug: 调试接口
-   functions: 提供一组常用的函数，以及对 Lua 标准库的扩展
-   cocos2dx: 对 cocos2d-x C++ 接口的封装和扩展
-   device: 针对设备接口的扩展
-   transition: 与动作相关的接口
-   display: 创建场景、图像、动画的接口
-   filter: 具备过滤器渲染的 Sprite 接口
-   audio: 音乐和音效的接口
-   network: 网络相关的接口
-   crypto: 加密相关的接口
-   json: JSON 的编码和解码接口
-   luaj: 提供从 Lua 调用 Java 方法的接口（仅限 Android 平台）
-   luaoc: 提供从 Lua 调用 Objective-C 方法的接口（仅限 iOS 平台）
-   cc: quick 框架扩展的基础类和组件


###动画
* transition.execute(target, action, args)   

```
transition.execute(sprite, CCMoveTo:create(1.5, CCPoint(display.cx, display.cy)), {
    delay = 1.0,
    easing = "backout", 
    onComplete = function()
        print("move completed")
    end,
})
-- 等待 1.0 后开始移动对象
-- 耗时 1.5 秒，将对象移动到屏幕中央
-- 移动使用 backout 缓动效果
-- 移动结束后执行函数，显示 move completed
--easing：缓动效果的名字及可选的附加参数，效果名字不区分大小写:

backIn
backInOut
backOut
bounce
bounceIn
bounceInOut
bounceOut
elastic, 附加参数默认为 0.3
elasticIn, 附加参数默认为 0.3
elasticInOut, 附加参数默认为 0.3
elasticOut, 附加参数默认为 0.3
exponentialIn, 附加参数默认为 1.0
exponentialInOut, 附加参数默认为 1.0
exponentialOut, 附加参数默认为 1.0
In, 附加参数默认为 1.0
InOut, 附加参数默认为 1.0
Out, 附加参数默认为 1.0
rateaction, 附加参数默认为 1.0
sineIn
sineInOut
sineOut
```

* transition.rotateTo

```
-- 耗时 0.5 秒将 sprite 旋转到 180 度
transition.rotateTo(sprite, {rotate = 180, time = 0.5})
```

* transition.moveTo

```
-- 移动到屏幕中心
transition.moveTo(sprite, {x = display.cx, y = display.cy, time = 1.5})
-- 移动到屏幕左边，不改变 y
transition.moveTo(sprite, {x = display.left, time = 1.5})
```

* transition.fadeTo

```
-- 不管显示对象当前的透明度是多少，最终设置为 128
transition.fadeTo(sprite, {opacity = 128, time = 1.5})
```

*  transition.sequence(actions)

```
local sequence = transition.sequence({
    CCMoveTo:create(0.5, CCPoint(display.cx, display.cy)),
    CCFadeOut:create(0.2),
    CCDelayTime:create(0.5),
    CCFadeIn:create(0.3),
})
sprite:runAction(sequence)
```
 
* transition.playAnimationOnce(target, animation, removeWhenFinished, onComplete, delay)

```
返回 CCAction 

local frames = display.newFrames("Walk%04d.png", 1, 20)
local animation = display.newAnimation(frames, 0.5 / 20) -- 0.5s play 20 frames
transition.playAnimationOnce(sprite, animation)

动画播放完成后就删除用于播放动画的 CCSprite 对象（例如一个爆炸效果）：

local frames = display.newFrames("Boom%04d.png", 1, 8)
local boom = display.newSprite(frames[1])

-- playAnimationOnce() 第二个参数为 true 表示动画播放完后删除 boom 这个 CCSprite 对象
-- 这样爆炸动画播放完毕，就自动清理了不需要的显示对象
boom:playAnimationOnce(display.newAnimation(frames, 0.3/ 8), true)
```




###一、2.2.1
```
以下内容适用于 Quick-Cocos2d-x 2.2.1-rc 版本，新版触摸机制请参考新文档

我们知道 Cocos2d-x 里，整个游戏的画面是由一系列的 CCScene, CCNode, CCSprite, CCLayer, CCMenu, CCMenuItem 等对象构成的。
而所有这些对象都是从 CCNode 这个类继承而来。我们可以将 CCNode 称为 显示节点 。

在 Cocos2d-x 里，只有 CCLayer 对象才能接受触摸事件。而 CCLayer 总是响应整个屏幕范围内的触摸，这就要求开发者在拿到触摸事件后，再做进一步的处理。

例如有一个需求是在玩家触摸屏幕上的方块时，人物角色做一个动作。那么使用 CCLayer 接受到触摸事件后，开发者需要自行判断触摸位置是否在方块之内。当屏幕上有很多东西需
要响应玩家交互时，程序结构就开始变得复杂了。

所以 Quick-Cocos2d-x 允许开发者将任何一个 CCNode 设置为接受触摸事件。并且触摸事件一开始只会出现在这个 CCNode 的 触摸区域 内。

这里的触摸区域，就是一个 CCNode 及其所有子 CCNode 显示内容占据的屏幕空间。要注意的是这个屏幕空间包含了图片的透明部分。下图中，节点 A 是一个 CCSprite 对象，
它的触摸区域就是图片大小；而节点 B 是一个 CCNode 对象，其中包含了三个 CCSprite 对象，那么节点 B 的触摸区域就是三个 CCSprite 对象触摸区域的合集。


现在，我们知道了显示层级、触摸区域，那么要让任何 CCNode 都可以接受触摸事件就变得很简单了：

由一个管理者负责登记所有需要接受触摸事件的 CCNode
管理者响应全屏幕的触摸
触摸开始的时候，管理者对已经登记的 CCNode 按照显示层级进行排序，然后依次检查触摸位置是否在它们的触摸区域内。如果是，则将触摸事件传递给相应的 CCNode 对象。并且将这个 CCNode 对象记录到一个列表里。这个列表称为 可触摸节点列表。
触摸事件持续发生时，管理者将触摸事件发送给列表中每一个 CCNode 对象。
触摸事件结束时，管理者发送事件给列表中的对象，然后清理列表，准备开始下一次触摸响应。
在目前的实现里，这个管理者的角色，我们交给了 CCScene。
```

几个引擎级事件，分别是，

```
http://cn.cocos2d-x.org/tutorial/show?id=1210：Quick-Cocos2d-x 触摸机制详解
http://cn.cocos2d-x.org/tutorial/show?id=1418：单点触摸

 Cocos2d-x 引擎级事件
  cc.NODE_EVENT = 0                节点事件在一个 Node 对象进入、退出场景时触发。
  cc.NODE_ENTER_FRAME_EVENT = 1    每一次刷新屏幕前（也就是前一帧和下一帧之间）都会触发事件
  cc.NODE_TOUCH_EVENT = 2
  cc.NODE_TOUCH_CAPTURE_EVENT = 3  捕获触摸事件
  cc.MENU_ITEM_CLICKED_EVENT = 4   菜单项点击事件
  cc.ACCELERATE_EVENT = 5          重力感应事件
  cc.KEYPAD_EVENT = 6              硬件按键事件
```


###二、2.2.3的方式
在2.2.3之前的版本（不包括2.2.3），触摸机制和廖大在那篇文章里面的说的一样，添加触摸响应采用addTouchEventListener来完成，不过在此之后，对触摸机制就进行了完全的改写，和Cocos2d-x 3.0的版本一样，采用更加灵活的CCNode事件分发机制。

```
local layer = display.newLayer()
self:addChild(layer)
layer:setTouchEnabled(true)
layer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
    local x, y, prevX, prevY = event.x, event.y, event.prevX, event.prevY
    if event.name == "began" then
        print("layer began")
    elseif event.name == "moved" then
        print("layer moved")
    elseif event.name == "ended" then
        print("layer ended")
    end
        return true
    end
 )
```
cc.NODE_EVENT可以响应一个节点的onenter，onexit，cleanup，exitTransitionStart，enterTransitionFinish这些事件，当然如果不使用添加监听的方式，
 我们也可以重写相应的函数，
 
 ```
  function MyScene:onEnter()  end  
  function MyScene:onExit()  end
  ```
从上面的代码可以看到，可以设置触摸的模式，

 ```
  cc.TOUCH_MODE_ONE_BY_ONE 是单点触摸
  cc.TOUCH_MODE_ALL_AT_ONCE 是多点触摸
 ```
在添加节点事件监听addNodeEventListener中，我们设置监听事件的类型是cc.NODE_TOUCH_EVENT

其次是event参数，在event参数里，里面有name，x，y，prevX，prevY 这五个变量，分别代表着
  event.name 是触摸事件的状态：began, moved, ended, cancelled, added（仅限多点触摸）, removed（仅限多点触摸）；
  event.x, event.y 是触摸点当前位置；
  event.prevX, event.prevY 是触摸点之前的位置；
所以添加上面的代码，简单触摸屏幕，就可以看到log中的print的结果。

在触摸的回调函数function(event)中，记得考虑是否需要添加返回值，返回值的作用不用多说，true则后面的moved，ended等状态会接收到，否则接收不到，默认如果不添加则代表false。

在新版触摸机制中，还需要主要的一个就是触摸吞噬：

 ```
  setTouchSwallowEnabled(true)
 ```
它的作用就是是否继续传递触摸消息，在绘制节点的时候，越是在屏幕上方，就是zOrder越大，越优先接收到触摸事件，如果设置吞噬，那么在它下方的节点都不会接
收到触摸消息了。默认如果不设置则quick自动设置为true。
当然，不仅仅可以给layer添加触摸事件，你也可以给精灵添加，这就看你游戏的需要了。


###2.2.1的touch事件
```
setTouchEnabled() 是否允许一个 CCNode 响应触摸事件
addTouchEventListener() 设置触摸事件的处理函数
removeTouchEventListener() 删除触摸事件的处理函数

 创建一个图片显示对象
local sprite = display.newSprite("Button.png")
 启用触摸
sprite:setTouchEnabled(true)
 设置处理函数
sprite:addTouchEventListener(function(event, x, y, prevX, prevY)
    print(event, x, y, prevX, prevY)
    return true  返回 true 表示这个 CCNode 在触摸开始后接受后续的事件
end)
```

多点触摸
http://cn.cocos2d-x.org/tutorial/show?id=1465:多点触摸

帧事件
http://cn.cocos2d-x.org/tutorial/show?id=1468
帧事件就是update定时器，每一帧调用，如果要使用，除了要添加监听，还需要开启update定时器，像这样的代码，
local layer = display.newLayer()    
   self:addChild(layer)  
   layer:scheduleUpdate()  
   layer:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)  
       print(dt)  
   end)

硬件按键事件

要实现一个按键响应事件主要就两步：
  1. 打开键盘功能setKeypadEnabled(true)
  2. 添加事件监听addNodeEventListener


回调函数中event参数只有一个字段“key”，可以判断获取key是back还是menu，这样一来，按键事件就算掌握了，使用device类提供
的对话框咱们来测试下，当然这个最好是真机测试了。
function MyScene:ctor()   
    local layer = display.newLayer()    
    self:addChild(layer)  
    layer:setKeypadEnabled(true)  
    layer:addNodeEventListener(cc.KEYPAD_EVENT, function (event)  
        if event.key == "back" then  
            print("back")  
            device.showAlert("Confirm Exit", "Are you sure exit game ?", {"YES", "NO"}, function (event)  
                if event.buttonIndex == 1 then  
                    CCDirector:sharedDirector():endToLua()  
                else  
                    device.cancelAlert()   
                end  
            end)           
        elseif event.key == "menu" then  
            print("menu")               
        end        
    end)   
end

升级到 2.2.3
http://cn.cocos2d-x.org/article/index?type=quick_doc&url=/doc/cocos-docs-master/manual/framework/quick/how-to/upgrade-to-2_2_3/zh.md
================================================================================================
================================================================================================


    
    
    
framework:quick的核心部分，在Cocos2d-x基础上自己搭建的一套framework。

api:quick封装的库目录,现在基本里面的接口都改到cc目录下。
  Context.lua: 存取索引数据,目前已经弃用。
  EventProtocol.lua: 事件侦听协议，目前已经弃用。推荐使用cc.components.behavior.EventProtocol。
  GameNetwork.lua:第三方游戏平台SDK集成，如：OpenFeint，GameCenter等。现在已经弃用，推荐使用cc.sdk.social。
  GameState.lua:存取游戏数据。现在已经弃用，推荐使用cc.utils.State。
  Localize.lua:游戏本地化，主要是文字的本地华。现在已经弃用，推荐使用cc.utils.Localize。
  Store.lua:提供了游戏内的计费功能。现在已经弃用，推荐使用cc.sdk.pay。
  Timer.lua:这个是基于 2D-X 中 scheduler 计时器的一个扩展，他可以方便的管理各个计时器，并添加了一些方便的功能，例如：100秒的时间，每5秒调用触发一次计时器事件。推荐使用cc.utils.Timer。
  
  
cc：cc扩展在Cocos2d-x C++ API和quick基本模块的基础上，提供了符合脚本风格的事件接口、组件架构等扩展。
  init.lua:初始化cc扩展
  GameObject.lua:quick现在使用的一套类似Unity3D的GameObject的框架
  Registry.lua:quick中GameObject的注册器
  EventProxy.lua:quick的事件管理器
  ad:广告平台sdk的封装，目前只有pushbox的接口
  analytics:游戏统计分析平台的封装，目前只有友盟的接口
  Component:组件基类，所有组件都要派生自它
  feedback:反馈SDK的封装，目前只有友盟反馈sdk的接口
  mvc:quick中的mvc结构，要使用mvc结构的话只需要集成AppBase和ModelBase
  net:网络接口封装，使用Socket连接
  push:push SDK封装，目前包含友盟push和cocopush两个push的SDK
  share:分享SDK封装，目前包含友盟分享SDK
  ui:quick封装的Cocos2d-x控件，包含:UIGroup、UIImage，UIPushButton，UICheckBoxButton，UICheckBoxButtonGroup，UILabel，UISlider，UIBoxLayout
  update:自动更新组件的封装，使用的是友盟的更新SDK
  utils:quick中其他的封装的功能
  
cocos2dx:quick对Cocos2d-x中的扩展
platform:平台移植代码
audio.lua:音乐、音效管理
cocos2dx.lua:导入Cocos2d-x的库
crypto.lua:加解密、数据编码库
debug.lua:提供调试接口
deprecated.lua:定义所有已经废弃的 API
device.lua:提供设备相关属性的查询，以及设备功能的访问
display.lua:与显示图像、场景有关的功能
filter.lua:滤镜功能
functions.lua:提供一组常用函数，以及对 Lua 标准库的扩展
init.lua:quick framework的初始化
json.lua:json的编码与解码
luaj.lua:Lua与Java之间的交互接口
luaoc.lua:Lua与Objective-c之间的交互接口
network.lua:网络接口封装，检查wifi和3G网络情况等
schduler.lua:全局计时器、计划任务，该模块在框架初始化时不会自动载入
shortcode.lua:一些经常使用的短小的代码，比如设置旋转角度之类
transition.lua:为动作和对象添加效果
ui.lua:创建和管理用户界面