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

###cc函数
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



###Component的target_和exportMethods_
```
------------------------------------------------------------------------------
------------------------------------------------------------------------------
function BaseScene:ctor()
    --echoInfo("BaseScene:ctor")
    
    --Make scene into a GameObject
    cc.GameObject.extend(self)
    self:addComponent("app.components.VoiceOperator"):exportMethods()
end
   ------------------------------------------------------------------------------
   
   /Users/wangliang/rev/env/dev/quick-cocos2d-x-2.2.5/framework/cc/GameObject.lua:
   ------------------------------------------------------------------------------
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

   ----------------------------------------------------------------------
/Users/wangliang/rev/env/dev/quick-cocos2d-x-2.2.5/framework/cc/components/Component.lua:

function Component:exportMethods_(methods)
    self.exportedMethods_ = methods
    local target = self.target_
    local com = self
    for _, key in ipairs(methods) do
        if not target[key] then
            local m = com[key]
            target[key] = function(__, ...)
                return m(com, ...)
            end
        end
    end
    return self
end

   16  
   17  function Component:getTarget()
   18:     return self.target_
   19  end
   20  
   21  function Component:exportMethods_(methods)
   22      self.exportedMethods_ = methods
   23:     local target = self.target_
   24      local com = self
   25      for _, key in ipairs(methods) do
   ..
   35  
   36  function Component:bind_(target)
   37:     self.target_ = target
   38      for _, name in ipairs(self.depends_) do
   39          if not target:checkComponent(name) then
   ..
   46  function Component:unbind_()
   47      if self.exportedMethods_ then
   48:         local target = self.target_
   49          for _, key in ipairs(self.exportedMethods_) do
   50              target[key] = nil
```

```
------------------------------------------------------------------------------
------------------------------------------------------------------------------
function BaseScene:ctor()
    --echoInfo("BaseScene:ctor")
    
    --Make scene into a GameObject
    cc.GameObject.extend(self)

    self:addComponent("app.components.PopupManager"):exportMethods()
    self:addComponent("app.components.KeypadDispatcher"):exportMethods()
    self:addComponent("app.components.VoiceOperator"):exportMethods()
end
   ------------------------------------------------------------------------------
   
   /Users/wangliang/rev/env/dev/quick-cocos2d-x-2.2.5/framework/cc/GameObject.lua:
   ------------------------------------------------------------------------------
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

   ----------------------------------------------------------------------
/Users/wangliang/rev/env/dev/quick-cocos2d-x-2.2.5/framework/cc/components/Component.lua:
   16  
   17  function Component:getTarget()
   18:     return self.target_
   19  end
   20  
   21  function Component:exportMethods_(methods)
   22      self.exportedMethods_ = methods
   23:     local target = self.target_
   24      local com = self
   25      for _, key in ipairs(methods) do
   ..
   35  
   36  function Component:bind_(target)
   37:     self.target_ = target
   38      for _, name in ipairs(self.depends_) do
   39          if not target:checkComponent(name) then
   ..
   46  function Component:unbind_()
   47      if self.exportedMethods_ then
   48:         local target = self.target_
   49          for _, key in ipairs(self.exportedMethods_) do
   50              target[key] = nil
```
*Component的target_就是扩展后的对象*

####EventProtocol

```
function EventProtocol.extend(object)
    PRINT_DEPRECATED("module api.EventProtocol is deprecated, please use cc.components.behavior.EventProtocol")

    object.listeners_ = {}
    object.listenerHandleIndex_ = 0

    function object:addEventListener(eventName, listener, target)
        eventName = string.upper(eventName)
        if object.listeners_[eventName] == nil then
            object.listeners_[eventName] = {}
        end

        local ttarget = type(target)
        if ttarget == "table" or ttarget == "userdata" then
            PRINT_DEPRECATED("api.EventProtocol.addEventListener(eventName, listener, target) is deprecated, please use api.EventProtocol.addEventListener(eventName, handler(target, listener))")
            listener = handler(target, listener)
            tag = ""
        end

        object.listenerHandleIndex_ = object.listenerHandleIndex_ + 1
        local handle = string.format("HANDLE_%d", object.listenerHandleIndex_)
        object.listeners_[eventName][handle] = listener
        return handle
    end

    function object:dispatchEvent(event)
        event.name = string.upper(event.name)
        local eventName = event.name
        if object.listeners_[eventName] == nil then return end
        event.target = object
        for handle, listener in pairs(object.listeners_[eventName]) do
            local ret = listener(event, a)
            if ret == false then
                break
            elseif ret == "__REMOVE__" then
                object.listeners_[eventName][handle] = nil
            end
        end
    end

    function object:removeEventListener(eventName, key)
        eventName = string.upper(eventName)
        if object.listeners_[eventName] == nil then return end

        for handle, listener in pairs(object.listeners_[eventName]) do
            if key == handle or key == listener then
                object.listeners_[eventName][handle] = nil
                break
            end
        end
    end

    function object:removeAllEventListenersForEvent(eventName)
        object.listeners_[string.upper(eventName)] = nil
    end

    function object:removeAllEventListeners()
        object.listeners_ = {}
    end

    return object
end
```
*EventProtocol也是Component*


####ModelBase天生就具有EventProtocol组件的方法：

```
function ModelBase:ctor(properties)
    cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    self.isModelBase_ = true
    if type(properties) ~= "table" then properties = {} end
    self:setProperties(properties)
end

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
```

####export之后,Component中的方法中self不是扩展后的对象，而是Component
```
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
```