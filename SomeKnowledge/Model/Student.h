//
//  Student.h
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/3/27.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SubjectType) {
    SubjectChinese = 0,
    SubjectMath,
    SubjectEnglish,
    SubjectPhysics,
    SubjectChemistry,
};

@class Score;
@interface Student : Person
@property(nonatomic,copy)NSString *kname;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,assign)NSInteger grade;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *hobby;
@property(nonatomic,strong)Score *scores;
@property(nonatomic,copy)NSArray<Person *> *friends;//48 = 72

- (NSInteger)examSubject:(SubjectType)type;

- (void)run;
- (void)doHomeWork;

-(Student *)toModelWithDic:(NSDictionary *)dic;
@end


@interface Score : NSObject
@property (nonatomic,strong) NSNumber *chinese;
@property (nonatomic,strong) NSNumber *math;
@property (nonatomic,strong) NSNumber *english;
@property (nonatomic,strong) NSNumber *physics;
@property (nonatomic,strong) NSNumber *chemistry;
@end

NS_ASSUME_NONNULL_END
