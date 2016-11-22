//
//  ViewController.m
//  04-ScrollView的常见处理
//
//  Created by xiaomage on 15/9/23.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIView *leftBar;
@property (nonatomic, weak) UIView *topBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    CGFloat contentW = 1000;
    CGFloat contentH = 1000;
    
    CGFloat barSpacing = 50;
    
    // 右下角内容
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor yellowColor];
    contentView.frame = CGRectMake(barSpacing, barSpacing, contentW, contentH);
    [scrollView addSubview:contentView];
    
    // 顶部条
    UIView *topBar = [[UIView alloc] init];
    topBar.frame = CGRectMake(barSpacing, 0, contentW, barSpacing);
    topBar.backgroundColor = [UIColor redColor];
    [scrollView addSubview:topBar];
    self.topBar = topBar;
    
    // 左边条
    UIView *leftBar = [[UIView alloc] init];
    leftBar.frame = CGRectMake(0, barSpacing, barSpacing, contentH);
    leftBar.backgroundColor = [UIColor blueColor];
    [scrollView addSubview:leftBar];
    self.leftBar = leftBar;
    
    // 设置contentSize
    scrollView.contentSize = CGSizeMake(contentW + barSpacing, contentH + barSpacing);
    
    // 盖住黄色和蓝色的条(左上角的白色遮盖小方块)
    UIView *cover = [[UIView alloc] init];
    cover.frame = CGRectMake(0, 0, barSpacing, barSpacing);
    cover.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cover];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect topF = self.topBar.frame;
    topF.origin.y = scrollView.contentOffset.y;
    self.topBar.frame = topF;
    
    CGRect leftF = self.leftBar.frame;
    leftF.origin.x = scrollView.contentOffset.x;
    self.leftBar.frame = leftF;
}

@end
