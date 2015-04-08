###触摸
```
////////////////////////////////////////////////////////////
//LsTouchEvent.h
////////////////////////////////////////////////////////////
#ifndef LSTOUCH_H_
#define LSTOUCH_H_

#include "cocos2d.h"

USING_NS_CC;

class LsTouchEvent;

/**
 * 定义可触摸元素，用于统一管理
 */
class LsTouch: public CCNode {
public:
	LsTouch();
	~LsTouch();
	CREATE_FUNC(LsTouch);
	virtual bool init()	;

	// 设置显示项
	void setDisplay(CCSprite* dis);

	void setEventId(int eventId);
	int getEventId();

	/// 常规判断
	bool selfCheck(CCTouch* ccTouch, LsTouchEvent* lsTe);

private:
	// 判断当前的元素是否被点击
	bool containsCCTouchPoint(CCTouch* ccTouch);
	bool isParentAllVisible(LsTouchEvent* lsTe);

	// 用户保存显示精灵的 tag
	static const int TAG_DISPLAY = 100;
	int m_iEventId;

};

class LsTouchEvent {
public:
	LsTouchEvent();
	~LsTouchEvent();

	void addLsTouch(LsTouch* touch, int eventId);

	void removeLsTouch(LsTouch* touch);

	bool sendTouchMessage(CCTouch* ccTouch);

	// 返回优先级较高的可触摸对象
	LsTouch* getPriorityTouch(LsTouch* a, LsTouch* b);

	virtual void touchEventAction(LsTouch* touch) = 0;
private:
	CCArray* m_pLsTouches;
};

#endif /* LSTOUCH_H_ */

////////////////////////////////////////////////////////////
//LsTouch.cpp
////////////////////////////////////////////////////////////
#include "LsTouch.h"

LsTouch::LsTouch() {
	CCLog("LsTouch()");
	m_iEventId = 0;
}

LsTouch::~LsTouch() {
	CCLog("LsTouch().~()");
}

bool LsTouch::init() {

	return true;
}

void LsTouch::setDisplay(CCSprite* dis) {
	// 设置之前先清除，没有也无所谓
	removeChildByTag(TAG_DISPLAY, true);
	addChild(dis, 0, TAG_DISPLAY);
}

void LsTouch::setEventId(int eventId) {
	m_iEventId = eventId;
}

int LsTouch::getEventId() {
	return m_iEventId;
}

bool LsTouch::selfCheck(CCTouch* ccTouch, LsTouchEvent* lsTe) {
	bool bRef = false;
	// 可点击项的检测，可扩展
	do {
		// 是否通过点击位置检测
		CC_BREAK_IF(!containsCCTouchPoint(ccTouch));
		// 是否正在运行，排除可能存在已经从界面移除，但是并没有释放的可能
		CC_BREAK_IF(!isRunning());

		// 判断是否隐藏
		CC_BREAK_IF(!isVisible());
		// 这里可能还需要判断内部显示项目是否隐藏
		///// 暂留
		// 不仅判断当前元素是否隐藏，还需要判断在它之上的元素直到事件处理层，是否存在隐藏
		CC_BREAK_IF(!isParentAllVisible(lsTe));

		bRef = true;
	} while (0);
	return bRef;
}

bool LsTouch::containsCCTouchPoint(CCTouch* ccTouch) {
	// 获得显示内容
	CCNode* dis = getChildByTag(TAG_DISPLAY);
	CCSprite* sprite = dynamic_cast<CCSprite*>(dis);
	CCPoint point = sprite->convertTouchToNodeSpaceAR(ccTouch);
	CCSize s = sprite->getTexture()->getContentSize();
	CCRect rect = CCRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
	return rect.containsPoint(point);
}

bool LsTouch::isParentAllVisible(LsTouchEvent* lsTe) {
	bool bRef = true;
	// 向父类转型，以便获取地址比较对象，LsTouchEvent 的对象必须同时直接或者简介继承 CCNode
	CCNode* nLsTe = dynamic_cast<CCNode*>(lsTe);

	CCNode* parent = getParent();
	do {
		// 如果遍历完毕，说明 LsTouch 不再 LsTouchEvent 之内
		if (!parent) {
			bRef = false;
			break;
		}
		// 如果 LsTouch 在 LsTouchEvent 之内，返回 true
		// 注意：如果想让LsTouchEvent 处理 不在其 CCNode 结构之内的元素，则取消此处判断
		if (nLsTe == parent) {
			break;
		}
		if (!parent->isVisible()) {
			bRef = false;
			break;
		}
		parent = parent->getParent();
	} while (1);
	return bRef;
}

LsTouchEvent::LsTouchEvent() {
	CCLog("LsTouchEvent()");
	m_pLsTouches = CCArray::create();
	m_pLsTouches->retain();
}

LsTouchEvent::~LsTouchEvent() {
	CCLog("LsTouchEvent().~()");
	m_pLsTouches->release();
}

void LsTouchEvent::addLsTouch(LsTouch* touch, int eventId) {
	touch->setEventId(eventId);
	m_pLsTouches->addObject(touch);
}

void LsTouchEvent::removeLsTouch(LsTouch* touch) {
	m_pLsTouches->removeObject(touch, true);
}

bool LsTouchEvent::sendTouchMessage(CCTouch* ccTouch) {
	// 编写判断，集合中的哪个元素级别高，就触发哪一个
	LsTouch* lsTouch = NULL;

	// 获得点击的点
	CCObject* pObj = NULL;
	LsTouch* lt = NULL;
	CCARRAY_FOREACH(m_pLsTouches, pObj) {
		lt = dynamic_cast<LsTouch*>(pObj);
		if (lt) {
			if (lt->selfCheck(ccTouch, this)) {
				if (lsTouch == NULL)
					lsTouch = lt;
				else
					// 如果已存在符合条件元素，比较优先级
					lsTouch = getPriorityTouch(lsTouch, lt);
			}
		}
	}
// 比对最终只有一个元素触发
	if (lsTouch){
		touchEventAction(lsTouch);
		return true;
	}
	return false;
}

LsTouch* LsTouchEvent::getPriorityTouch(LsTouch* a, LsTouch* b) {
	// 触摸优先级通过 CCNode 树判断，也既是显示层次级别等因素
	// 以当前元素为“根”向父类转型，以便获取地址比较对象，LsTouchEvent 的对象必须同时直接或者简介继承 CCNode
	CCNode* nLsTe = dynamic_cast<CCNode*>(this);

	// 共同的分枝
	CCNode* allParent = NULL;
	// 寻找 a 与 b 共同的分枝
	CCNode* nAParent = a;
	CCNode* nBParent = b;
	CCNode* nAChild = NULL;
	CCNode* nBChild = NULL;
	do {
		nAChild = nAParent;
		nAParent = nAParent->getParent();
		if (!nAParent)
			break;

		nBParent = b;
		do {
			nBChild = nBParent;
			nBParent = nBParent->getParent();
			if (!nBParent)
				break;
			if (nAParent == nBParent) {
				allParent = nAParent;
				break;
			}
			if (nBParent == nLsTe) {
				break;
			}
		} while (1);
		if (allParent)
			break;
		if (nAParent == nLsTe) {
			break;
		}
	} while (1);

	// 此处只需要判断 nAChild 和 nBChild 的优先级即可，默认返回 a
	if (!nAChild || !nBChild)
		return a;
	// 根据 ZOrder 判断，如果 ZOrder一样，根据索引位置判断
	if (nAChild->getZOrder() == nBChild->getZOrder())
		return allParent->getChildren()->indexOfObject(nAChild) > allParent->getChildren()->indexOfObject(nBChild)? a: b;
	else
		return nAChild->getZOrder() > nBChild->getZOrder()? a: b;
}


////////////////////////////////////////////////////////////
//TouchEventTest.h
////////////////////////////////////////////////////////////
#ifndef TOUCHEVENTTEST_H_
#define TOUCHEVENTTEST_H_

#include "testBasic.h"
#include "cocos2d.h"
#include "LsTouch.h"

class TouchEventTestScene: public TestScene {
public:
	virtual void runThisTest();
};

class TouchEventTest: public CCLayer , public LsTouchEvent{
public:
	CREATE_FUNC(TouchEventTest)
	;
	virtual bool init();

	virtual void ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent);

	virtual void touchEventAction(LsTouch* touch);
};


#endif /* TOUCHEVENTTEST_H_ */

////////////////////////////////////////////////////////////
//TouchEventTest.cpp
////////////////////////////////////////////////////////////

#include "TouchEventTest.h"
#include "cocos2d.h"

USING_NS_CC;

void TouchEventTestScene::runThisTest() {
	CCLayer* layer = TouchEventTest::create();
	addChild(layer);

	CCDirector::sharedDirector()->replaceScene(this);
}

bool TouchEventTest::init() {
	bool bRef = false;
	do {
		CC_BREAK_IF(!CCLayer::init());

		// 启用触摸
		setTouchEnabled(true);

		CCSize winSize = CCDirector::sharedDirector()->getWinSize();
		CCPoint center = ccp(winSize.width/ 2, winSize.height / 2);

		// 创建可触摸精灵
		LsTouch* lt = LsTouch::create();
		// 设置位置
		lt->setPosition(center);
		// 设置显示精灵
		lt->setDisplay(CCSprite::create("Peas.png"));
		// 添加到显示
		this->addChild(lt);
		// 添加到触摸管理，第二个参数，事件 Id
		this->addLsTouch(lt, 100);

		LsTouch* lt2 = LsTouch::create();
		lt2->setPosition(ccpAdd(center, ccp(20, 10)));
		lt2->setDisplay(CCSprite::create("Peas.png"));
		addChild(lt2);
		this->addLsTouch(lt2, 101);

		bRef = true;
	} while (0);

	return bRef;
}

void TouchEventTest::ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent) {
	CCSetIterator it = pTouches->begin();
	CCTouch* touch = (CCTouch*) (*it);
	// 发送触摸消息，并在 touchEventAction 自动回调相应的事件
	sendTouchMessage(touch);
}

void TouchEventTest::touchEventAction(LsTouch* touch) {
	CCLog("touch event action id: %d", touch->getEventId());
}


```
###cocos弹出对话框
```
////////////////////////////////////////////////////////////
//PopupScene.h
////////////////////////////////////////////////////////////

#ifndef TestCpp_PopupScene_h
#define TestCpp_PopupScene_h

#include "cocos2d.h"

USING_NS_CC;

class Popup: public CCLayer{
public:
    static CCScene* scene();
    virtual bool init();
    CREATE_FUNC(Popup);

    void popupLayer();
    
    void menuCallback(CCObject* pSender);
    void buttonCallback(CCNode* pSender);
};

#endif

////////////////////////////////////////////////////////////
//PopupScene.cpp
////////////////////////////////////////////////////////////
#include "PopupScene.h"
#include "PopupLayer.h"

CCScene* Popup::scene(){
    CCScene* scene = CCScene::create();
    CCLayer* layer = Popup::create();
    scene->addChild(layer);
    return scene;
}

bool Popup::init(){
    bool bRef = false;
    
    do {
        CC_BREAK_IF(!CCLayer::init());
        
        CCSize winSize = CCDirector::sharedDirector()->getWinSize();
        CCPoint pointCenter = ccp(winSize.width / 2, winSize.height / 2);

        // 添加背景图片
        CCSprite* background = CCSprite::create("HelloWorld.png");
        background->setPosition(pointCenter);
        background->setScale(1.5f);
        this->addChild(background);    
        
//        popupLayer();
        
        
        // 添加菜单
        CCMenu* menu = CCMenu::create();
        
        CCMenuItemFont* menuItem = CCMenuItemFont::create("popup", this, menu_selector(Popup::menuCallback));
        menuItem->setPosition(ccp(200, 50));
        menuItem->setColor(ccc3(0, 0, 0));
        menu->addChild(menuItem);
        

        menu->setPosition(CCPointZero);
        this->addChild(menu);
        

        CCLog("klt");
        bRef = true;
    } while (0);
    
    return bRef;
}

void Popup::popupLayer(){
    // 定义一个弹出层，传入一张背景图
    PopupLayer* pl = PopupLayer::create("popuplayer/BackGround.png");
    // ContentSize 是可选的设置，可以不设置，如果设置把它当作 9 图缩放
    pl->setContentSize(CCSizeMake(400, 350));
    pl->setTitle("吾名一叶");
    pl->setContentText("娇兰傲梅世人赏，却少幽芬暗里藏。不看百花共争艳，独爱疏樱一枝香。", 20, 60, 250);
    // 设置回调函数，回调传回一个 CCNode 以获取 tag 判断点击的按钮
    // 这只是作为一种封装实现，如果使用 delegate 那就能够更灵活的控制参数了
    pl->setCallbackFunc(this, callfuncN_selector(Popup::buttonCallback));
    // 添加按钮，设置图片，文字，tag 信息
    pl->addButton("popuplayer/pop_button.png", "popuplayer/pop_button.png", "确定", 0);
    pl->addButton("popuplayer/pop_button.png", "popuplayer/pop_button.png", "取消", 1);
    // 添加到当前层
    this->addChild(pl);
}

void Popup::menuCallback(cocos2d::CCObject *pSender){
    popupLayer();
}

void Popup::buttonCallback(cocos2d::CCNode *pNode){
    CCLog("button call back. tag: %d", pNode->getTag());
}

////////////////////////////////////////////////////////////
//PopupLayer.h
////////////////////////////////////////////////////////////

#ifndef TestCpp_PopupLayer_h
#define TestCpp_PopupLayer_h

#include "cocos2d.h"
#include "cocos-ext.h"

using namespace cocos2d;
using namespace cocos2d::extension;

class PopupLayer: public CCLayer{
public:
    PopupLayer();
    ~PopupLayer();
    
    virtual bool init();
    CREATE_FUNC(PopupLayer);
    
    virtual void registerWithTouchDispatcher(void);
    bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    
    static PopupLayer* create(const char* backgroundImage);
    
    void setTitle(const char* title, int fontsize = 20);
    void setContentText(const char* text, int fontsize = 20, int padding = 50, int paddintTop = 100);

    void setCallbackFunc(CCObject* target, SEL_CallFuncN callfun);
    
    bool addButton(const char* normalImage, const char* selectedImage, const char* title, int tag = 0);    
    virtual void onEnter();
    virtual void onExit();
    
private:
    
    void buttonCallback(CCObject* pSender);

    // 文字内容两边的空白区
    int m_contentPadding;
    int m_contentPaddingTop;
    
    CCObject* m_callbackListener;
    SEL_CallFuncN m_callback;

    CC_SYNTHESIZE_RETAIN(CCMenu*, m__pMenu, MenuButton);
    CC_SYNTHESIZE_RETAIN(CCSprite*, m__sfBackGround, SpriteBackGround);
    CC_SYNTHESIZE_RETAIN(CCScale9Sprite*, m__s9BackGround, Sprite9BackGround);
    CC_SYNTHESIZE_RETAIN(CCLabelTTF*, m__ltTitle, LabelTitle);
    CC_SYNTHESIZE_RETAIN(CCLabelTTF*, m__ltContentText, LabelContentText);
    
    
};

#endif
////////////////////////////////////////////////////////////
//PopupLayer.cpp
////////////////////////////////////////////////////////////
#include "PopupLayer.h"

PopupLayer::PopupLayer():
m__pMenu(NULL)
, m_contentPadding(0)
, m_contentPaddingTop(0)
, m_callbackListener(NULL)
, m_callback(NULL)
, m__sfBackGround(NULL)
, m__s9BackGround(NULL)
, m__ltContentText(NULL)
, m__ltTitle(NULL)
{
    
}

PopupLayer::~PopupLayer(){
    CC_SAFE_RELEASE(m__pMenu);
    CC_SAFE_RELEASE(m__sfBackGround);
    CC_SAFE_RELEASE(m__ltContentText);
    CC_SAFE_RELEASE(m__ltTitle);
    CC_SAFE_RELEASE(m__s9BackGround);
}

bool PopupLayer::init(){
    bool bRef = false;
    do{
        CC_BREAK_IF(!CCLayer::init());
        this->setContentSize(CCSizeZero);
        
        // 初始化需要的 Menu
        CCMenu* menu = CCMenu::create();
        menu->setPosition(CCPointZero);
        setMenuButton(menu);
        
        setTouchEnabled(true);
        
        bRef = true;
    }while(0);
    return bRef;
}

void PopupLayer::registerWithTouchDispatcher(){
    // 这里的触摸优先级设置为 -128 这保证了，屏蔽下方的触摸
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, -128, true);

}

bool PopupLayer::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){
    //
    CCLog("PopupLayer touch");
    return true;
}

PopupLayer* PopupLayer::create(const char *backgroundImage){
    PopupLayer* ml = PopupLayer::create();
    ml->setSpriteBackGround(CCSprite::create(backgroundImage));
    ml->setSprite9BackGround(CCScale9Sprite::create(backgroundImage));
    return ml;
}

void PopupLayer::setTitle(const char *title, int fontsize){
    CCLabelTTF* ltfTitle = CCLabelTTF::create(title, "", fontsize);
    setLabelTitle(ltfTitle);
}

void PopupLayer::setContentText(const char *text, int fontsize, int padding, int paddingTop){
    CCLabelTTF* ltf = CCLabelTTF::create(text, "", fontsize);
    setLabelContentText(ltf);
    m_contentPadding = padding;
    m_contentPaddingTop = paddingTop;
}

void PopupLayer::setCallbackFunc(cocos2d::CCObject *target, SEL_CallFuncN callfun){
    m_callbackListener = target;
    m_callback = callfun;    
}


bool PopupLayer::addButton(const char *normalImage, const char *selectedImage, const char *title, int tag){
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    CCPoint pCenter = ccp(winSize.width / 2, winSize.height / 2);
    
    // 创建图片菜单按钮
    CCMenuItemImage* menuImage = CCMenuItemImage::create(normalImage, selectedImage, this, menu_selector(PopupLayer::buttonCallback));
    menuImage->setTag(tag);
    menuImage->setPosition(pCenter);
    
    // 添加文字说明并设置位置
    CCSize imenu = menuImage->getContentSize();
    CCLabelTTF* ttf = CCLabelTTF::create(title, "", 20);
    ttf->setColor(ccc3(0, 0, 0));
    ttf->setPosition(ccp(imenu.width / 2, imenu.height / 2));
    menuImage->addChild(ttf);
    
    getMenuButton()->addChild(menuImage);
    return true;
}

void PopupLayer::buttonCallback(cocos2d::CCObject *pSender){
    CCNode* node = dynamic_cast<CCNode*>(pSender);
    CCLog("touch tag: %d", node->getTag());
    if (m_callback && m_callbackListener){
        (m_callbackListener->*m_callback)(node);
    }
    this->removeFromParent();
}

void PopupLayer::onEnter(){
    CCLayer::onEnter();
    
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    CCPoint pCenter = ccp(winSize.width / 2, winSize.height / 2);
    
    CCSize contentSize;
    // 设定好参数，在运行时加载
    if (getContentSize().equals(CCSizeZero)) {
        getSpriteBackGround()->setPosition(ccp(winSize.width / 2, winSize.height / 2));
        this->addChild(getSpriteBackGround(), 0, 0);
        contentSize = getSpriteBackGround()->getTexture()->getContentSize();
    } else {
        CCScale9Sprite *background = getSprite9BackGround();
        background->setContentSize(getContentSize());
        background->setPosition(ccp(winSize.width / 2, winSize.height / 2));
        this->addChild(background, 0, 0);
        contentSize = getContentSize();
    }
    
    
    // 添加按钮，并设置其位置
    this->addChild(getMenuButton());
    float btnWidth = contentSize.width / (getMenuButton()->getChildrenCount() + 1);
    
    CCArray* array = getMenuButton()->getChildren();
    CCObject* pObj = NULL;
    int i = 0;
    CCARRAY_FOREACH(array, pObj){
        CCNode* node = dynamic_cast<CCNode*>(pObj);
        node->setPosition(ccp( winSize.width / 2 - contentSize.width / 2 + btnWidth * (i + 1), winSize.height / 2 - contentSize.height / 3));
        i++;
    }
    
    
    // 显示对话框标题
    if (getLabelTitle()){
        getLabelTitle()->setPosition(ccpAdd(pCenter, ccp(0, contentSize.height / 2 - 35.0f)));
        this->addChild(getLabelTitle());
    }
    
    // 显示文本内容
    if (getLabelContentText()){
        CCLabelTTF* ltf = getLabelContentText();
        ltf->setPosition(ccp(winSize.width / 2, winSize.height / 2));
        ltf->setDimensions(CCSizeMake(contentSize.width - m_contentPadding * 2, contentSize.height - m_contentPaddingTop));
        ltf->setHorizontalAlignment(kCCTextAlignmentLeft);
        this->addChild(ltf);
    }

    // 弹出效果
    CCAction* popupLayer = CCSequence::create(CCScaleTo::create(0.0, 0.0),
                                              CCScaleTo::create(0.06, 1.05),
                                              CCScaleTo::create(0.08, 0.95),
                                              CCScaleTo::create(0.08, 1.0), NULL);
    this->runAction(popupLayer);

}

void PopupLayer::onExit(){
    
    CCLog("popup on exit.");
    CCLayer::onExit();
}

```
```
function ToucheScene:onEnter()
    local layer = display.newLayer()
    layer:setTouchEnabled(true)
    layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)
end 
```
layer是透明层，只是用于检测触摸。如果它是在最外层（或者最后添加进去的），就应该setTouchSwallowEnabled(false),否则,下面的Node无法收到事件,点击就无法完成(这样界面上如果有按钮，就无法响应)。如果它不是在最外层（或者不是最后添加的），就无所谓。
Button isTouchSwallowEnabled默认为true

