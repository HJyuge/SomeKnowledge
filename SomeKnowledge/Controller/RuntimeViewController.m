//
//  RuntimeViewController.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2019/9/29.
//  Copyright © 2019 HuangJin. All rights reserved.
//

#import "RuntimeViewController.h"
#import "RuntimeTest.h"
#import "Student.h"
#import "Person.h"
#import "Person+Addtion.h"
#import "NSObject+Test.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "Worker.h"
#import "Teacher.h"

// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5         runtime

// http://www.starming.com/2015/04/01/objc-runtime/         runtime

//https://www.jianshu.com/p/d260d18dd551        runloop
// https://blog.ibireme.com/2015/05/18/runloop/         runloop


static void *kDTActionHandlerTapGestureKey = &kDTActionHandlerTapGestureKey;
static void *kDTActionHandlerTapBlockKey = &kDTActionHandlerTapBlockKey;
@interface RuntimeViewController (){
 
}
@end

@implementation RuntimeViewController
- (void)dealloc {
    if (NSClassFromString(@"Women")){
        objc_disposeClassPair(NSClassFromString(@"Women"));
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self performSelector:@selector(testMethodResolve) withObject:nil afterDelay:1];
    [self testMessageForwardingAndResolutionAndMetaClassCloseCycle];
//    [self testClassIsaMetaClass];
//    [self testMessageForwarding];
//    [self testClassAndInstanceProperty];
//    [self testCreateClassAndInstance];
//    [self testPerformSelector];
//    [self testInstanceOperation];
//    [self testVariableAndProperty];
//    [self testAssociatedObject:^{
//        NSLog(@"Associate tap gesture success.And User Tap callback.");
//    }];
//    [self testDicToModel];
    [self testMethodSwizzling];
    
//    [self testMethodSwizzling2];
}

- (void)testMethodSwizzling2 {
    Teacher *teacher = [Teacher new];
    [teacher eatMeat:@"cow"];
    Worker *worker = [Worker new];
    [worker eatMeat:@"pig"];
}

- (void)testMethodSwizzling {
    Person *per = [Person new];
    [per sleep];
    [per run];
}

- (void)testDicToModel {
    Student  *stu = [Student new];
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
    NSLog(@"student kname:%@,age:%ld,grade:%ld,address:%@,hobby:%@",stu.kname,(long)stu.age,(long)stu.grade,stu.address,stu.hobby);
    NSLog(@"student scores:%@,friends:%@",stu.scores,stu.friends);
}

- (void)testAssociatedObject:(void(^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, kDTActionHandlerTapGestureKey);
    if (!gesture){
        gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self.view addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

//手势识别对象的target和action
- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, kDTActionHandlerTapBlockKey);
        if (action){
            action();
        }
    }
}

- (void)testVariableAndProperty {
    //获取属性列表
    id StudentClass = objc_getClass("Student");
    unsigned int outCount, i;;
    objc_property_t *properties = class_copyPropertyList(StudentClass, &outCount);
    //查找属性名称
    /*  const char *property_getName(objc_property_t property); */
    
    //通过给出的名称来在类和协议中获取属性的引用
    /* objc_property_t class_getProperty(Class cls, const char *name);
    objc_property_t protocol_getProperty(Protocol *proto, const char *name, BOOL isRequiredProperty, BOOL isInstanceProperty); */
    
    //发掘属性名称和@encode类型字符串
    /*  const char *property_getAttributes(objc_property_t property); */
    
    //从一个类中获取它的属性
    properties = class_copyPropertyList(StudentClass, &outCount);
    for (i = 0; i < outCount; i++) {
         objc_property_t property = properties[i];
         fprintf(stdout, "%s %s\n", property_getName(property), property_getAttributes(property));
    }
}

