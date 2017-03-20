//
//  FMJDViewController.m
//  05_DIYUI
//
//  Created by Windy on 2017/3/20.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "FMJDViewController.h"
#import "UIView+XLExtension.h"
#import "FMFilterViewController.h"

#define mainwidth   self.view.frame.size.width
#define mainheight  self.view.frame.size.height
//侧拉视图距离左边的距离
static const CGFloat FMLeftMargin = 100.f;
//右侧预留手势宽度
//static const CGFloat FMRightMargin = 15.f;

@interface FMJDViewController ()

@property (nonatomic, strong) UIView *sideslipView;
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) FMFilterViewController *fvc;
@property (nonatomic, assign) CGFloat FMRightMargin;

//侧拉视图的宽度
@property (nonatomic, assign) CGFloat sideslipView_W;

@end

@implementation FMJDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _FMRightMargin = _leftSlideEnable ? 15.f : 0.0f;
    //初始化UI
    [self setupUI];
}

- (void)setupUI {
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(50, 280, 250, 40)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"京东“筛选”按钮演示" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _fvc = [[FMFilterViewController alloc] init];
    _fvc.bounds = CGSizeMake(mainwidth - FMLeftMargin, mainheight);
    //透明黑色背景
    UIView *bg = [[UIView alloc]initWithFrame:self.view.frame];
    bg.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
    bg.alpha = 0.0;
    bg.hidden = YES;
    [self.view addSubview:bg];
    self.bg = bg;
    
    //侧拉视图的宽度
    self.sideslipView_W = mainwidth - FMLeftMargin;
    self.sideslipView = _fvc.view;
    self.sideslipView.frame = CGRectMake(mainwidth - _FMRightMargin, 0, self.sideslipView_W, mainheight);
    [self.view addSubview: self.sideslipView];
    [self.sideslipView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(sideslipViewAnimate:)]];
}

//点击事件
- (void)addview {
    self.bg.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        self.bg.alpha = 1.0;
        self.sideslipView.transform = CGAffineTransformMakeTranslation(-self.sideslipView_W + _FMRightMargin, 0);
    }];
}

// 用x来判断，用transform来控制
- (void)sideslipViewAnimate:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    //结束拖拽
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded) {
        if (pan.view.x >= FMLeftMargin + self.sideslipView_W * 0.5) { //往右边至少走动了本身的一半
            [UIView animateWithDuration:0.25f animations:^{
                self.bg.alpha = 0;
                pan.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.bg.hidden = YES;
            }];
        } else {//走动距离的没有达到本身一半
            [UIView animateWithDuration:0.25f animations:^{
                self.bg.alpha = 1;
                pan.view.transform = CGAffineTransformMakeTranslation(-self.sideslipView_W + _FMRightMargin, 0);
            }];
        }
    } else {//正在拖拽中
        self.bg.hidden = NO;
        pan.view.transform = CGAffineTransformTranslate(pan.view.transform, point.x, 0);
        [pan setTranslation:CGPointZero inView:pan.view];
        
        //让拖动时背景黑板色渐变
        self.bg.alpha = 1 - (pan.view.x - FMLeftMargin) / self.sideslipView_W;
        
        if (pan.view.x >= mainwidth) {
            pan.view.transform = CGAffineTransformIdentity;
        } else if (pan.view.x <= FMLeftMargin) {
            pan.view.transform = CGAffineTransformMakeTranslation(-self.sideslipView_W + _FMRightMargin, 0);
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch.view isEqual:self.bg]) {
        [UIView animateWithDuration:0.25f animations:^{
            self.bg.alpha = 0;
            self.sideslipView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished == YES) {
                self.bg.hidden = YES;
            }
        }];
    }
}

- (void)setLeftSlideEnable:(BOOL)leftSlideEnable {
    _leftSlideEnable = leftSlideEnable;
}

@end
