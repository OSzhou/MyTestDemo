//
//  Person.m
//  ChannelEditDemo
//
//  Created by Windy on 2017/4/28.
//  Copyright © 2017年 liuRuiLong. All rights reserved.
//

#import "Person.h"

@interface Person ()

- (BOOL)isEqualToPerson:(Person *)person;

@end

@implementation Person
//代码块书写格式
//NSURL *url = ({ NSString *urlString = [NSString stringWithFormat:@"%@/%@", baseURLString, endpoint];
//[NSURL URLWithString:urlString];
//});
- (BOOL)isEqualToPerson:(Person *)person {
    if (!person) {
        return NO;
    }
    
    BOOL haveEqualNames = (!self.name && !person.name) || [self.name isEqualToString:person.name];
    BOOL haveEqualBirthdays = (!self.birthday && !person.birthday) || [self.birthday isEqualToDate:person.birthday];
    
    return haveEqualNames && haveEqualBirthdays;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[Person class]]) {
        return NO;
    }
    
    return [self isEqualToPerson:(Person *)object];
}

- (NSUInteger)hash {
    NSLog(@"111 --- %zd 222 --- %zd", [self.name hash], [self.birthday hash]);
    // ^ :按位异或（计算方法：先转化为二进制，在按位异或）
    return [self.name hash] ^ [self.birthday hash];
}

@end