local XXPopLayer = class("XXPopLayer", function() 
    return display.newColorLayer(cc.c4(0, 0, 0, 125))
    end)

function XXPopLayer:ctor()
    self:enableTouch(true)
    self:setTouchSwallowEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return true;
    end)
end

return XXPopLayer
    
    
    
无限重复 - CCRepeatForever
在CCRepeatForever Class Reference中，有这样一条警告“Warning: This action can't be Sequenceable because it is not an IntervalAction”，而实际上它的确是派生自CCActionInterval，这真有点儿把我也搞懵了。
仅从其本意来说，该类的作用就是无限期执行某个动作或动作序列，直到被停止。因此无法参与序列和同步，自身也无法反向执行（但是你可以将某一动作反向，然后无限重复执行）。

类似于这样的代码，就可以实现  无限来回的移动。
[cpp] view plaincopy
CCSprite* levelIcon = CCSprite::createWithSpriteFrameName("levelArrow.png");  
 levelIcon->setPosition(ccp(200, 150) );  
 this->addChild(levelIcon,4);  
  
 CCMoveBy *move = CCMoveBy::create(1.2f,ccp(0,10));  
 levelIcon->runAction(CCRepeatForever::create(static_cast<CCSequence *>(CCSequence::create(move,move->reverse(),NULL)))); 
 
     
