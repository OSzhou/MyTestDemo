//
//  FMConditionViewController.m
//  SenyintCollegeStudent_2.0
//
//  Created by Windy on 2017/3/24.
//  Copyright © 2017年 任亚丽. All rights reserved.
//

#import "FMConditionViewController.h"

@interface FMConditionViewController ()

@property (nonatomic, assign) CGFloat FMRightMargin;
@property (nonatomic, strong) UIView *bg;


@end
//侧拉视图距离左边的距离
static const CGFloat FMLeftMargin = 100.f;
@implementation FMConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _FMRightMargin = _leftSlideEnable ? 15.f : 0.0f;

    self.view.backgroundColor = [UIColor cyanColor];
    [self setupFilterAndBackgroundView];
    
}

- (void)setupFilterAndBackgroundView {
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(sideslipViewAnimate:)]];
    UIView *bg = [[UIView alloc]initWithFrame:Screen_Bounds];
    bg.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
    bg.alpha = 0.0;
    bg.hidden = YES;
    [bg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTap:)]];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:bg];
    self.bg = bg;
}

- (void)backgroundViewTap:(UITapGestureRecognizer *)gesture {
    if ([gesture.view isEqual:self.bg]) {
        [UIView animateWithDuration:0.25f animations:^{
            self.bg.alpha = 0;
            self.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished == YES) {
                self.bg.hidden = YES;
            }
        }];
    }
}

#pragma mark --- 筛选视图相关
// 用x来判断，用transform来控制
- (void)sideslipViewAnimate:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    //结束拖拽
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        if (pan.view.x >= FMLeftMargin + self.view.width * 0.5) { //往右边至少走动了本身的一半
            [UIView animateWithDuration:0.25f animations:^{
                self.bg.alpha = 0;
                pan.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.bg.hidden = YES;
            }];
        } else {//走动距离的没有达到本身一半
            [UIView animateWithDuration:0.25f animations:^{
                self.bg.alpha = 1;
                pan.view.transform = CGAffineTransformMakeTranslation(-self.view.width + _FMRightMargin, 0);
            }];
        }
    } else {//正在拖拽中
        self.bg.hidden = NO;
        pan.view.transform = CGAffineTransformTranslate(pan.view.transform, point.x, 0);
        [pan setTranslation:CGPointZero inView:pan.view];
        
        //让拖动时背景黑板色渐变
        self.bg.alpha = 1 - (pan.view.x - FMLeftMargin) / self.view.width;
        
        if (pan.view.x >= Screen_Width) {
            pan.view.transform = CGAffineTransformIdentity;
        } else if (pan.view.x <= FMLeftMargin) {
            pan.view.transform = CGAffineTransformMakeTranslation(-self.view.width + _FMRightMargin, 0);
        }
    }
}

- (void)addViewToKeyWindow {
    self.bounds = CGSizeMake(Screen_Width - FMLeftMargin, Screen_Height - 64);
    self.view.frame = CGRectMake(Screen_Width - _FMRightMargin, 64, Screen_Width - FMLeftMargin, Screen_Height - 64);
    //侧拉视图添加到keyWindow上（注意移除）
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview: self.view];
}

- (void)filterViewShow {
    self.bg.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        self.bg.alpha = 1.0;
        self.view.transform = CGAffineTransformMakeTranslation(-self.view.width + _FMRightMargin, 0);
    }];
}

- (void)setLeftSlideEnable:(BOOL)leftSlideEnable {
    _leftSlideEnable = leftSlideEnable;
}

- (void)dealloc {
    [self.bg removeFromSuperview];
    self.bg = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
