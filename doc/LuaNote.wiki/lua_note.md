Lua 有一个特性就是默认定义的变量都是全局的。为了避免这一点，我们需要在定义变量时使用 local 关键字。

但难免会出现遗忘的情况，这时候出现的一些 bug 是很难查找的。所以我们可以采取一点小技巧，改变创建全局变量的方式。

```

local __g = _G

-- export global variable
cc.exports = {}
setmetatable(cc.exports, {
    __newindex = function(_, name, value)
        rawset(__g, name, value)
    end,

    __index = function(_, name)
        return rawget(__g, name)
    end
})

-- disable create unexpected global variable
setmetatable(__g, {
    __newindex = function(_, name, value)
        local msg = "USE 'cc.exports.%s = value' INSTEAD OF SET GLOBAL VARIABLE"
        error(string.format(msg, name), 0)
    end
})
```
增加上面的代码后，我们要再定义全局变量就会的得到一个错误信息。

但有时候全局变量是必须的，例如一些全局函数。我们可以使用新的定义方式：

```
-- export global
cc.exports.MY_GLOBAL = "hello"

-- use global
print(MY_GLOBAL)
-- or
print(_G.MY_GLOBAL)
-- or
print(cc.exports.MY_GLOBAL)

-- delete global
cc.exports.MY_GLOBAL = nil

-- global function
local function test_function_()
end
cc.exports.test_function = test_function_

-- if you set global variable, get an error
INVALID_GLOBAL = "no"


```
quick 3.3final 是 3.3 系列最后一个版本，相比之前的 3.3rc1 版，主要改动如下：

升级到 cocos2d-x 3.3final
用 Lua 5.1.5 替换了 LuaJIT 2.0.3：具体原因参考 为什么用 Lua 替换 LuaJIT
提供了 Lua 字节码虚拟机执行码加密功能
提供了模块化编译能力，可以创建最小化的 so 文件（仅限 Android 平台），参考 编译 Android 工程
增加 HTTPRequest for Android，在 Android 上可以去掉对 CURL 的依赖，减小 so 体积
更新 CCSLoader，支持最新版 Cocos Studio
支持最新版 Cocos Code IDE
集成 nanovg 用于绘制反锯齿的矢量图
增加一个塔防示例，提供地图编辑和性能测试
修复了自 3.3rc1 发布以来发现的 Bug

quick v3 基于最新的 cocos2d-x 3.2 正式版开发，具有 cocos2d-x 3.2 的所有功能，包括 3D 渲染等。除了 cocos2d-x 3.2 原有的功能，我们移植了 quick 独有的触摸事件机制和其他功能扩展。

如果你是 quick-cocos2d-x 2.x 的用户，那么不用费多大功夫就可以掌握 quick v3 的使用，因为我们保持了几乎完全一致的 API 和用法。

如果你是 quick-cocos2d-x 的新用户，那么更完善的文档和带有详尽中文注释的示例，可以帮助你快速进入工作状态。

我们努力的目标就是为大家提供一个更容易学习、更容易使用、具有更高效率的手游引擎！


这个版本相比 2.2.5 的主要改进如下：

修复 2.2.5 发布后发现的一些 bug
修复 Android 上多点触摸存在的问题(强烈推荐 2.2.5 版升级)
支持 Cocos Studio for Windows 1.6 版
增加 CCSLoader 组件(从 quick v3.2 迁移来，文档在此)
集成 DragonBonesCPP，完善支持 DragonBones 骨骼动画，参考示例samples/dragonbones
集成 FilteredSprite，为 Sprite 添加各种过滤器效果，参考示例 samples/filters

2.2.3-rc 相比 2.2.1-rc 除了升级一些基础组件外，更重大的改进都在底层：

完全重写的 CCScriptEventDispatcher，提供了更容易使用、更灵活的 CCNode 事件分发机制
完全重写的触摸机制，实现了“三阶段”触摸事件分发： capturing, targeting, bubbling
对 tolua++ 底层的重大改进：更容易使用的 C++ 类型映射、隐形内存泄露等问题
基于 Qt 的 QuickPlayer，功能更加强大，扩展更容易
Lua 脚本字节码加密和资源加密保护你的劳动成果
CCFliteredSprite 提供了实现数十种 shader 特效的简单途径(特别感谢 zrong)


http://quick.cocos.org/?p=1527#more-1527
用 Eclipse LDT 调试 quick-cocos2d-x 游戏

http://quick.cocos.org/?p=1436#more-1436
quick-cocos2d-x 多分辨率适配详解

https://github.com/dualface/v3quick/blob/v3/docs/howto/compile-android/zh.md
https://github.com/dualface/v3quick/blob/v3/docs/howto/encrypt-lua-code/zh.md