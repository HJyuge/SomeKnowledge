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

@interface RuntimeViewController ()

@end

@implementation RuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(testMethodResolve) withObject:nil afterDelay:1];
    
    //runtime实现动态添加属性
    RuntimeTest *test = [RuntimeTest new];
    [test test];
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
