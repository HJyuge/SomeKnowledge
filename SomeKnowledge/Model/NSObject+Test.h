//
//  NSObject+Test.h
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/3/28.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef IMP _Nullable *IMPPointer;

@interface NSObject (Test)

- (void)speak;
- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;

+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMPPointer _Nullable )store;

@end

NS_ASSUME_NONNULL_END
