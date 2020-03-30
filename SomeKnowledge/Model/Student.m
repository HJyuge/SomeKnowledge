//
//  Student.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/3/27.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import "Student.h"

@implementation Student
//@dynamic name;

- (void)doHomeWork {
    NSLog(@"Student do home work.");
}
-(NSString *)name{
    return @"Student xiaoming";
}

- (NSInteger)examSubject:(SubjectType)type {
    NSInteger score = 0;
    switch (type) {
        case SubjectChinese:
            score = 85;
            break;
        case SubjectMath:
            score = 98;
            break;
        case SubjectPhysics:
            score = 95;
            break;
        case SubjectChemistry:
            score = 96;
            break;
        case SubjectEnglish:
            score = 94;
            break;
        default:
            break;
    }
    return score;
}

- (Student *)toModelWithDic:(NSDictionary *)dic {
    Student *stu = [Student new];
    stu.kname = dic[@"kname"];
    stu.age = [dic[@"age"] integerValue];
    stu.address = dic[@"address"];
    stu.grade = [dic[@"grade"] integerValue];
    stu.hobby = dic[@"hobby"];
    NSDictionary *scores = dic[@"scores"];
    NSArray *friends = dic[@"friends"];
    Score *score = [Score new];
    score.chinese = scores[@"chinese"];
    score.math = scores[@"math"];
    score.english = scores[@"english"];
    score.physics = scores[@"physics"];
    score.chemistry = scores[@"chemistry"];
    stu.scores = score;
    NSMutableArray *scoresArr = [@[] mutableCopy];
    for (NSDictionary *dic in friends) {
        Person *person = [Person new];
        person.nickname = dic[@"nickname"];
        [scoresArr addObject:person];
    }
    stu.friends = scoresArr;
    return stu;
}

@end


@implementation Score


@end
