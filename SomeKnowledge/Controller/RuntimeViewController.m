//
//  RuntimeViewController.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2019/9/29.
//  Copyright © 2019 HuangJin. All rights reserved.
//

#import "RuntimeViewController.h"
#import <objc/runtime.h>
#import "RuntimeTest.h"
#import "Student.h"
#import "Person.h"
#import "Person+Addtion.h"
#import "NSObject+Test.h"

@interface RuntimeViewController (){
 
}
@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self performSelector:@selector(testMethodResolve) withObject:nil afterDelay:1];
//    [self testMessageForwardingAndResolutionAndMetaClassCloseCycle];
//    [self testClassIsaMetaClass];
//    [self testMessageForwarding];
//    [self testClassAndInstanceProperty];
//    [self testCreateClassAndInstance];
    [self testPerformSelector];
}

- (void)dealloc {
    if (NSClassFromString(@"Women")){
        objc_disposeClassPair(NSClassFromString(@"Women"));
    }
}

- (void)testPerformSelector{
    Student  *stu = [Student new];
    //子线程中没有执行。performSelector内部的创建的timer是添加到当前线程的runloop中。runloop还没创建。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //必须放后面。
        [[NSRunLoop currentRunLoop] run];
        [stu performSelector:@selector(doHomeWork) withObject:nil afterDelay:1];
        [Student cancelPreviousPerformRequestsWithTarget:self selector:@selector(doHomeWork) object:nil];
        NSLog(@"current runloop:%@",[NSRunLoop currentRunLoop]);
    });
    
    
    //没生效
//    [stu performSelector:@selector(doHomeWork) withObject:nil afterDelay:2];
//    NSLog(@"current thread:%@",[NSThread currentThread]);
//    [Student cancelPreviousPerformRequestsWithTarget:self selector:@selector(doHomeWork) object:nil];
    
    
    
}

- (void)testCreateClassAndInstance{
    Class perClass = [Person class];
    //创建一个新类和元类
    Class womenCls = objc_allocateClassPair(perClass, "Women", 0);
    class_addIvar(womenCls, "children", sizeof(NSInteger), log(sizeof(NSInteger)), "l");
    objc_property_attribute_t type = {"T", "@\"NSString\""};//变量类型
    objc_property_attribute_t ownership = { "C", "" };// C = copy N = nonatomic
    objc_property_attribute_t backingivar = { "V", "_hair"};//实例名称
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    class_addProperty(womenCls, "hair", attrs, 3);
    //添加属性后，要手动添加实例和setter和getter方法。
    class_addIvar(womenCls, "_hair", sizeof(NSString *), log(sizeof(NSString *)), "i");
    
    class_addMethod(womenCls, @selector(chest), (IMP)imp_chest, "v@:");
    class_replaceMethod(womenCls, @selector(run), (IMP)imp_grow, "v@:");
    
    class_addMethod(womenCls, @selector(setHair:), (IMP)imp_setHair, "v@:@");
    class_addMethod(womenCls, @selector(hair), (IMP)imp_hair, "@@:");
    
    objc_registerClassPair(womenCls);//需要销毁。
    
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(womenCls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"womenCls ivar:%s",ivar_getName(ivar));
    }
    free(ivars);
    objc_property_t *properties = class_copyPropertyList(womenCls, &outCount);
    for (int i = 0 ; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"womenCls property:%s",property_getName(property));
    }
    free(properties);
    //方法操作
    Method *methods = class_copyMethodList(womenCls, &outCount);
    for (int i = 0; i < outCount; i++) {
         Method method = methods[i];
         NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    
    id instance = [[womenCls alloc] init];
    [instance performSelector:@selector(chest)];
    [instance performSelector:@selector(run)];
    
    [instance performSelector:@selector(setHair:) withObject:@"black"];
    NSLog(@"women hair:%@",[instance performSelector:@selector(hair)]);
    [instance performSelector:@selector(setHair:) withObject:@"red"];
    NSLog(@"women hair:%@",[instance performSelector:@selector(hair)]);
}

void imp_setHair(id self,SEL _cmd, NSString * newHair) {
    Class cls = NSClassFromString(@"Women");
    Ivar ivar = class_getInstanceVariable(cls, "_hair");
    id old = object_getIvar(self, ivar);
    if (old != newHair){
        object_setIvar(self, ivar, newHair);
    }
}

NSString *imp_hair(id self,SEL _cmd) {
    Ivar ivar = class_getInstanceVariable(NSClassFromString(@"Women"), "_hair");
    return object_getIvar(self, ivar);
}

void imp_grow() {
    NSLog(@"Women can grow");
}

void imp_chest() {
    NSLog(@"Women had chest");
}

