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
//可以动态的提供一个方法的实现
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
//重定向接收者   替换消息接收者的机会
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
//    NSLog(@"anInvocation:%@",anInvocation);
    Student *student = [Student new];
    if ([student respondsToSelector:@selector(name)]){
        return [anInvocation invokeWithTarget:student];
    }
    return [super forwardInvocation:anInvocation];
    /**
     return value: {@} 0x0
     target: {@} 0x60000339afa0
     selector: {:} name
     */
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature){
//        signature = [[Student new] methodSignatureForSelector:aSelector];
        signature = [Student instanceMethodSignatureForSelector:aSelector];
    }
    NSLog(@"signature:%@",signature);
    return signature;
    /**
     number of arguments = 2
     frame size = 224
     is special struct return? NO
     return value: -------- -------- -------- --------
         type encoding (@) '@'
         flags {isObject}
         modifiers {}
         frame {offset = 0, offset adjust = 0, size = 8, size adjust = 0}
         memory {offset = 0, size = 8}
     argument 0: -------- -------- -------- --------
         type encoding (@) '@'
         flags {isObject}
         modifiers {}
         frame {offset = 0, offset adjust = 0, size = 8, size adjust = 0}
         memory {offset = 0, size = 8}
     argument 1: -------- -------- -------- --------
         type encoding (:) ':'
         flags {}
         modifiers {}
         frame {offset = 8, offset adjust = 0, size = 8, size adjust = 0}
         memory {offset = 0, size = 8}
     */
}

- (void)eatMeat:(NSString *)type{
    NSLog(@"%@ eat %@",[self class],type);
}

- (void)createPhone:(Block2)phone{
    if (phone) {
        NSLog(@"Person Phone block:%@",phone);
        phone(@"Apple");
        NSLog(@"After Invole Person Phone block:%@",phone);
    }
}
- (void)createPhone {
    if (self.block2){
        NSLog(@"xiao mi Phone block:%@",self.block2);
        self.block2(@"xiao mi phone");
        NSLog(@"After Invole xiaomi Phone block:%@",self.block2);
    }
}

@end
