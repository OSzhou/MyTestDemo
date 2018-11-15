//
//  FMStarViewController.m
//  05_DIYUI
//
//  Created by Smile on 15/05/2018.
//  Copyright © 2018 Windy. All rights reserved.
//

#import "FMStarViewController.h"
#import "CourseEvaluateListCell.h"

@interface FMStarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FMStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseEvaluateListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CourseEvaluateListCell class])];
    return cell;
}

#pragma mark --- lazy loading

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CourseEvaluateListCell class] forCellReuseIdentifier:NSStringFromClass([CourseEvaluateListCell class])];
    }
    return _tableView;
}

@end























