chipmunk是一个用C写成的物理引擎，quick-cocos2d-x已经用C++对其进行封装，导出到lua的类有：

```
CCPhysicsWorld
CCPhysicsBody
CCPhysicsShape
CCPhysicsDebugNode
CCPhysicsCollisionEvent
CCPhysicsVector
```
1、`World`由`Body`组成，而`Body`又由`Shape`组成。就像我们所处的世界一样，世界由房屋，树木等等构成，而房屋由门窗，墙壁等组成，树木由叶子，树干，树枝等组成。

2、`CCPhysicsDebugNode`是用于显示各个物体的边框等等信息，主要用于调试。

3、`CCPhysicsCollisionEvent`是物体之间发生碰撞时产生的事件，事件中携带有碰撞时的信息。

4、`CCPhysicsVector`则是向量，物体受力时将会用到。


####1、建立World
我们要使用chipmunk，首选要建立一个世界(CCPhysicsWorld)

```
-- 建立没有引力的世界
CCPhysicsWorld:create()
-- 指定两个方向上的引力
CCPhysicsWorld:create(gravityX, gravityY)
```

示例： 

```
-- 引力向下的世界（跟地球类似）
self.world=CCPhysicsWorld:create(0,-200)
self:addChild(self.world)
```

####2、建立Body 
在chipmunk里，Body分为两种:static和非static（普通），static是固定不动的；形状上可以分为长（正）方形、圆形、多边形和自定义类型，建立它们的方法也很多。 

###### 1）可以通过Word里的方法创建： 

```
-- 当mass<=0时会创建一个StaticBody
World:createBoxBody(mass, width, height)

-- offset为偏移量
World:createCircleBody(mass, radius, offsetX, offsetY)

-- vertexes格式为{x1, y1, x2, y2, x3, y3}，目前的版本有bug，不可以设置offset
World:createPolygonBody(mass, vertexes, offsetX, offsetY)
```
示例：

```
local body = self.world:createBoxBody(10, 100, 100)
local body = self.world:createCircleBody(0, 20, 50, 50)
-- 创建一个三角形
local vertexes = {0,0,50,50,100,0}
local body=self.world:createPolygonBody(0, vertexes)
```
######2）通过Body里的方法创建：
```
CCPhysicsBody:createStaticBody(world)
CCPhysicsBody:create(world, mass, moment)
```
示例：

```
local body = CCPhysicsBody:createStaticBody(self.world)
-- 这种创建方式要记得把body放到world里
self.world:addBody(body)
```

######3）重要属性或方法：
```
-- 摩擦系数 0-1.0
body:setFriction(friction)
-- 反弹系数 0-1.0
body:setElasticity(elasticity)
-- 是否是感应
body:setIsSensor(isSensor)
body:isSensor()
-- 速度
body:setVelocity(velocityX, velocityY)
-- 角速度
body:setAngleVelocity(velocity)
-- 推力
body:applyForce(forceX, forceY, offsetX, offsetY)
body:applyForce(force, offsetX, offsetY)
body:applyImpulse(forceX, forceY, offsetX, offsetY)
body:applyImpulse(force, offsetX, offsetY)
```

######4）删除
```
-- unbind = true时,将解除绑定的CCNode，但不会从场景里删除node,只是执行CC_SAFE_RELEASE_NULL(node);
-- unbind = false时,CCNode将继续绑定在该Body上，默认为true

body:removeSelf(unbind)
World:removeBody(body, unbind)
World:removeBodyByTag(tag, unbind)
```

####3、建立Shape 
Shape要放置于Body中，一般情况下是不需要单独再建立Shape的，上面创建Body的时候很多就已经创建有一个Shape了。
当一个Body由多个独立的部分组成时（比如一个人由头部，手，脚，身体组成），则要通过创建多个Shape来完成了。

######1）Shape的创建都是由Body的方法来完成。
```
-- 线段，lowerLeft和lowerRight为CCPoint，thickness为粗细
Body:addSegmentShape(lowerLeft, lowerRight, thickness)
Body:addCircleShape(radius, offsetX, offsetY)
Body:addBoxShape(width, height)
-- 目前好像不能运行，已发issue到官方仓库
Body:addPolygonShape(vertexes, offsetX, offsetY)
```

######2）Shape的属性
```
-- 摩擦系数 0-1.0
shape:setFriction(friction)
-- 反弹系数 0-1.0
shape:setElasticity(elasticity)
-- 是否是感应
shape:setIsSensor(isSensor)
shape:isSensor()
```

######3）删除
```
body:removeShape(shapeObject)
body:removeShapeAtIndex(index)
body:removeAllShape()
```

####4、绑定 
之前我们都只是建立物理世界里的物体，并没有把它们同外观联系起来，比如把一个Box同一张箱子的图片结合在一起，这个就叫做绑定，在quick-cocos2d-x里可以通过

```
-- node为CCNode类型
Body:bind(node)
Body:unbind()
```
来完成绑定和解绑。
####5、调试 
很简单，只要加入以下代码即可：

