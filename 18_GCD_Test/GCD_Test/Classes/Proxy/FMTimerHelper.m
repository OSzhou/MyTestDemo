//
//  FMTimerHelper.m
//  GCD_Test
//
//  Created by Smile on 2020/12/7.
//  Copyright © 2020 tataUFO. All rights reserved.
//

#import "FMTimerHelper.h"

@implementation FMTimerHelper

+ (instancetype)proxyWithTarget:(id)target
{
    FMTimerHelper *proxy = [[FMTimerHelper alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}

@end
