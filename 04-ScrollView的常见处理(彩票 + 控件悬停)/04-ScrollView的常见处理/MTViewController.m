//
//  MTViewController.m
//  04-ScrollView的常见处理
//
//  Created by xiaomage on 15/9/23.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MTViewController.h"


@interface MTViewController () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *horizontalSV;
@property (nonatomic, strong) UITableView *tableV;

@end

@implementation MTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    [scrollView addSubview:[[UISwitch alloc] init]];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1500);
    scrollView.backgroundColor = [UIColor grayColor];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIView *bar = [[UIView alloc] init];
    bar.frame = CGRectMake(0, 70, self.view.frame.size.width, 50);
    bar.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    self.bar = bar;
    [self.horizontalSV addSubview:self.tableV];
    [scrollView addSubview:self.horizontalSV];
    [scrollView addSubview:bar];
}

- (UITableView *)tableV {
    if (!_tableV) {
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 375, 600) style:UITableViewStylePlain];
        _tableV.clipsToBounds = NO;
        _tableV.delegate = self;
        _tableV.dataSource = self;
    }
    return _tableV;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"test1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd个cell", indexPath.row];
    // Configure the cell...
    
    return cell;
}

- (UIScrollView *)horizontalSV {
    if (!_horizontalSV) {
        _horizontalSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 500)];
        _horizontalSV.backgroundColor = [UIColor cyanColor];
        _horizontalSV.clipsToBounds = NO;
        _horizontalSV.alwaysBounceHorizontal = YES;
        _horizontalSV.contentSize = CGSizeMake(1000, 0);
     }
    return _horizontalSV;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView == self.scrollView) {
//        if (scrollView.contentOffset.y >= 70) {
//            //        self.bar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
//            //        [self.view addSubview:self.bar];
//            //不断的更新bar的y值(其实就等于scrollView向上的偏移量)
//            self.bar.frame = CGRectMake(0, scrollView.contentOffset.y, self.view.frame.size.width, 50);
//        } else {
//            //        self.bar.frame = CGRectMake(0, 70, self.view.frame.size.width, 50);
//            //        [scrollView addSubview:self.bar];
//        }
//    }
    if (scrollView == self.scrollView) {
        if (scrollView.contentOffset.y >= 70) {
                    self.bar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
                    [self.view addSubview:self.bar];
        } else {
                    self.bar.frame = CGRectMake(0, 70, self.view.frame.size.width, 50);
                    [scrollView addSubview:self.bar];
        }
    }

    if ((scrollView = self.tableV)) {
        if (self.tableV.contentOffset.y > 0) {
            self.bar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
            [self.tableV addSubview:self.bar];
           self.scrollView.frame = CGRectMake(0, -1.5 * scrollView.contentOffset.y, self.view.frame.size.width, 1500);
            if (scrollView.contentOffset.y >= 50) {
                self.bar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
                [self.view addSubview:self.bar];
            }
        } else {
            self.bar.frame = CGRectMake(0, 70, self.view.frame.size.width, 50);
            [self.scrollView addSubview:self.bar];
        }
//        if (self.scrollView.contentOffset.y >= 70) {
//            [self.view addSubview:self.tableV];
//        } else {
//        }
    }
}

@end