```

Thread.currentThread().setContextClassLoader(getClass().getClassLoader());

   /**
     * Returns a "local" axis aligned bounding box of the node.
     * The returned box is relative only to its parent.
     *
     * @note This method returns a temporaty variable, so it can't returns const CCRect&
     * @todo Rename to getBoundingBox() in the future versions.
     *
     * @return A "local" axis aligned boudning box of the node.
     * @js getBoundingBox
     */
    virtual CCRect boundingBox(void);

    /**
     * This boundingBox will calculate all children's boundingBox every time
     */
    virtual CCRect getCascadeBoundingBox(void);
    virtual void setCascadeBoundingBox(const CCRect &boundingBox);
    virtual void resetCascadeBoundingBox(void);


local ccp = ccp(child:getPositionX(), child:getPositionY())
    local p = child:convertToWorldSpace(ccp)

    local size = parentButton:getContentSize()

    local cascadeBox = parentButton:getCascadeBoundingBox().size
    local box = parentButton:boundingBox().size

    printf("parent x %f, (%f, %f)", parentButton:getPositionX(), size.width, size.height)

    print(cascadeBox.width, box)
    printf("parent cascadeBox (%f, %f)", cascadeBox.width, cascadeBox.height)
    printf("parent box (%f, %f)", box.width, box.height)
    
    
void CCCallFunc::update(float time) {
    CC_UNUSED_PARAM(time);
    this->execute();
}

void CCCallFunc::execute() {
    if (m_pCallFunc) {
        (m_pSelectorTarget->*m_pCallFunc)();
    }
	if (m_nScriptHandler) {
		CCScriptEngineManager::sharedManager()->getScriptEngine()->executeCallFuncActionEvent(this);
	}
}



int CCLuaEngine::executeNodeTouchEvent(CCNode* pNode, int eventType, CCTouch *pTouch, int phase)
{
    m_stack->clean();
    CCLuaValueDict event;
    switch (eventType)
    {
        case CCTOUCHBEGAN:
            event["name"] = CCLuaValue::stringValue("began");
            break;

        case CCTOUCHMOVED:
            event["name"] = CCLuaValue::stringValue("moved");
            break;

        case CCTOUCHENDED:
            event["name"] = CCLuaValue::stringValue("ended");
            break;

        case CCTOUCHCANCELLED:
            event["name"] = CCLuaValue::stringValue("cancelled");
            break;

        default:
            CCAssert(false, "INVALID touch event");
            return 0;
    }

    event["mode"] = CCLuaValue::intValue(kCCTouchesOneByOne);
    switch (phase)
    {
        case NODE_TOUCH_CAPTURING_PHASE:
            event["phase"] = CCLuaValue::stringValue("capturing");
            break;

        case NODE_TOUCH_TARGETING_PHASE:
            event["phase"] = CCLuaValue::stringValue("targeting");
            break;

        default:
            event["phase"] = CCLuaValue::stringValue("unknown");
    }

    const CCPoint pt = CCDirector::sharedDirector()->convertToGL(pTouch->getLocationInView());
    event["x"] = CCLuaValue::floatValue(pt.x);
    event["y"] = CCLuaValue::floatValue(pt.y);
    const CCPoint prev = CCDirector::sharedDirector()->convertToGL(pTouch->getPreviousLocationInView());
    event["prevX"] = CCLuaValue::floatValue(prev.x);
    event["prevY"] = CCLuaValue::floatValue(prev.y);

    m_stack->pushCCLuaValueDict(event);

    int eventInt = (phase == NODE_TOUCH_CAPTURING_PHASE) ? NODE_TOUCH_CAPTURE_EVENT : NODE_TOUCH_EVENT;
    CCArray *listeners = pNode->getAllScriptEventListeners();
    CCScriptHandlePair *p;
    int ret = 1;
    for (int i = listeners->count() - 1; i >= 0; --i)
    {
        p = dynamic_cast<CCScriptHandlePair*>(listeners->objectAtIndex(i));
        if (p->event != eventInt || p->removed) continue;

        if (eventType == CCTOUCHBEGAN)
        {
            // enable listener when touch began
            p->enabled = true;
        }

        if (p->enabled)
        {
            m_stack->copyValue(1);
            int listenerRet = m_stack->executeFunctionByHandler(p->listener, 1);
            if (listenerRet == 0)
            {
                if (phase == NODE_TOUCH_CAPTURING_PHASE && (eventType == CCTOUCHBEGAN || eventType == CCTOUCHMOVED))
                {
                    ret = 0;
                }
                else if (phase == NODE_TOUCH_TARGETING_PHASE && eventType == CCTOUCHBEGAN)
                {
                    // if listener return false when touch began, disable this listener
                    p->enabled = false;
                    ret = 0;
                }
            }
            m_stack->settop(1);
        }
    }

    //CCLOG("executeNodeTouchEvent %p, ret = %d, event = %d, phase = %d", pNode, ret, eventType, phase);
    m_stack->clean();

    return ret;
}


```
###CCCallFunc家族函数
```
//  CCCallFunc家族函数：当我们需要在一个动作完成之后需要调用某个函数时使用
    CCSprite* player = CCSprite::create("Icon.png");
    player->setPosition(ccp(100, 100));
    this->addChild(player);
    
    
    CCMoveTo* action = CCMoveTo::create(1, ccp(200, 200));
//  CCCallFunc的功能非常简单，它只能简单地实现在动作序列中帮助我们调用一个函数的功能。
    
//    CCCallFunc* call  = CCCallFunc::create(this, callfunc_selector(HelloWorld::callBack));
//    //下面这行代码是创建一个动作序列
//    CCFiniteTimeAction* seq = CCSequence::create(action,call,NULL);
//    player->runAction(seq);
    
    
    
    
//    CCCallFuncN,既能够调用一个方法还能够将调用的对象传过去,这里的调用对象就是player
//    CCCallFuncN* callN = CCCallFuncN::create(this, callfuncN_selector(HelloWorld::callNodeBack));
//    CCFiniteTimeAction* seq2 = CCSequence::create(action,callN,NULL);
//    player->runAction(seq2);
    
    
    //先创建一个字典
    CCDictionary* dic = CCDictionary::create();
    dic->retain();
    dic->setObject(CCString::create("zxcc"), 1);
    
//    CCCallFuncND可以传递一个任意数据类型  例如，我们可以传递一个字典
//    CCCallFuncND* callND = CCCallFuncND::create(this, callfuncND_selector(HelloWorld::callNodeBack),(void*)dic);
//    CCFiniteTimeAction* seq3 = CCSequence::create(action,callND,NULL);
//    player->runAction(seq3);
    
   
    //我们创建一个精灵
    CCSprite* player2 = CCSprite::create("player2.png");
    player2->setPosition(ccp(300, 300));
    this->addChild(player2);
    
   // CCCallFuncND传值的类型只能为CCObject类型(在例子中我先移动一个精灵，再移动另一个精灵)
    CCCallFuncO* callO = CCCallFuncO::create(this, callfuncO_selector(HelloWorld::callObjectBack), player2);
    CCFiniteTimeAction* seq4 = CCSequence::create(action,callO,NULL);
    player->runAction(seq4);

```