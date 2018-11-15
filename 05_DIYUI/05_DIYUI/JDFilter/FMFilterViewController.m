//
//  FMFilterViewController.m
//  侧滑视图demo
//
//  Created by Windy on 2017/3/20.
//  Copyright © 2017年 hxyxt. All rights reserved.
//

#import "FMFilterViewController.h"
#import "UIView+XLExtension.h"

@interface FMFilterViewController ()

@end

@implementation FMFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    [self createSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSubview {
    for (int i = 0; i < 2; i ++) {
        NSString *title = i == 0 ? @"收费类型" : @"学习状态";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 64 + i * 200, 100, 30)];
        label.text = title;
        label.textColor = [UIColor blackColor];
        [self.view addSubview:label];
        for (int j = 0; j < 2; j ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50 + j * 80, 114 + i * 200, 60, 25)];
            btn.backgroundColor = [UIColor lightGrayColor];
            NSString *subTitle;
            if (!i) {
                subTitle = j == 0 ? @"免费" : @"收费";
            } else {
                subTitle = j == 0 ? @"已加入" : @"未加入";
            }
            [btn setTitle:subTitle forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
        NSString *bottomTitle = i == 0 ? @"重置" : @"确定";
        UIButton *bbtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i * self.bounds.width / 2, self.bounds.height - 50, self.bounds.width / 2, 50)];
        [bbtn setTitle:bottomTitle forState:UIControlStateNormal];
        [bbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bbtn];
    }
}

- (void)buttonClick:(UIButton *)sender {
    NSLog(@"button title --- %@", sender.currentTitle);
}

@end
