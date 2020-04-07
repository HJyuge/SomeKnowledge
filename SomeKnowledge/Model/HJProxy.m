//
//  HJProxy.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/4/7.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import "HJProxy.h"

@implementation HJProxy

+(instancetype) proxyWithTarget:(id) target {
    HJProxy *proxy = [HJProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

-(void)forwardInvocation:(NSInvocation *)invocation {
    return [invocation invokeWithTarget:self.target];
}

@end
