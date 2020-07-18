//
//  ViewController.m
//  DYHomeTransition
//
//  Created by Smile on 09/05/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "XWPageCoverController.h"
#import <JPNavigationControllerKit.h>
#import "JPHomeViewController.h"
#import "JPScrollView.h"
#import "FMPhotoBrowserViewController.h"
#import "FMMiddleViewController.h"

@interface ViewController ()<UIScrollViewDelegate, JPNavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) JPScrollView *horizontalSV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake((Screen_W - 100)/2, Screen_H - 150, 100, 50);
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:@"click me" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushToNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
//    [self.view addSubview:self.horizontaSV];
}

- (void)pushToNextPage {
    FMMiddleViewController *fv = [[FMMiddleViewController alloc] init];
//    fv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fv animated:YES];
    // 抖音
//    XWPageCoverController *xv = [[XWPageCoverController alloc] init];
//    xv.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:xv animated:YES];
    
//    FMPhotoBrowserViewController *fv = [[FMPhotoBrowserViewController alloc] init];
//    fv.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:fv animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- lazy loading
- (JPScrollView *)horizontaSV {
    if (!_horizontalSV) {
        _horizontalSV = [[JPScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
        _horizontalSV.backgroundColor = [UIColor cyanColor];
        _horizontalSV.contentSize = CGSizeMake( Screen_W, Screen_H);
        _horizontalSV.pagingEnabled = YES;
        _horizontalSV.bounces = NO;
        _horizontalSV.delegate = self;
        JPNavigationController *nav1 = [[JPNavigationController alloc] initWithRootViewController:[JPHomeViewController new]];;
        nav1.tabBarItem.title = @"testOne";
        JPNavigationController *nav2 = [[JPNavigationController alloc] initWithRootViewController:[JPHomeViewController new]];
        nav2.tabBarItem.title = @"testTwo";
        UITabBarController *tvc = [UITabBarController new];
        tvc.viewControllers = @[nav1, nav2];
        [self.navigationController jp_registerNavigtionControllerDelegate:nav1.childViewControllers[0]];
        [_horizontalSV addSubview:nav1.view];
    }
    return _horizontalSV;
}

@end






