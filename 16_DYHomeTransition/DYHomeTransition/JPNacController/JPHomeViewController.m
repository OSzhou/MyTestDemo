//
//  JPHomeViewController.m
//  DYHomeTransition
//
//  Created by Smile on 10/05/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "JPHomeViewController.h"
#import "JPOneViewController.h"
#import <JPNavigationControllerKit.h>

@interface JPHomeViewController ()<JPNavigationControllerDelegate>

@end

@implementation JPHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController jp_registerNavigtionControllerDelegate:self];
}

-(void)navigationControllerDidPush:(JPNavigationController *)navigationController{
    JPOneViewController *ovc = [JPOneViewController new];
     ovc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ovc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
