//
//  NSObject+Test.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/3/28.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import "NSObject+Test.h"
#import <objc/runtime.h>

//https://www.jianshu.com/p/da010a008741
@implementation NSObject (Test)
- (void)speak {
    NSLog(@"NSObject+Test,speaknow.");
}

- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects {
//    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    if (signature == nil) {
           return nil;
    }
     //使用NSInvocation进行参数的封装
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    //减去 self _cmd
    NSInteger paramsCount = signature.numberOfArguments - 2;
    paramsCount = MIN(paramsCount, objects.count);
    for (int i = 0; i < paramsCount; i++) {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]]) continue;
        [invocation setArgument:&object atIndex:i+2];
    }
    // 调用方法
    [invocation invoke];
    // 获取返回值
    /**
     getReturnValue 内部生产的对象，它将自己管理其生命周期，而前面不加上述修饰符的话会导致该对象在方法结束前有编译器添加的release一次 导致过度释放。
     个人理解：根据c语言的取地址&获取值，getReturnValue函数结束后会释放临时变量。然后returnValue也是函数中的临时变量也会在作用域结束的时候释放。所以不加 __autoreleasing 会导致 returnValue的值被释放两次。
     */
    __autoreleasing id returnValue = nil;
    if (signature.methodReturnLength) { // 有返回值类型，才去获得返回值
        [invocation getReturnValue:&returnValue];
    }
    return  returnValue;
}

- (void)ObjcMsgSendWithString:(NSString *)string withNum:(NSNumber *)number withArray:(NSArray *)array {
    NSLog(@"%@, %@, %@", string, number, array[0]);
}


BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMPPointer store) {
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
}

+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMPPointer)store {
    return class_swizzleMethodAndStore(self, original, replacement, store);
}

@end
