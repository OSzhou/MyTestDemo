//
//  ViewController.m
//  12_BlocksKitTest
//
//  Created by Windy on 2017/6/20.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "ViewController.h"
#import "BlocksKit+UIKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(id)sender {
    [UIAlertView bk_showAlertViewWithTitle:@"" message:@"lalala" cancelButtonTitle:@"知道了" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
