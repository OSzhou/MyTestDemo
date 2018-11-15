//
//  ViewController.m
//  11_图片批量上传
//
//  Created by Windy on 2017/5/24.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "ViewController.h"
/****************************************子线程通知处理*************************************/
@interface ViewController () <NSMachPortDelegate>

@property (nonatomic) NSMutableArray    *notifications;         // 通知队列
@property (nonatomic) NSThread          *notificationThread;    // 期望线程
@property (nonatomic) NSLock            *notificationLock;      // 用于对通知队列加锁的锁对象，避免线程冲突
@property (nonatomic) NSMachPort        *notificationPort;      // 用于向期望线程发送信号的通信端口

@end

static NSString *TEST_NOTIFICATION = @"TEST_NOTIFICATION";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self semaphoreTest1];
    [self semaphoreTest2];
}

- (void)semaphoreTest2 {
    //使用GCD的信号量 dispatch_semaphore_t 创建同步请求
    dispatch_group_t group =dispatch_group_create();
    dispatch_queue_t globalQueue=dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        dispatch_semaphore_t semaphore= dispatch_semaphore_create(0);
        //模拟网络多线程耗时操作
        dispatch_group_async(group, globalQueue, ^{
            sleep(3);
            NSLog(@"%@---block1结束。。。",[NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
        NSLog(@"%@---1结束。。。",[NSThread currentThread]);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"走着了");
    });
    dispatch_group_async(group, globalQueue, ^{
        dispatch_semaphore_t semaphore= dispatch_semaphore_create(0);
        
        //模拟网络多线程耗时操作
        dispatch_group_async(group, globalQueue, ^{
            sleep(3);
            NSLog(@"%@---block2结束。。。",[NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
        
        NSLog(@"%@---2结束。。。",[NSThread currentThread]);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@---全部结束。。。",[NSThread currentThread]);
        
    });
}

- (void)semaphoreTest1 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {
        dispatch_group_async(group, queue, ^{
            NSLog(@" ---> %i",i);
            sleep(2);
            dispatch_semaphore_signal(semaphore);
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    dispatch_release(group);
//    dispatch_release(semaphore);
    NSLog(@" ---> 完成！！！");
}

- (void)threadMsgTest {
    NSLog(@"current thread = %@", [NSThread currentThread]);
    
    // 初始化
    self.notifications = [[NSMutableArray alloc] init];
    self.notificationLock = [[NSLock alloc] init];
    
    self.notificationThread = [NSThread currentThread];
    self.notificationPort = [[NSMachPort alloc] init];
    self.notificationPort.delegate = self;
    
    // 往当前线程的run loop添加端口源
    // 当Mach消息到达而接收线程的run loop没有运行时，则内核会保存这条消息，直到下一次进入run loop
    [[NSRunLoop currentRunLoop] addPort:self.notificationPort
                                forMode:(__bridge NSString *)kCFRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNotification:) name:@"TestNotification" object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TEST_NOTIFICATION object:nil userInfo:nil];
        
    });
}

- (void)handleMachMessage:(void *)msg {
    
    [self.notificationLock lock];
    
    while ([self.notifications count]) {
        NSNotification *notification = [self.notifications objectAtIndex:0];
        [self.notifications removeObjectAtIndex:0];
        [self.notificationLock unlock];
        [self processNotification:notification];
        [self.notificationLock lock];
    };
    
    [self.notificationLock unlock];
}

- (void)processNotification:(NSNotification *)notification {
    
    if ([NSThread currentThread] != _notificationThread) {
        // Forward the notification to the correct thread.
        [self.notificationLock lock];
        [self.notifications addObject:notification];
        [self.notificationLock unlock];
        [self.notificationPort sendBeforeDate:[NSDate date]
                                   components:nil
                                         from:nil
                                     reserved:0];
    }
    else {
        // Process the notification here;
        NSLog(@"current thread = %@", [NSThread currentThread]);
        NSLog(@"process notification");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
