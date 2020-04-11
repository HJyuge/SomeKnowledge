//
//  GCDViewController.m
//  SomeKnowledge
//
//  Created by SpeakNow on 2020/4/7.
//  Copyright © 2020 HuangJin. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/*
GCD） 是 Apple 开发的一个多核编程的较新的解决方法。它主要用于优化应用程序以支持多核处理器以及其他对称多处理系统。
 GCD 可用于多核的并行运算；
 GCD 会自动利用更多的 CPU 内核（比如双核、四核）；
 GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）；
 程序员只需要告诉 GCD 想要执行什么任务，不需要编写任何线程管理代码。
 
 执行任务有两种方式：『同步执行』 和 『异步执行』。两者的主要区别是：是否等待队列的任务执行结束，以及是否具备开启新线程的能力。
 
 同步执行（sync）：
 同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。
 只能在当前线程中执行任务，不具备开启新线程的能力。


 异步执行（async）：
 异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。
 可以在新的线程中执行任务，具备开启新线程的能力。

 GCD 中有两种队列：『串行队列』 和 『并发队列』。两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。
 串行队列（Serial Dispatch Queue）：
 每次只有一个任务被执行。让任务一个接着一个地执行。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）
 
 并发队列（Concurrent Dispatch Queue）：
 可以让多个任务并发（同时）执行。（可以开启多个线程，并且同时执行任务）
 
 并发队列 的并发功能只有在异步（dispatch_async）方法下才有效。
*/

@end
