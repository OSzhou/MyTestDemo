//
//  FMParentCollectionViewController.m
//  SenyintCollegeStudent_2.0
//
//  Created by Windy on 2017/3/21.
//  Copyright © 2017年 任亚丽. All rights reserved.
//

#import "FMParentCollectionViewController.h"
#import "MJRefresh.h"

@interface FMParentCollectionViewController ()

@property (nonatomic, assign) NSInteger page;

@end
static NSString *FMBaseID = @"FMBaseID";
@implementation FMParentCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    self.title = self.titleStr;
    [self.view addSubview:self.collectionView];
}

- (void)setRefreshType:(FMRefreshType)refreshType {
    _refreshType = refreshType;
    if (refreshType & FMRefreshTypeHeader) {
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefreshData)];
    }
    if (refreshType & FMRefreshTypeFooter) {
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToGetMoreData)];
    }
}

- (void)setTopHeight:(CGFloat)topHeight {
    _topHeight = topHeight;
}

- (void)setCollectionViewY:(CGFloat)collectionViewY {
    _collectionViewY = collectionViewY;
}

/** 下拉刷新 */
- (void)pullDownToRefreshData {
     NSString *URL = [NSString stringWithFormat:self.urlStr, _page];
    [NetworkManager GET:URL parameters:nil success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        [self.dataArray removeAllObjects];
        _page = 1;
        NSArray *newData = [self createDataObjectWithJSONNode:responseObject];
        [_collectionView.mj_header endRefreshing];
        if (newData.count) {
            [self.dataArray addObjectsFromArray:newData];
            //解决collectionView，下拉刷新会闪屏的bug
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
    } failure:^(NSURLResponse * _Nonnull response, NSString * _Nullable message, NSError * _Nullable error) {
        [_collectionView.mj_header endRefreshing];
        if (self.isVisibleViewController && !error) {
            [SCProgressHUD showInfoWithStatus:message];
        }
    }];
}

/** 上拉加载 */
- (void)pullUpToGetMoreData {
    NSInteger page = _page + 1;
    NSString *URL = [NSString stringWithFormat:self.urlStr, _page];
    [NetworkManager GET:URL parameters:nil success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
        _page = page;
        [_collectionView.mj_footer endRefreshing];
        NSArray *newData = [self createDataObjectWithJSONNode:responseObject];
        if (!newData.count) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [_collectionView.mj_footer endRefreshing];
            [self.dataArray addObjectsFromArray:newData];
            [self.collectionView reloadData];
        }
    } failure:^(NSURLResponse * _Nonnull response, NSString * _Nullable message, NSError * _Nullable error) {
        [_collectionView.mj_footer endRefreshing];
        if (self.isVisibleViewController) {
            [SCProgressHUD showInfoWithStatus:message];
        }
    }];
}

- (NSArray *)createDataObjectWithJSONNode:(id)node {
    NSLog(@"Please don't use this method, use derives.");
    return nil;
}

#pragma mark --- collectionView Delegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_Width - 25 - 15) / 2, (142.0 / 667.0) * Screen_Height);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FMBaseID forIndexPath:indexPath];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 12.5, 15, 12.5);
}

#pragma mark --- 各种事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- lazyLoading
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.collectionViewY, Screen_Width, Screen_Height - 64 - _topHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:FMBaseID];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
