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
#import "XLPhotoBrowser.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FMWaterflowLayoutDelegate>

/** collectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 大图浏览器 */
@property (nonatomic, strong) XLPhotoBrowser *browser;
/** 图片数组 */
@property (nonatomic , strong) NSMutableArray  *images;
@property (nonatomic, strong) UIView *bottomView;

@end
static NSString *const FMPhotoCellID = @"photo";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //<1>line
//    FMLineLayout *layout = [[FMLineLayout alloc] init];
//    layout.itemSize = CGSizeMake(100, 100);
//    CGFloat collection_w = self.view.frame.size.width;
//    CGFloat collection_h = 200;
//    CGRect frame =  CGRectMake(0, self.view.frame.size.height - 200, collection_w, collection_h);
//    //<2>
////    FMGridLayout *layout = [[FMGridLayout alloc] init];
////    CGRect frame = self.view.bounds;
//    //<3>
////    FMCircleLayout *layout = [[FMCircleLayout alloc] init];
////    CGFloat collection_w = self.view.frame.size.width;
////    CGFloat collection_h = 200;
////    CGRect frame =  CGRectMake(0, 150, collection_w, collection_h);
//    //<4>
////    FMWaterflowLayout *layout = [[FMWaterflowLayout alloc] init];
////    layout.delegate = self;
////    CGRect frame = self.view.bounds;
//    
//    [self DIYUIWithLayout:layout andFrame:frame];
    self.images = [NSMutableArray array];
    for (int i = 1 ; i < 21 ; i++) {
        NSString *string = [NSString stringWithFormat:@"%zd",i];
        UIImage *image = [UIImage imageNamed:string];
        [self.images addObject:image];
    }
    _browser = [XLPhotoBrowser fm_showPhotoBrowserWithSuperView:self.view images:self.images currentImageIndex:0];
    _browser.browserStyle = XLPhotoBrowserStyleIndexLabel;
    __weak typeof(self) weakSelf = self;
    _browser.testBlock = ^{
        weakSelf.bottomView.hidden = !weakSelf.bottomView.hidden;
    };
    [self autoResizingTest];
}

- (void)autoResizingTest {
    UIView *playControlbgview = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 35, self.view.bounds.size.width, 35)];
    playControlbgview = playControlbgview;
    playControlbgview.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleTopMargin;
    playControlbgview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.bottomView = playControlbgview;
    [self.view addSubview:playControlbgview];
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
//    NSLog(@" --- %f", scrollView.contentOffset.y);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *arr = [self.collectionView indexPathsForVisibleItems];
//        for (NSIndexPath *path in arr) {
//            NSLog(@"index --- %zd", path.row);
//        }
    if (arr.count) {
        NSIndexPath *path = arr[0];
        NSIndexPath *indexPath = (arr.count == 2 && path.item <=0) ? arr[0] : arr[1];
        [_browser scrollToCurrentPage:indexPath.item];
    }
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
//    FMLog(@" --- %zd", indexPath.item);
    [_browser scrollToCurrentPage:indexPath.item];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.baidu.com"]];
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
