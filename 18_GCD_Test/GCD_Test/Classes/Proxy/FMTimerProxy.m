//
//  FMTimerProxy.m
//  GCD_Test
//
//  Created by Smile on 2020/12/7.
//  Copyright © 2020 tataUFO. All rights reserved.
//

#import "FMTimerProxy.h"

@implementation FMTimerProxy

+ (instancetype)proxyWithTarget:(id)target
{
    // NSProxy对象不需要调用init，因为它本来就没有init方法
    FMTimerProxy *proxy = [FMTimerProxy alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}

@end
