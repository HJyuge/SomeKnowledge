//
//  RuntimeTest.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2019/9/29.
//  Copyright © 2019 HuangJin. All rights reserved.
//

#import "RuntimeTest.h"
#import <objc/runtime.h>

static const char *key = "name";

@implementation RuntimeTest

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(test);
        SEL swizzledSelector = @selector(methodChange);
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        //方法替换
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    });
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)methodChange{
    NSLog(@"method had to be change.");
}

- (void)test {
    self.name = @"This is a test name.";
    NSLog(@"%@", self.name);
}

- (void)setName:(NSString *)name{
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, key);
}

//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//
//}

- (void)testMethodResolve {
    NSLog(@"Message relove , forwarding to RuntimeTest!");
}
@end
