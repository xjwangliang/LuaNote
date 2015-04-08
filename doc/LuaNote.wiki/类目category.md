####类目Category

####延展Extension

####协议Protocol

#####代理Proxy



####1.点语法
---
隐藏多线程、同步、加锁细节
隐藏内存管理细节

```
@interface Person : NSObject
{
	_age;
}
//getter和setter
@end
```
调用，点语法其实是调用方法

```
person.age = 10;
[person setAge:10]

int age = person.age;
int age = [person age]

-(void)setAge:(int) newAge {
	//错误调用
	//self.age = age
	age = newAge;
}
```
####2.构造方法(new 方法等价于 [ [MyClass alloc] init] )
---
-(id) initWithName:(NSString *)name: andAge:(int) age
{
	if(self = [super init])
	{
		_name = name;//self.name = name;
		_age = age;	//self.age = age;
		
	}
	return self;
}

[[Person alloc] initWithName:@“wang” andAge:20];
//注意与NSString stringWithFormat的区别



3.self
静态方法self表示类（比如[self alloc] 等价于[MyClass alloc]），动态方法self表示当前对象

+(id) create{
    //Person *p = [[Person alloc] init]
    //子类调用出错，所以用self，self指向实际类
    Person *p = [[self alloc] init]
    [p autorelease];//
    return p;

}



4.allloc/retain/release/autorelease

alloc/new/copy，计数器值是1
回调dealloc，做释放资源的操作
retain/release分别增加和减少引用计数,retain和release需要成对出现。
retainCount

谁创建谁释放:alloc/new/copy创建一个对象必须release或者autorelease
谁retain谁release，只要你调用了retain，不管对象是由谁创建的，必须release
一般来说，除了alloc/new/copy创建的对象一般都实现了autorelease（比如[NSString initWIthFormat]）
NSSlog(@“%zi”,obg.retainCount);


-(void)setBook:(Book*) book
{
	if(_book != book)
	{
		[_book release];
		_book = [book retain];
	}
}

-(void) dealloc
{
	[_book release];
	//等价self.book = nil;
	[super dealloc];
}

Book *book = [[Book alloc]init];
[person setBook:book];//等价person.book = book;
[book release];

野指针 再进行操作release/retain会报错
空指针 不会[nil release]不会报错


5.@class Book,不必要引入import，在h文件中声明某个类作为变量，并不一定使用其中的方法和变量。如果在m文件中使用某个对象，此时就可以import进来

循环包含（A中包含B，B中包含A），import编译会报错，这样需要使用@class,表示一个类而已，并不需要导入整个类中的所有代码。


6.
@property (retain) Book *book;
表示release old，retain new，实际上编译器会生成类似上面的setter方法

readonly(只生成getter方法) readwrite(默认)
assign retain copy
nonatomic atomicity

(getter=getterMethodName, setter=setterMethodName)




7.property和synthesize

【一】
Student.h
--------------------------------------------
@interface Student : NSObject {
	int number;
}

//生成getter和setter声明
@property int number
// -(void) setNumber:(int) newNumber;
//- (int) number;

@end
--------------------------------------------


--------------------------------------------
@implementation Student

//实际上编译器如果找不到这个变量，会生成一个同名变量（但是变量类型呢）
@synthesize number;
// -(void) setNumber:(int) newNumber
//{
//	number = newNumber;
//}

//- (int) number
//{
//	return number;
//}

@end
--------------------------------------------



【二】
--------------------------------------------
@interface Student : NSObject {
int _number;
}

//生成getter和setter声明
@property int number;

@end
--------------------------------------------


--------------------------------------------
@implementation Student

//实际上编译器如果找不到这个变量，会生成一个同名变量（但是变量类型呢）
//这样就不会生成number，getter和setter使用_number
@synthesize number = _number;
@end
————————————————

【三】
高版本Xcode，只需要@property 即可，可以省略@ synthesize
--------------------------------------------
@interface Student : NSObject

