//
//  Person.h
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/3/27.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Test.h"
#import <objc/runtime.h>
NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * nickname;
@property(nonatomic,strong)NSNumber* height;
+ (void)identifier;

+(void)speak;
- (void)run;
- (void)sleep;
- (void)eatMeat:(NSString *)type;
@end


NS_ASSUME_NONNULL_END
