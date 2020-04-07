//
//  FMDBViewController.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/4/7.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import "FMDBViewController.h"
#import "YTKKeyValueStore.h"

@interface FMDBViewController (){
    dispatch_semaphore_t _semaphore;
     pthread_mutex_t _lockmutex;
}
@property (nonatomic, strong) YTKKeyValueStore *store;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSLock *lock;

@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLock *lock = [[NSLock alloc] init];
    _lock = lock;
    _semaphore = dispatch_semaphore_create(1);
    
    /**
     第一种crash EXC_BAD_ACCESS
     ERROR, table: Table01 not exists in current DB
     ERROR, failed to create table: Table01
     
     场景:第一次初始化数据库的时候，使用多线程开启用一个数据库
     */
    
    /**
    第二种crash EXC_BAD_ACCESS
    
    场景:数据库存在后，使用多线程重复开启数据库
    */
    
    /**
    第三种crash EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
    
    场景:数据库存在后，使用多线程重复开启数据库
    */
    
    //不会crash
//    __weak typeof(self) weakSelf = self;
//    if (@available(iOS 10.0, *)) {
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            [weakSelf initDBAndTable];
//        }];
//    } else {
//
//    }
    
    
//    [self initDBAndTable];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initDBAndTable];
    });
    
}

- (void)initDBAndTable {
//    [_lock lock];
//    [_lock unlock];
    
//    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
//    dispatch_semaphore_signal(_semaphore);
    
//    [_lock lock];
    self.store = [[YTKKeyValueStore alloc] initDBWithName:@"Test01"];
    [_store createTableWithName:@"Table01"];
    NSLog(@"this method invoked at %f",[[NSDate date]timeIntervalSince1970]);
//    [_lock unlock];
}
@end
