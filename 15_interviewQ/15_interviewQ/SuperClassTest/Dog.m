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
        NSLog(@"111 --- %@", NSStringFromClass([self class]));// Dog
        //只是通知父类去调用class方法，子类重写了这个方法，所以还是调用本类的class，所以还是Dog
        NSLog(@"222 --- %@", NSStringFromClass([super class]));// Dog
        NSLog(@"333 --- %@", NSStringFromClass([self superclass]));// Person
        NSLog(@"444 --- %@", NSStringFromClass([super superclass]));// Person
    }
    return self;
}

@end
