//
//  FMSafeAreaController.m
//  05_DIYUI
//
//  Created by Smile on 2018/5/19.
//  Copyright © 2018 Windy. All rights reserved.
//

#import "FMSafeAreaController.h"
#import "FMTestView.h"

@interface FMSafeAreaController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FMSafeAreaController
// 参考资料
// https://blog.csdn.net/illusion21/article/details/78106047
- (void)viewDidLoad {
    [super viewDidLoad];
    self.additionalSafeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    //    FMTestView *v = [FMTestView viewFromXib];
    //    v.frame =  CGRectMake(0, 44, Screen_w, 200);
    //    [self.view addSubview:v];
    [self codeTest];
    //    self.tableView.adjustedContentInset
}

- (void)codeTest {
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.additionalSafeAreaInsets.top, Screen_W, 200)];
    iv.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:iv];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, self.additionalSafeAreaInsets.top + 180, 200, 20)];
    l.backgroundColor = [UIColor cyanColor];
    l.text = @"I am a test label";
    [iv addSubview:l];
    FMTestView *v = [FMTestView viewFromXib];
    v.frame =  CGRectMake(0, 220, Screen_W, 200);
    [iv addSubview:v];
    NSLog(@" --- %@", NSStringFromUIEdgeInsets(self.additionalSafeAreaInsets));
    NSLog(@" --- %@", NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    NSLog(@" --- %@", NSStringFromUIEdgeInsets(iv.safeAreaInsets));
    NSLog(@" --- %@", NSStringFromCGPoint(self.view.safeAreaLayoutGuide.accessibilityActivationPoint));
    NSLog(@" --- %@", NSStringFromCGPoint(self.view.safeAreaLayoutGuide.topAnchor.accessibilityActivationPoint));
    NSLog(@" --- %d", __IPHONE_OS_VERSION_MAX_ALLOWED);
    NSLog(@" --- %d", __IPHONE_OS_VERSION_MIN_REQUIRED);
    NSLog(@" --- %d", __IPHONE_11_0);
    NSLog(@" --- %f", [[[UIDevice currentDevice] systemVersion] floatValue]);
    //如果iOS的系统是11.0，会有这样一个宏定义“#define __IPHONE_11_0  110000”；如果系统版本低于11.0则没有这个宏定义
    /**
     __IPHONE_OS_VERSION_MAX_ALLOWED
     __IPHONE_OS_VERSION_MIN_REQUIRED
     __IPHONE_11_0
     都是用来判断开发环境SDK（当前使用的xcode是否支持这个API）的版本的，
     切记不能用来判断用户手机系统版本
     */
#ifdef __IPHONE_11_0
    if ([_tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
