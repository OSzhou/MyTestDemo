//
//  FMViewController.m
//  DraggingSort
//
//  Created by Windy on 2017/3/23.
//  Copyright © 2017年 YL. All rights reserved.
//

#import "FMViewController.h"
#import "YLDragSortViewController.h"
#import "FMDragSortModel.h"

@interface FMViewController ()
@end

@implementation FMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    if ([segue.identifier isEqualToString:@"SortViewSegue"]) {
        YLDragSortViewController *dvc = (YLDragSortViewController *)segue.destinationViewController;
        dvc.topDataSource = [self.topChannelArr mutableCopy];
        dvc.bottomDataSource = [self.bottomChannelArr mutableCopy];
    }
}
 */

@end
