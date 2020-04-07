//
//  HJProxy.h
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/4/7.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJProxy : NSProxy
@property (nonatomic, weak) id target;
+(instancetype) proxyWithTarget:(id) target;
@end

NS_ASSUME_NONNULL_END
