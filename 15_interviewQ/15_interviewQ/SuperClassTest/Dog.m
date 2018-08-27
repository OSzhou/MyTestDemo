//
//  Dog.m
//  15_interviewQ
//
//  Created by Smile on 2018/8/27.
//  Copyright © 2018 Windy. All rights reserved.
//

#import "Dog.h"

@implementation Dog

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"111 --- %@", NSStringFromClass([self class]));
        NSLog(@"222 --- %@", NSStringFromClass([super class]));
        NSLog(@"333 --- %@", NSStringFromClass([self superclass]));
        NSLog(@"444 --- %@", NSStringFromClass([super superclass]));
    }
    return self;
}

@end
