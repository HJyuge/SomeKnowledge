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

+ (void)load {
    Method firstMethod = class_getInstanceMethod([self class], @selector(run));
    Method secondMethod = class_getInstanceMethod([self class], @selector(sleep));
    method_exchangeImplementations(firstMethod, secondMethod);
}

-(void)setAge:(NSNumber *)age {
    objc_setAssociatedObject(self, ageKey, age, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)age {
    return objc_getAssociatedObject(self, ageKey);
}

@end
