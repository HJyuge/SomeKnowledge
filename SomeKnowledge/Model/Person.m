//
//  Person.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/3/27.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Student.h"
@interface Person ()

@end


@implementation Person
@dynamic name;
+ (void)identifier{
    NSLog(@"Identifier is Person.");
}



- (void)run {
    NSLog(@"Person can is running");
}

- (void)sleep {
    NSLog(@"Person can is sleeping");
}

//============动态方法解析 1=============
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(name)){
////        IMP imp = class_getMethodImplementation([self class], @selector(personName));
//        class_addMethod([self class], sel,(IMP)dynamicName , "#@:");
//        return YES;
//    }
//    return  [super resolveInstanceMethod:sel];
//}

NSString * dynamicName(id self,SEL _cmd){
//    char *name = "dynamic name is ***";
    return @"dynamic name is ***";
}

- (NSString *)personName{
    NSLog(@"My name is xxxx");
    return @"My name is xxxx";
}
//============动态方法解析 2=============
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    return NO;
}
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(name)){
//        return [Student new];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

//==========消息转发=========
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([[Student new] respondsToSelector:@selector(name)]){
        return [anInvocation invokeWithTarget:[Student  new]];
    }
    return [super forwardInvocation:anInvocation];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature){
        signature = [[Student new] methodSignatureForSelector:aSelector];
    }
    return signature;
}


@end