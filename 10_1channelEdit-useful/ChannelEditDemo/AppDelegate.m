//
//  AppDelegate.m
//  ChannelEditDemo
//
//  Created by liuRuiLong on 16/1/5.
//  Copyright © 2016年 liuRuiLong. All rights reserved.
//

#import "AppDelegate.h"
#import "Person.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Person *person = [[Person alloc] init];
    person.name = @"xiaoming";
    person.birthday = [NSDate date];
    NSLog(@"123456 --- %zd", person.hash);
    return YES;
}

@end
