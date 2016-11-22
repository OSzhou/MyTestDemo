//
//  ViewController.m
//  05_DIYUI
//
//  Created by Windy on 2016/11/22.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "ViewController.h"
#import "FMPhotoCell.h"
#import "FMLineLayout.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@end
static NSString *const FMPhotoCellID = @"photo";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self DIYUI_one];
}

- (void)DIYUI_one {
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    FMLineLayout *layout = [[FMLineLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    CGFloat collection_w = self.view.frame.size.width;
    CGFloat collection_h = 200;
   CGRect frame =  CGRectMake(0, 150, collection_w, collection_h);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FMPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:FMPhotoCellID];
}

#pragma mark --- collectionView Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FMPhotoCellID forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd", indexPath.item + 1]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FMLog(@" --- %zd", indexPath.item);
}

@end
