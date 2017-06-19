//
//  TKDAppDelegate.m
//  TextKitDemo
//
//  Created by Max Seelemann on 29.09.13.
//  Copyright (c) 2013 Max Seelemann. All rights reserved.
//

#import "TKDAppDelegate.h"

@implementation TKDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *body = @"123abcDEF456";
    NSString *keyString=@"1";
    NSScanner *scanner=[NSScanner scannerWithString:body];
    
    [scanner setCaseSensitive:NO];
    
    BOOL b;
    NSString *result = nil;
    /*** 必须保证scanLocation有变动，不然会死循环 scanString：必须手动加scanLocation ***/
    while (![scanner isAtEnd]){
        b=[scanner scanUpToString:keyString intoString:nil];
        [scanner scanUpToString:@"9" intoString:&result];
        NSLog(@"123 --- %@ --- %@", body, result);
//        b=[scanner scanString:keyString intoString:nil];
//        [scanner scanString:@"456" intoString:&result];
//        NSLog(@"123 --- %@ --- %@", body, result);

//        if(b) {
//            body=[body substringToIndex:[scanner scanLocation]-keyString.length];
//            NSLog(@"123 --- %@", result);
//            break;
//        } else {
//            scanner.scanLocation++;
//        }
    }/*
    NSString *html = @"<p>fafasfsfsf</p><li>1455543545</li>";
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
//        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        NSLog(@"123456 --- ");
    }
    */
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
