###宏&函数数组
```
class Hello {

};

// IntFuncArray为返回int *的函数数组
typedef int* (*IntFuncArray)();

// CREATE_INT_FUNC为创建函数的宏，函数名为create${className},即在参数名前面加上create
#define CREATE_INT_FUNC(className) \
static int* create##className() \
{  new className(); return NULL;}

// 函数名简化create${className},即CF(className)表示createClassName
#define CF(className) create##className

/**
 * 定义了一个函数
 * static int* createHello() {
 *      new Hello(); return NULL;
 * }
 */
CREATE_INT_FUNC(Hello)

/**
 *  定义了一个函数数组(createHello是上面CREATE_INT_FUNC创建的函数名)：
 *  {
 *      createHello
 *  }
 */
static IntFuncArray functionsArray[] = {
    CF(Hello),
};


```



```
http://www.cocos2d-x.org/wiki/How_to_use_CCLOG

CCLOG("Characters: %c %c", 'a', 65);
CCLOG("Decimals: %d %ld", 1977, 650000L);
CCLOG("Preceding with blanks: %10d", 1977);
CCLOG("Preceding with zeros: %010d", 1977);
CCLOG("Some different radixes: %d %x %o %#x %#o", 100, 100, 100, 100, 100);
CCLOG("Floats: %4.2f %.0e %E", 3.1416, 3.1416, 3.1416);
CCLOG("%s","A string");

Output:

cocos2d: Characters: a A
cocos2d: Decimals: 1977 650000
cocos2d: Preceding with blanks:       1977
cocos2d: Preceding with zeros: 0000001977
cocos2d: Some different radixes: 100 64 144 0x64 0144
cocos2d: Floats: 3.14 3e+00 3.141600E+00
cocos2d: A string
```

####CCMenu与CCMenuItem的坐标
```
CCMenuItem的坐标是CCMenu的坐标为原点，方向为OpenGL坐标系的方向。

CCMenu->alignItemsHorizontallyWithPadding:就是先计算出CCMenuItem+padding所占据的空间，
然后以CCMenu的坐标为原点（OpenGL坐标系的方向），左右均分（也就是CCMenu看起来在CCMenuItem的集合的中间）。


CCNode * CCBReader::readNodeGraph(CCNode * pParent) {
		.....
		CCNode *embeddedNode = ccbFileNode->getCCBFileNode();
        embeddedNode->setPosition(ccbFileNode->getPosition());
        embeddedNode->setRotation(ccbFileNode->getRotation());
        embeddedNode->setScaleX(ccbFileNode->getScaleX());
        embeddedNode->setScaleY(ccbFileNode->getScaleY());
        embeddedNode->setTag(ccbFileNode->getTag());
        embeddedNode->setVisible(true);
        
}
```
http://5.quanpao.com/?cat=40   
http://codingnow.cn/cocos2d-x/832.html   
http://www.cocos2d-x.org/docs/manual/framework/native/v3/menu/zh  
Lua中字符串库中的几个重点函数
C/C++操作Lua数组和字符串


####关于CREATE_FUNC
---

`CREATE_FUNC(HelloWorld);`定义了`create`的宏，`HelloWorld *layer = HelloWorld::create();`中调用的就是宏的函数。在`create`函数中，又调用了`init`函数。

`CREATE_FUNC`如下：

```
/**
 * define a create function for a specific type, such as CCLayer
 * @__TYPE__ class type to add create(), such as CCLayer
 */
#define CREATE_FUNC(__TYPE__) \
static __TYPE__* create() \
{ \
    __TYPE__ *pRet = new __TYPE__(); \
    if (pRet && pRet->init()) \
    { \
        pRet->autorelease(); \
        return pRet; \
    } \
    else \
    { \
        delete pRet; \
        pRet = NULL; \
        return NULL; \
    } \
}
```


####触摸事件
---

```
	在registerWithTouchDispatcher函数中：
	//注册单点  
    //CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, 0, true);  
    //注册多点  
    CCDirector::sharedDirector()->getTouchDispatcher()->addStandardDelegate(this, 0);  
    
    另外在AppController.mm添加：
    // ios默认关闭多点触摸，如果不增加这行代码，那么在模拟器上永远只能获取到一个触摸点，程序将变成单点触摸。
    [__glView setMultipleTouchEnabled:YES];
```

####Cocos2d-x字符串
---