//生成getter和setter声明，并且生成_number变量（如果自己声明过_number，则就不会生成）
@property int number;

@end
—————————————————————


autorelesse

@autoreleasepool{
    Person *p = [Person create];

    Person *p2 = [[Person alloc]init];
    [p2 autorelease];

}

####8.Block:
-----
```
typedef int (^MySum) (int,int)

void test()
{
	int (^Sum) (int,int)= ^(int a,int b)
	{
		return a+b;
	}
	int s = Sum(30,19);
	__block int localVar = 10;
	MySum sum = ^(int a,int b)
	{
		localVar = 20;
		return a+b;
	}
	int s2 = sum(3,19);
}
```

————————————————————————
Block例子

#import <Foundation/Foundation.h>

@class Button;

typedef void (^ButtonBlock) (Button *);

@interface Button : NSObject

@property (nonatomic, assign) ButtonBlock block;

// 模拟按钮点击
- (void)click;

@end

————————————————————————
#import "Button.h"

@implementation Button
- (void)click {
    _block(self);
}
@end
————————————————————————
int main(int argc, const char * argv[])
{

    @autoreleasepool {
        Button *btn = [[[Button alloc] init] autorelease];
        
        btn.block = ^(Button *btn) {
            NSLog(@"按钮-%@被点击了", btn);
        };
        
        // 模拟按钮点击
        [btn click];
    }
    return 0;
}
————————————————————

Block补充

#import <Foundation/Foundation.h>

int sum(int a, int b) {
    return a + b;
}

void test() {
    int (^Sum) (int, int) = ^(int a, int b) {
        return a + b;
    };
    
    // block
    int c = Sum(10, 9);
    NSLog(@"%i", c);
    
    // 函数
    c = sum(10, 10);
    NSLog(@"%i", c);
    
    int (*sump) (int, int) = sum;
    c = (*sump)(9, 9);
    NSLog(@"%i", c);
}

typedef char * String;

void test1() {
    // 定义了Sum这种Block类型
    typedef int (^Sum) (int, int);
    
    // 定义了sump这种指针类型，这种指针是指向函数的
    typedef int (*Sump) (int, int);
    
    // 定义了一个block变量
    Sum sum1 = ^(int a, int b) {
        return a + b;
    };
    
    int c = sum1(10, 10);
    NSLog(@"%i", c);
    
    // 定义一个指针变量p指向sum函数
    Sump p = sum;
    // c = (*p)(9, 8);
    c = p(9, 8);
    NSLog(@"%i", c);
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        test1();
    }
    return 0;
}
————————————————————

```
 void (*funcPtr)() = test;
 funcPtr();
```

9.Protocol

————————————————————
#import <Foundation/Foundation.h>

@protocol Study <NSObject>
// 默认就是@required
- (void)test3;

// @required表示必须实现的方法
// 虽然字面上说是必须实现，但是编译器并不强求某个类进行实现
@required
- (void)test;

- (void)test1;

// @optional表示可选（可实现\也可不实现）
@optional
- (void)test2;
@end
————————————————————
#import <Foundation/Foundation.h>
@protocol Study, Learn;

@interface Student : NSObject <Study, Learn>

@end

————————————————————
#import "Student.h"
#import “Study.h” //必须导入，否则报错unrecognized symbol
#import "Learn.h"

@implementation Student

@end
————————————————————

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        Student *stu = [[[Student alloc] init] autorelease];
        
        // 注意：OC是弱语法的，对类型要求不严格
        // NSString *stu = [[[Student alloc] init] autorelease];
        // [stu stringByAbbreviatingWithTildeInPath];
        
        // conformsToProtocol:判断是否遵守了某个协议
        if ([stu conformsToProtocol:@protocol(Study)]) {
            NSLog(@"Student遵守了Study这个协议");
        }
        
        // respondsToSelector:判断是否实现了某个方法
        if ( ![stu respondsToSelector:@selector(test)] ) {
            NSLog(@"Student没有实现test这个方法");
        }
    }
    return 0;
}
————————————————————