- (void)testInstanceOperation {
    //MRR 下运行
//    NSObject *obj = [[NSObject alloc] init];
//    id newObjc = object_copy(obj, class_getInstanceSize(Student.class));
//    object_setClass(newObjc, Student.class);
//    object_dispose(obj);
    
//    int numClasses;
//    Class * classes = NULL;
//    numClasses = objc_getClassList(NULL, 0);
//    if (numClasses > 0) {
//         classes = malloc(sizeof(Class) * numClasses);
//         numClasses = objc_getClassList(classes, numClasses);
//         NSLog(@"number of classes: %d", numClasses);
//         for (int i = 0; i < numClasses; i++) {
//              Class cls = classes[i];
//              NSLog(@"class name: %s", class_getName(cls));
//         }
//         free(classes);
//    }
    
    unsigned int numberOfIvars = 0;
    Ivar *ivars = class_copyIvarList([Student class], &numberOfIvars);
    for (int i = 0; i < numberOfIvars; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"ivar address = %p",ivar);
//        NSLog(@"=====Student ivar:%s and offset:%td",ivar_getName(ivar),ivar_getOffset(ivar));
    }
    /*
     =====Student ivar:_kname and offset:24     0x1025e34b0
     =====Student ivar:_age and offset:32       0x1025e34d0
     =====Student ivar:_grade and offset:40     0x1025e34f0
     =====Student ivar:_address and offset:48   0x1025e3510
     =====Student ivar:_hobby and offset:56     0x1025e3530
     =====Student ivar:_scores and offset:64    0x1025e3550
     =====Student ivar:_friends and offset:72   0x1025e3570
     */
    
    for (Ivar *p = ivars; p< ivars + numberOfIvars; p++) {
        Ivar ivar = *p;
        NSLog(@"ivar address = %p",ivar);
//        ptrdiff_t offset = ivar_getOffset(ivar);
//        const char *name = ivar_getName(ivar);
//        NSLog(@"*****Student ivar name = %s, offset = %td", name, offset);
    }
    /*
    *****Student ivar name = _kname, offset = 24
    *****Student ivar name = _age, offset = 32
    *****Student ivar name = _grade, offset = 40
    *****Student ivar name = _address, offset = 48
    *****Student ivar name = _hobby, offset = 56
    *****Student ivar name = _scores, offset = 64
    *****Student ivar name = _friends, offset = 72
    */
}

- (void)testPerformSelector{
    
    // testPerformSelector
    Student  *stu = [Student new];
    //子线程中没有执行。performSelector内部的创建的timer是添加到当前线程的runloop中。runloop还没创建。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [stu performSelector:@selector(doHomeWork) withObject:nil afterDelay:1];
        //必须放后面。启动runloop需要事件或定时器
        [[NSRunLoop currentRunLoop] run];
    });
    
//    [stu performSelector:@selector(doHomeWork) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
    
    //取消待执行的方法
//    [stu performSelector:@selector(doHomeWork) withObject:nil afterDelay:2];
//    [Student cancelPreviousPerformRequestsWithTarget:stu selector:@selector(doHomeWork) object:nil];
    
    //NSInvocation
    [stu performSelector:@selector(wantToPlay:sing:eat:drink:) withObjects:@[@"basketball",@"SpeakNow",@"chicken",@"juice"]];
    
    //objc_msgSend
    ((void(*)(id,SEL,NSString *,NSString *,NSString *,NSString *))objc_msgSend)(stu,@selector(wantToPlay:sing:eat:drink:),@"basketball",@"SpeakNow",@"chicken",@"juice");
}

- (void)testCreateClassAndInstance{
    Class perClass = [Person class];
    //创建一个women新类和元类
    Class womenCls = objc_allocateClassPair(perClass, "Women", 0);
    //添加一个childrens变量
    class_addIvar(womenCls, "children", sizeof(NSInteger), log(sizeof(NSInteger)), "l");
    //添加一个hair属性
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
    
    //在应用中注册由objc_allocateClassPair创建的类
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
    
    //创建对象
    //可以看出class_createInstance和alloc的不同
    id theObject = class_createInstance(NSString.class, sizeof(unsigned));
    id str1 = [theObject init];
    NSLog(@"%@", [str1 class]);
    id str2 = [[NSString alloc] initWithString:@"test"];
    NSLog(@"%@", [str2 class]);
    
    
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