```
    //string 转 char *
    std::string aString = "aString";
    const char *p = aString.c_str();
    
    //char 转 string
    std::string bString(p);
    
    //int 转 CCString
    CCString* ns = CCString::createWithFormat("%d",10);
    
    // int 转 char*
    char  a[10];
    int i = 789;
    sprintf(a,"%d",i);
    
    //CCString 转 char*
    const char *string = ns->getCString();

    //CCString 转 int
    int intVal = ns->intValue();
    
    //string 转 int（char* 转int）
    std::string numString = "100";
    std::atoi(numString.c_str());
    
    //convert string to char *
    char src3[10] = "";
    std::string str = "wangliang";
    const char * tmp = str.c_str();
    strcpy(src3, tmp);
    
    //convert int to char *
//    char src4[10] = "";
//    std::itoa(33,src4,10);
    

    //convert int to string
    std::stringstream ss;
    ss<< 10;
    std::string cat = std::string("") + ss.str();
    //clear
    ss.str("");
```


####Initializer inside class definition: Non-const static data member must be initialized out of line
---

除非是`constant integral` 或者 `enumeration`（The C++ standard allows only static constant integral or enumeration types to be initialized inside the class. Types bool, char, wchar_t, and the signed and unsigned integer types are collectively called integral types.43) A synonym for integral type is integer type.），这些可以在类中(header file)初始化(http://stackoverflow.com/questions/9656941/why-i-cant-initialize-non-const-static-member-or-static-array-in-class
)：

```
    static const int a = 3;
    enum { arrsize = 2 };
```    
一般的static const不能在类中初始化，否则`Non-const static data member must be initialized out of line`，解决方式：

###### 方式一（http://stackoverflow.com/questions/1563897/c-static-constant-string-class-member）、
```
You have to define your static member outside the class definition and provide the initailizer there.

First

// In a header file (if it is in a header file in your case)
class A {   
private:      
  static const string RECTANGLE;
};

and then

// In one of the implementation files
const string A::RECTANGLE = "rectangle";
```

###### 方式二、

```
In C++11 you can do now:
        
class A {
        private:
            static constexpr const char* STRING = "some useful string constant";
};
```
###### 方式三、

```
    // static member function cannot have 'const' qualifier（A static member function does not have a this pointer (such a function is not called on a particular instance of a class), so const qualification of a static member function doesn't make any sense.）
    static const std::string RECTANGLE() /**const*/ {
        return "rectangle";
    }
    
    static const std::string& RECTANGLE2(void)
    {
        static const std::string str = "rectangle";
        
        return str;
    }
    
    or 

	#define RECTANGLE "rectangle"
```

#####Array initializer must be an initializer list or string literal
---

```
    拷贝数组
    std::string str = "网络连接错误！";
    char s_errorBuffer[1024] = str.c_str();

    改成：
    char s_errorBuffer2[1024];
    strcpy(s_errorBuffer2, str.c_str());
    
    拷贝数组
    
    //    int _detail[] = { 1, 2 };
	//    int * ptr = new int[2];
	//    std::copy( _detail, _detail + (sizeof detail / sizeof (detail[0])), ptr );
	//    delete [] ptr;


    http://publib.boulder.ibm.com/infocenter/lnxpcomp/v8v101/index.jsp?topic=/com.ibm.xlcpp8l.doc/language/ref/aryin.htm
    http://stupefydeveloper.blogspot.com/2008/10/c-initializing-arrays.html
    enum
    {
        ERR_OK,
        ERR_FAIL,
        ERR_MEMORY
    };
    
	#define _ITEM(x) [x] = #x
   
    char* array[] =
    {
        _ITEM(ERR_OK),
        _ITEM(ERR_FAIL),
        _ITEM(ERR_MEMORY)
    };
    
    
	迭代数组
	 char* menuNames[22] = {
        "CCShaky3D",
        "CCShakyTiles3D"
    };
    for (char **iList = menuNames; *iList != NULL; ++iList)
    {
        std::cout << *iList << "\n";
    }
    
    std::cout << "============\n";

    
    使用vector迭代数组
    //char* strarray[] = {"hey", "sup", "dogg"};
    std::vector<std::string> strvector(menuNames, menuNames + 22);
    
    for(std::vector<std::string>::iterator iter = strvector.begin();iter != strvector.end(); ++iter)
    {
        std::cout<<*iter << "\n";

    }
    
    
    std::cout << "============\n";
    std::vector<int> ivec(10,1);
    for(std::vector<int>::iterator iter = ivec.begin();iter != ivec.end(); ++iter)
    {
        *iter = 2; //使用 * 访问迭代器所指向的元素
    }
    
    
    for(std::vector<int>::const_iterator citer=ivec.begin();citer!=ivec.end();citer++)
    {
        std::cout<<*citer << "\n";
        //*citer=3; error
    }
    
    std::cout << "============\n";

    ////////////////////////////////////////////////////////////////////////////////////
    const char* const list[] = {"zip", "zam", "bam"};
    const size_t len = sizeof(list) / sizeof(list[0]);
    
    for (size_t i = 0; i < len; ++i) {
        std::cout << list[i] << "\n";
    }
    std::cout << "============\n";

    const std::vector<std::string> v(list, list + len);
    std::copy(v.begin(), v.end(), std::ostream_iterator<std::string>(std::cout, "\n"));
    
    ////////////////////////////////////////////////////////////////////////////////////
    
```

