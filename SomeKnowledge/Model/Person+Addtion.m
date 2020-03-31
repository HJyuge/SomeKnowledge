//
//  Person+Addtion.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/3/28.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import "Person+Addtion.h"
#import <objc/runtime.h>
const void *ageKey = &ageKey;


@implementation Person (Addtion)
 // https://stackoverflow.com/questions/5339276/what-are-the-dangers-of-method-swizzling-in-objective-c
/*
 1.方法交换不是原子的
    在主线程中(串行)中在+load的方法中进行方法交换是没问题的。在+initialize里进行方法交换会导致交换的方法陷入死循环。
 2.命名冲突
 3.改变代码的行为
 4.交换改变方法参数
 5.代码难以理解
 6.难以调试
 
 */
+ (void)load {
   static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSEL = @selector(run);
        SEL swizzledSEL = @selector(sleep);
        Class class = [self class];
        Method originalMethod = class_getInstanceMethod(class, originalSEL);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    //确保要交换的方法存在，就先用class_addMethod和class_replaceMethod函数添加和替换两个方法实现。但如果已经有了要替换的方法，就调用method_exchangeImplementations函数交换两个方法的Implementation。
        BOOL didAddMethod = class_addMethod(class, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if(didAddMethod) {
            class_replaceMethod(class, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

-(void)setAge:(NSNumber *)age {
    objc_setAssociatedObject(self, ageKey, age, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)age {
    return objc_getAssociatedObject(self, ageKey);
}

@end
