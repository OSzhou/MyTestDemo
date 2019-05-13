//
//  FMProxy_nsobject.m
//  15_interviewQ
//
//  Created by Zhouheng on 2019/5/13.
//  Copyright © 2019年 Windy. All rights reserved.
//

#import "FMProxy_nsobject.h"

@interface FMProxy_nsobject()

@property (nonatomic ,weak) id target;

@end

@implementation FMProxy_nsobject

+(instancetype)proxyWithTarget:(id)target
{
    FMProxy_nsobject *proxy = [[FMProxy_nsobject alloc] init];
    proxy.target = target;
    return proxy;
}

//仅仅添加了weak类型的属性还不够，为了保证中间件能够响应外部self的事件，需要通过消息转发机制，让实际的响应target还是外部self，这一步至关重要，主要涉及到runtime的消息机制。
-(id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}

@end
