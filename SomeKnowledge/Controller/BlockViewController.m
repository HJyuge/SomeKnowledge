//
//  BlockViewController.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/4/11.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import "BlockViewController.h"
#import "Person.h"
static NSString *company = @"反倒是开发";
@interface BlockViewController ()
@property (nonatomic,strong)NSString *name;
@property (nonatomic, strong) Person *person;

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test];
}

- (void)test {
    /*
     没有引用变量的时候是全局block __NSGlobalBlock__  被调用后也是全局block
     引用局部变量是堆block
     */
    self.name = @"张三";
    NSString *address = @"发动机看风景斯柯达";
    void(^stackBlock)(void) = ^(){
        NSLog(@"I am stackBlock");
        NSLog(@"address:%@",address);
//        NSLog(@"company:%@",company);
    };
    NSLog(@"stackBlock:%@",stackBlock);
    stackBlock();
    NSLog(@"after invoke stackBlock:%@",stackBlock);
    
    /*
    引用变量的时候是堆block __NSMallocBlock__
    */
    __weak typeof(self) weakSelf = self;
    void(^mallcBlock)(void) = ^(){
        NSLog(@"I am mallcBlock and property name:%@",weakSelf.name);
    };
    NSLog(@"mallcBlock:%@",mallcBlock);
    
    [self testBlcokType:^{
        NSLog(@"testBlcokType method call back");
    }];
    
    [self test2BlcokType:^(NSString *name) {
        NSLog(@"testBlcokType method call back name:%@",name);
    }];
    
    Person *person = [Person new];
    self.person = person;
    [self.person createPhone:^(NSString * _Nonnull type) {
        NSLog(@"%@ is a phone",type);
    }];
    
    
    [self.person setBlock2:^(NSString * _Nonnull name) {
        NSLog(@"%@",name);
    }];
    [self.person createPhone];
}

// __NSGlobalBlock__
- (void)testBlcokType:(void(^)(void))type{
    if (type){
        NSLog(@"method testblcokType black:%@",type);
        type();
        NSLog(@"after invoke method testblcokType black:%@",type);
    }
}
/*
 返回局部还是全局都是 __NSGlobalBlock__
 */

- (void)test2BlcokType:(void(^)(NSString * name))type{
    if (type){
        NSLog(@"method test2blcokType black:%@",type);
        type(self.name);
        NSLog(@"after invoke method test2blcokType black:%@",type);
    }
}

@end