####变长参数
----

######一、基本

在C,C++中无法确定传入的可变参数的个数（printf()中是通过扫描'%'个数来确实参数的个数的），因此要么就要指定个数，要么在参数的最后要设置哨兵数值.

```
const int GUARDNUMBER = -1;//注意GUARDNUMBER定义为0或者-1都不太好

/**
    以GUARDNUMBER作为结尾
  
    在C,C++中无法确定传入的可变参数的个数（printf()中是通过扫描'%'个数来确实参数的个数的），
    因此要么就要指定个数，要么在参数的最后要设置哨兵数值
 */
int MySum(int i, ...) {
    int sum = i;
    
    va_list argptr;
    va_start(argptr, i);
    
    printf("i is %d %p\n", i, argptr);
    
    while ((i = va_arg(argptr, int)) != GUARDNUMBER) {
        sum += i;
    }

    va_end(argptr);
    return sum;
}


/***
 nCount表示可变参数个数
 **/
int MySum2(int nCount, ...) {
    if (nCount <= 0) {
        return 0;
    }
    int sum = 0;
    va_list argptr;
    va_start(argptr, nCount);
    
    for (int i = 0; i < nCount; i++) {
        sum += va_arg(argptr, int);
    }
    va_end(argptr);

    return sum;
}
```
使用

```
    printf("MySum is %d\n", MySum(2, 0, 5, GUARDNUMBER));
    // 出错（计算结果不正确）
    printf("MySum is %d\n", MySum(GUARDNUMBER));
```
######二、字符

 http://blog.csdn.net/morewindows/article/details/6707662
 
```
 #define WriteLine (...) printf(__VA_ARGS__) + (putchar('\n') != EOF ? 1: 0);
 
 printf()的返回值是表示输出的字节数,这样就可以得到WriteLine宏的返回值了，它将返回输出的字节数，包括最后的’\n’.如下i和j都为12。
 
 int i = WriteLine("MoreWindows");
 WriteLine("%d", i);
 
 int j = printf("%s\n", "MoreWindows");
 WriteLine("%d", j);
```

自己实现WriteLine（返回输出的字节数，包括最后的’\n’）

```
int WriteLine(char *pszFormat, ...) {
    
    va_list   pArgList;

    va_start(pArgList, pszFormat);
    
    int nByteWrite = vfprintf(stdout, pszFormat, pArgList);
    
    if (nByteWrite != -1) {
        putchar('\n'); //注2
    }
    
    va_end(pArgList);
    
    return (nByteWrite == -1 ? -1 : nByteWrite + 1);
    
}
```
自己实现printf

```
int Printf(char *pszFormat, ...){
    
    va_list   pArgList;
    
    va_start(pArgList, pszFormat);

    int nByteWrite = vfprintf(stdout, pszFormat, pArgList);
    
    va_end(pArgList);
    
    return nByteWrite;
    
}
```
使用

```
printf("WriteLine %d\n", WriteLine("hello")); //print 'hello' and 'WriteLine 6'
    
Printf("wangliang %d\n", 1); //print 'wangliang 1'

```

