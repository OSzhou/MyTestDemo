//
//  AppDelegate.m
//  06_JSPatchDemo
//
//  Created by Windy on 2017/2/7.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "AppDelegate.h"
//#import "JPEngine.h"
#import "ViewController.h"
#import <JSPatchPlatform/JSPatch.h>

@interface AppDelegate () //AppKey_JSPatch 032663fcb59453b8

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //gitHub
    /* // 1.启动引擎
    [JPEngine startEngine];
    
    // 2.加载JS文件
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"FMDemo" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    // 3.评估（执行）
    [JPEngine evaluateScript:script];*/
    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC0wwLr5K65Gh7hbNR0fGWfl+zi\nVukUDmvDgc5OR/1RDefkLUUYJ0u28hgB56F7ghMcksQ1oJcVzev1spDLZJidAcOI\nGubEMGLZ8zZbZfy+om+l5qBTuyAdLCKFByAh0juQM63PU4rstbup93ibFaCy064b\n/EJqwN96P/GM5IPFsQIDAQAB\n-----END PUBLIC KEY-----"];
    [JSPatch setupLogger:^(NSString *msg) {
        //msg 是 JSPatch log 字符串，用你自定义的logger打出
//        NSLog(@"%@", nil);
    }];
    //    [JSPatch testScriptInBundle];//本地调试用
    [JSPatch startWithAppKey:@"032663fcb59453b8"];
    
#ifdef DEBUG
    [JSPatch setupDevelopment];//测试补丁用
    [JSPatch showDebugView];//
#endif
    [JSPatch sync];//可以把 [JSPatch sync] 放在 -applicationDidBecomeActive: 里，每次唤醒都能同步更新 JSPatch 补丁，不需要等用户下次启动
    
    // 4.主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *rootViewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    // 5.导航设置（影响所有导航）
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
