//
//  Teacher.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/4/2.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import "Teacher.h"

@implementation Teacher

//+(void)load {
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        SEL swizzleSelector = @selector(my_eatMeat:);
//        SEL origlnalSelector = @selector(eatMeat:);
//
//        Method swizzleMethod = class_getInstanceMethod(class, swizzleSelector);
//        Method origlnalMethod = class_getInstanceMethod(class, origlnalSelector);
//
//        BOOL addMethod = class_addMethod(class, swizzleSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
//
//        if (addMethod) {
//            class_replaceMethod(class, origlnalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
//        }else {
//            method_exchangeImplementations(origlnalMethod, swizzleMethod);
//        }
//    });
//}

- (void)my_eatMeat:(NSString *)type{
    NSLog(@"my_teacher eat %@",type);
}
@end
