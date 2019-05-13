//
//  FMProxy.m
//  15_interviewQ
//
//  Created by Zhouheng on 2019/5/13.
//  Copyright © 2019年 Windy. All rights reserved.
//

#import "FMProxy.h"

@interface FMProxy()

@property (nonatomic ,weak)id target;

@end

@implementation FMProxy

+ (instancetype)proxyWithTarget:(id)target {
    //NSProxy实例方法为alloc
    FMProxy *proxy = [FMProxy alloc];
    proxy.target = target;
    return proxy;
}

/**
 这个函数让重载方有机会抛出一个函数的签名，再由后面的forwardInvocation:去执行
 为给定消息提供参数类型信息
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

/**
 *  NSInvocation封装了NSMethodSignature，通过invokeWithTarget方法将消息转发给其他对象。这里转发给控制器执行。
 */
- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
