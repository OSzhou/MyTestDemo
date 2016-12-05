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
#import "FMGridLayout.h"
#import "FMCircleLayout.h"
#import "FMWaterflowLayout.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FMWaterflowLayoutDelegate>

/** collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;

@end
static NSString *const FMPhotoCellID = @"photo";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //<1>line
//    FMLineLayout *layout = [[FMLineLayout alloc] init];
//    layout.itemSize = CGSizeMake(100, 100);
//    CGFloat collection_w = self.view.frame.size.width;
//    CGFloat collection_h = 200;
//    CGRect frame =  CGRectMake(0, 150, collection_w, collection_h);
    //<2>
//    FMGridLayout *layout = [[FMGridLayout alloc] init];
//    CGRect frame = self.view.bounds;
    //<3>
//    FMCircleLayout *layout = [[FMCircleLayout alloc] init];
//    CGFloat collection_w = self.view.frame.size.width;
//    CGFloat collection_h = 200;
//    CGRect frame =  CGRectMake(0, 150, collection_w, collection_h);
    //<4>
    FMWaterflowLayout *layout = [[FMWaterflowLayout alloc] init];
    layout.delegate = self;
    CGRect frame = self.view.bounds;
    
    [self DIYUIWithLayout:layout andFrame:frame];
}

- (void)DIYUIWithLayout:(UICollectionViewLayout *)layout andFrame:(CGRect)frame {
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(100, 100);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
//    collectionView.contentInset = UIEdgeInsetsMake(100, 0, 100, 0);

    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FMPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:FMPhotoCellID];
}
/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.collectionView.collectionViewLayout isKindOfClass:[FMLineLayout class]]) {
        [self.collectionView setCollectionViewLayout:[[FMCircleLayout alloc] init]];
    } else {
        FMLineLayout *layout = [[FMLineLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        [self.collectionView setCollectionViewLayout:layout animated:YES];
    }
}
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@" --- %f", scrollView.contentOffset.y);
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
//#line 1000
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FMLog(@" --- %zd", indexPath.item);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
}

#pragma mark --- FMWaterflowLayoutDelegate
- (CGFloat)waterflowLayout:(FMWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    return 50 + arc4random_uniform(100);
}

- (NSInteger)columnCountInWaterflowLayout:(FMWaterflowLayout *)waterflowLayout {
    return 3;
}

- (CGFloat)columnMarginInWaterflowLayout:(FMWaterflowLayout *)waterflowLayout {
    return 10;
}

- (CGFloat)rowMarginInWaterflowLayout:(FMWaterflowLayout *)waterflowLayout {
    return 10;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(FMWaterflowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