- (void)testClassAndInstanceProperty{
    Student  *stu = [Student new];
//    NSLog(@"Student name:%@",stu.name);
    NSDictionary *stuDic = @{
        @"kname":@"张三",
        @"age":@15,
        @"grade":@9,
        @"address":@"天界仙人区蓬莱岛清风洞",
        @"hobby":@"睡觉",
        @"scores":@{
            @"chinese":@85,
            @"math":@95,
            @"english":@96,
            @"physics":@93,
            @"chemistry":@100
        },
        @"friends":@[
          @{@"nickname":@"小丽"},
          @{@"nickname":@"小航"},
          @{@"nickname":@"小于"},
          @{@"nickname":@"小结"},
        ]
    };
    [stu toModelWithDic:stuDic];
    Class stuCls = stu.class;
    Class perCls = [Person class];
    //类别
    NSLog(@"Student class_getName:%s",class_getName(stuCls));//Student
    NSLog(@"Student class_getSuperclass:%@",class_getSuperclass(stuCls));//Person
    NSLog(@"Person class_getSuperclass:%@",class_getSuperclass(perCls));//NSObject
    NSLog(@"Person class_isMetaClass:%d",class_isMetaClass(perCls));//0
    NSLog(@"Student class_getName:%s",class_getName(stuCls));//Student
    //实例大小
    NSLog(@"Person class_getInstanceSize:%zu",class_getInstanceSize(perCls));//24
    NSLog(@"Student class_getInstanceSize:%zu",class_getInstanceSize(stuCls));//90
    NSLog(@"Score class_getInstanceSize:%zu",class_getInstanceSize([Score class]));//48
    NSLog(@"NSInteger size:%lu",sizeof(NSInteger));
    NSLog(@"NSNumber size:%lu",class_getInstanceSize([NSNumber class]));
    NSLog(@"NSString class_getInstanceSize:%zu",class_getInstanceSize([NSString class]));//8
    NSLog(@"NSArray class_getInstanceSize:%zu",class_getInstanceSize([NSArray class]));//8
    /**
     一个NSObject只包含一个Class指针，在64位机器上，占据的空间大小应该是8个字节，其实质是成员变量占据的空间大小。
     那NSObject实例对象占据的空间是 16.空间大小至少是实例变量占据的空间，如果小于16字节，则还是会分配16字节
     对象占据空间是多大，实际需要考虑以下两个因素：
     1.结构体中成员变量的字节对齐
     2.苹果分配空间的原则，字节数是16的倍数，见libmalloc源码
     Person 为24 指针对象默认为8，加上isa指针. 占用大小为属性个数 * 8。但是@dynamic声明的对象不占空间大小。
     Student 为72 。除了本身的还要加上父类的指针数量。
     */
    
    NSLog(@"class_getVersion:%d",class_getVersion(stuCls));
    //成员变量
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(stuCls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
    }
    free(ivars);
    Ivar varKname = class_getInstanceVariable(stuCls, "_kname");
    if (varKname != NULL) {
        NSLog(@"class_getInstanceVariable:%s",ivar_getName(varKname));
    }
    
    //属性操作
   objc_property_t *properties = class_copyPropertyList(stuCls, &outCount);
    for (int i = 0; i < 0; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    free(properties);
    
    objc_property_t age = class_getProperty(stuCls, "age");
    if (age != NULL) {
        NSLog(@"property %s",property_getName(age));
    }
    
    //方法操作
    Method *methods = class_copyMethodList(stuCls, &outCount);
    for (int i = 0; i < outCount; i++) {
         Method method = methods[i];
         NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    
    Method method1 = class_getInstanceMethod(stuCls, @selector(run));
    if (method1 != NULL) {
         NSLog(@"method %s", method_getName(method1));
    }
    Method classMethod = class_getClassMethod(stuCls, @selector(speak));
    if (classMethod != NULL) {
         NSLog(@"class method : %s", method_getName(classMethod));
    }
    
    NSLog(@"Student is%@ responsd to selector: examSubject:", class_respondsToSelector(stuCls, @selector(examSubject:)) ? @"" : @" not");
    
    IMP imp = class_getMethodImplementation(stuCls, @selector(run));
    imp();
    
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(stuCls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
         protocol = protocols[i];
         NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(stuCls, protocol) ? @"" : @" not", protocol_getName(protocol));
    
}

- (void)testMessageForwardingAndResolutionAndMetaClassCloseCycle {
    Person *person = [Person new];
    [person run];
    [Person speak];
    [person speak];
    [person sleep];
    person.age = @10;
    NSLog(@"person age:%@",person.age);
    NSLog(@"person name:%@",person.name);
    NSLog(@"%@",[Person class]);
    NSLog(@"%@",[Student class]);
    [Student identifier];
}

- (void)testClassIsaMetaClass{
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL res3 = [(id)[Person class] isKindOfClass:[Person class]];
    BOOL res4 = [(id)[Person class] isMemberOfClass:[Person class]];
    NSLog(@"%d %d %d %d", res1, res2, res3, res4);
}

- (void)testMessageForwarding{
    //runtime实现动态添加属性
    RuntimeTest *test = [RuntimeTest new];
    [test test];
    NSLog(@"test imp:%p",[test methodForSelector:@selector(test)]);
    
}


#pragma mark - 消息动态解析
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    if (sel == @selector(testMethodResolve)) {
//        class_addMethod([self class], sel, (IMP)methodResolve, "v");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
//
//void methodResolve(id self, SEL _cmd){
//    NSLog(@"method resole success!");
//}

#pragma mark - 消息动态转发
//resolveInstanceMethod 需要返回YES
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//    return YES;
//}
//
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(testMethodResolve)) {
//        return [RuntimeTest new];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

#pragma mark - 完整的消息动态转发
//resolveInstanceMethod 需要返回YES
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    return YES;
}

//返回nil，进入下一步转发
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if (aSelector == @selector(testMethodResolve)){
//        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
//    return [super methodSignatureForSelector:aSelector];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        RuntimeTest *test = [RuntimeTest new];
        signature = [test methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    RuntimeTest *test = [RuntimeTest new];
    if ([test respondsToSelector:anInvocation.selector]){
        [anInvocation invokeWithTarget:test];
    }else {
        [self doesNotRecognizeSelector:anInvocation.selector];
    }
}

@end