摘抄：  
```
在<stdarg.h>中可以找到va_list的定义：

typedef char *  va_list;

再介绍与它关系密切的三个宏要介绍下：va_start()，va_end()和va_arg()。

同样在<stdarg.h>中可以找到这三个宏的定义：

#define va_start(ap,v)  ( ap = (va_list)&v + _INTSIZEOF(v) )

#define va_end(ap)      ( ap = (va_list)0 )

#define va_arg(ap,t)    ( *(t *)((ap += _INTSIZEOF(t)) - _INTSIZEOF(t)) )

其中用到的_INTSIZEOF宏定义如下：

#define _INTSIZEOF(n) ( (sizeof(n) + sizeof(int) - 1) & ~(sizeof(int) - 1) )

来分析这四个宏：

va_end(ap)这个最简单，就是将指针置成NULL。

va_start(ap,v)中ap = (va_list)&v + _INTSIZEOF(v)先是取v的地址，再加上_INTSIZEOF(v)。_INTSIZEOF(v)就有点小复杂了。( (sizeof(n) + sizeof(int) - 1) & ~(sizeof(int) - 1) )全是位操作，看起来有点麻烦，其实不然，非常简单的，就是取整到sizeof(int)。比如sizeof(int)为4，1,2,3,4就取4，5,6,7,8就取8。对x向n取整用C语言的算术表达就是((x+n-1)/n)*n，当n为2的幂时可以将最后二步运算换成位操作——将最低 n - 1个二进制位清 0就可以了。

va_arg(ap,t)就是从ap中取出类型为t的数据，并将指针相应后移。如va_arg(ap, int)就表示取出一个int数据并将指针向移四个字节。

因此在函数中先用va_start()得到变参的起始地址，再用va_arg()一个一个取值，最后再用va_end()收尾就可以解析可变参数了。

```




Cocos2d-x中的可变参数，比如：  
http://blog.csdn.net/cyistudio/article/details/8969081
```
CCMenu *menu = CCMenu::create(  
                  title1, title2,  
                  item1, item2,  
                  title3, title4,  
                  item3, item4,  
                  back, NULL ); // 9 items.  
//这里设定了个表格式的对齐格式分出了四行2列，最后一行1列，分别对应于上面menu中添加的切换按钮    
menu->alignItemsInColumns(2, 2, 2, 2, 1, NULL);  
```

alignItemsInColumns简化版：

```
void CCMenu::alignItemsInColumns(unsigned int columns, ...)
{
    va_list args;
    va_start(args, columns);
    
	CCArray* rows = CCArray::create();
    while (columns) {
    	rows->addObject(CCInteger::create(columns));
    	//以NULL作为结尾标志，将columns和可变参数加入到rows中
        std::cout << "columns " << columns << " \n";
        columns = va_arg(args, unsigned int);
    }
    
    va_end(args);
}
```

####C++打印指针地址
----
```
/**
 C++标准库中I/O类对<<操作符重载，因此在遇到字符型指针时会将其当作字符串名来处理，输出指针所指的字符串。既然这样，那么我们就别让它知道那是字符型指针，所以得用到强制类型转换，不过不是C的那套，我们得用static_cast来实现，把字符串指针转换成无类型指针，这样更规范.
 **/
void printAddressCpp() {
    
    const char *pszStr = "this is a string";
    // 输出字符串
    std::cout << "字符串：" << pszStr << std::endl;
    
    // 如我们所愿，输出地址值
    std::cout << "字符串起始地址值： " << static_cast<const void *>(pszStr) << std::endl;
    
    
    
    // C 的方式
    // 输出字符串
    printf("字符串：%s\n", pszStr);
    
    // 输出地址值
    printf("字符串起始地址值：%p\n", pszStr);
}
```

####可变参数2
http://www.vimer.cn/2010/03/cc%E5%AE%8F%E5%AE%9A%E4%B9%89%E7%9A%84%E5%8F%AF%E5%8F%98%E5%8F%82%E6%95%B0.html
---
```
   // 如果可变参数被忽略或为空，‘##’操作将使预处理器（preprocessor）去除掉它前面的那个逗号
   #define debug1(format, ...) fprintf(stderr, format, ##__VA_ARGS__)
   #define debug2(format, args...) fprintf(stderr, format, ##args)

    debug1("A message\n");
    debug1("A message->%d\n", 1);
    
    debug2("A message too");
    debug2("A message too->%d\n", 1);
```
另外一种方式

```
void myprintf(char* fmt, ...)
{
}

#ifdef RELEASE
#define printf(fmt, args...) myprintf(fmt, ##args)
#endif
```