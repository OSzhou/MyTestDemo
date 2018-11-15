//
//  ViewController.m
//  06_JSPatchDemo
//
//  Created by Windy on 2017/2/7.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn setTitle:@"Push FMTableViewController" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50)];
    [btn1 setTitle:@"Push SettingViewController" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(settingBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:btn1];
}

- (void)handleBtn:(id)sender
{
}

- (void)settingBtn:(UIButton *)sender {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Setting" bundle:nil];
//    UITableViewController *tvc = [sb instantiateInitialViewController];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *tvc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