```
self.worldDebug=self.world:createDebugNode()
self:addChild(self.worldDebug)
```

####一、监听事件
quick-cocos2d-x中的chipmunk碰撞处理是通过监听事件来实现的。

```
-- 设置物体的碰撞类别，默认所有物体都是类别0
Body:setCollisionType(type)
-- handle是一个回调函数，碰撞处理将在这个函数中执行
-- collisionTypeA和collisionTypeB是两个int值，表示要监听的是哪两种物体
-- 这两个值在body中设置（上面所示的方法），两个值相同时为监听同种物体之间的碰撞
World:addCollisionScriptListener(handler, collisionTypeA, collisionTypeB)
-- handler回调函数，这个函数一定要返回true，不然碰撞后两个物体将会重合，即像是不碰撞一样
-- eventType为碰撞的类别，有四种值：
--   begin 开始碰撞
--   preSolve 持续碰撞(相交)，可以设置相交时独自的摩擦，弹力等
--   postSolve 调用完preSolve后，做后期处理，比如计算破坏等等
--   separate 分开，当删除一个shape时也会调用
-- event为CCPhysicsCollisionEvent实例
onCollisionListener(eventType, event)
```
示例：

```
body:setCollisionType(1)
self.world:addCollisionScriptListener(handler(self, self.onCollisionListener), 1, 2)
function PhysicsScene:onCollisionListener(eventType, event)
    print(eventType)
    return true
end
```
####二、 CCPhysicsCollisionEvent 
在回调函数中，有个重要的参数就是event了，CCPhysicsCollisionEvent中包含很多碰撞时的信息

```
-- 获取CCPhysicsWorld
event:getWorld()
-- 获取两个碰撞的body
event:getBody1()
event:getBody2()
-- 是否是两种物体第一次接触
event:isFirstContact()
-- 弹性系数，在preSolve之前设置可改变当前值
event:setElasticity(elasticity)
event:getElasticity()
-- 摩擦系数，在preSolve之前设置可改变当前值
event:setFriction(friction)
event:getFriction()
-- 碰撞时两物体的接触点数
event:getCount()
-- 获取接触点
event:getPoint(index)
```
####三、分组碰撞 
我们在做一款游戏的时候，可能里面有很多的物体类型，我们希望某一物体只与特定的其它物体碰撞，而不是全部都碰撞，这种情况下就需要对物体进行分组了，在quick-cocos2d-x中可通过以下方法来实现

```
-- body所在的碰撞层，默认值为0，同层的物体才会发生碰撞
-- layers可以表示多个层，具体怎么达到的呢
-- 当我们对一个物体分层时，所用的数字应该为[1,2,4,8,16,32,...]这样形式（倍增）来分
-- 如A为1，B为2，C为4，即为基本层(layer)，如果要求C可与A碰撞，则C的layers为1+4=5
Body:setCollisionLayers(layers)
-- body所在组，默认值为0，同个组的将不发生碰撞（除了0组）
-- 优先级高于layer，当group不一样的时候才会考虑layers
Body:setCollisionGroup(group)
```
从上面我们可以得出：
两个物体要想发生碰撞，就要

**1、group不一样或都为0。**

**2、至少有一个layer（注意，非layers）是一样的 **。

下面将通过一个具体的案例来讲解。 
假如我们设计一个游戏，内容为上古部落之间的战争，有A,B,C,D四个部落，A和B为结盟关系，C,D则是各自独立的，这是一个三角混战的关系，那么就有以下的规则： 

```
1）A和B分别与C,D碰撞 
2）A和B之间不发生碰撞 
3）C与A,B,D之间都碰撞 
4）D与A,B,C之间都碰撞 
5）A,B,C,D之间各自（即A与A，B与B，...）不碰撞 
```
我们设计的基本层为：A=1,B=2,C=4,D=8 
 
可由上图得出它们各自的layers为 

```
A.layers=1 
B.layers=2 
C.layers=1+2+4+8 
D.layers=1+2+4+8 
```
上面有一些是重复的层，可以进行简化 

```
A.layers=1 
B.layers=2 
C.layers=1+2+4+8 
D.layers=1+2 +8 
```
还可以把C,D放在同一层4进行简化 

```
A.layers=1 
B.layers=2 
C.layers=1+2+4 
D.layers=1+2+4 
```
具体的分法并没有一个统一的方法，只要合乎上面的原则即可，而且物体多时会比较麻烦，大家要多加注意。 
设置layers只解决了1）——4）而已，5）还是没有解决，这就用到了group这一属性，我们把A,B,C,D设为不同的group即可 

```
A. group =1 
B. group =2 
C. group =3 
D. group =4 
```
最后的代码如下：

```
-- 为了程序清晰，layers不用求和
A:setCollisionLayers(1)
B:setCollisionLayers(2)
C:setCollisionLayers(1+2+4+8)
D:setCollisionLayers(1+2+4+8)
A:setCollisionGroup(1)
B:setCollisionGroup(2)
C:setCollisionGroup(3)
D:setCollisionGroup(4)
```