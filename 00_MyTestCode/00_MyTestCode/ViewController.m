//
//  ViewController.m
//  00_MyTestCode
//
//  Created by Zhouheng on 2019/8/14.
//  Copyright © 2019 tataUFO. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// sv 的contentsize 自行适应
- (void)scrollViewContentTest {
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 100, 200, 80)];
    sv.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:sv];
    UIView *containerView = [UIView new];
    
    [sv addSubview:containerView];
    containerView.backgroundColor = [UIColor cyanColor];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(sv);
    }];
    
    UIView *leftView = [UIView new];
    leftView.backgroundColor = [UIColor orangeColor];
    [containerView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(containerView);
        make.width.equalTo(@(100));
        make.height.equalTo(@(80));
    }];
    
    UIView *rightView = [UIView new];
    rightView.backgroundColor = [UIColor redColor];
    [containerView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(containerView);
        make.width.equalTo(@(100));
        make.height.equalTo(@(80));
    }];
    
    UIView *middleView = [UIView new];
    middleView.backgroundColor = [UIColor blueColor];
    [containerView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.top.equalTo(containerView);
        make.right.equalTo(rightView.mas_left);
        make.width.equalTo(@(100));
        make.height.equalTo(@(80));
    }];
    
}

@end
