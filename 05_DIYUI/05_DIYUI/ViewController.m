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
#import "FMTitleHeaderView.h"
#import "FMVerticalButton.h"
#import "FMCoreTextView.h"
#import "FMJDViewController.h"
#import "FirstViewController.h"
#import "FMStarViewController.h"
#import "SpliceImageController.h"

#import "TULineLayout.h"

#define View_W [UIScreen mainScreen].bounds.size.width
#define View_H [UIScreen mainScreen].bounds.size.height

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
   
    //<1>line
//    FMLineLayout *layout = [[FMLineLayout alloc] init];
//    layout.itemSize = CGSizeMake(100, 100);
//    CGFloat collection_w = self.view.frame.size.width;
//    CGFloat collection_h = 200;
//    CGRect frame =  CGRectMake(0, self.view.frame.size.height - 200, collection_w, collection_h);
    //<2>
//    FMGridLayout *layout = [[FMGridLayout alloc] init];
//    CGRect frame = self.view.bounds;
    //<3>
//    FMCircleLayout *layout = [[FMCircleLayout alloc] init];
//    CGFloat collection_w = self.view.frame.size.width;
//    CGFloat collection_h = 200;
//    CGRect frame =  CGRectMake(0, 150, collection_w, collection_h);
    //<4>
//    FMWaterflowLayout *layout = [[FMWaterflowLayout alloc] init];
//    layout.delegate = self;
//    CGRect frame = self.view.bounds;
    
    
    //<5>tata release 仿 Instagram 发布
    
    TULineLayout *layout = [[TULineLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    CGFloat collection_w = self.view.frame.size.width;
    CGFloat collection_h = 200;
    CGRect frame =  CGRectMake(0, self.view.frame.size.height - 200, collection_w, collection_h);
    
    [self DIYUIWithLayout:layout andFrame:frame];
    
//    [self autoResizingTest];
//    [self photoBrowserTest];
//    [self scrollTitleViewTest];
//    [self labelTest];
//    [self verticalButtonTest];
//    [self coreTextTest];
    // 字体样式测试
//    [self fontFamilyTest];
}
- (IBAction)buttonClick:(UIButton *)sender {
//    [self JDFilterTest];
    //维持一个控制器
//    [self keepVCTest];
    // 评论的星星测试
//    [self starCellTest];
    // 图片拼接的测试
    [self imageSplice];
}

- (void)fontFamilyTest {
    UILabel *origin = [UILabel new];
    origin.frame = CGRectMake(0, Screen_H - 200, 375, 50);
    origin.text = @"1234567890 Hello World 你好";
    origin.font = [UIFont systemFontOfSize:36];
    origin.textColor = [UIColor blackColor];
    [self.view addSubview:origin];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, Screen_H - 50, 61, 50);
    label.text = @"08:50";
    label.textColor = [UIColor purpleColor];
    label.font = [UIFont fontWithName:@"DINEngschriftStd" size:36];
    [self.view addSubview:label];
    UILabel *l = [[UILabel alloc] init];
    l.frame = CGRectMake(100, Screen_H - 50, 200, 50);
    l.text = @"Hello World";
    l.textColor = [UIColor blackColor];
    l.font = [UIFont fontWithName:@"DINCond-Medium" size:36];
    [self.view addSubview:l];
}

- (void)imageSplice {
    SpliceImageController *sv = [[SpliceImageController  alloc] init];
    [self presentViewController:sv animated:YES completion:nil];
}

- (void)starCellTest {
    FMStarViewController *sv = [[FMStarViewController alloc] init];
    [self presentViewController:sv animated:YES completion:nil];
}

- (void)keepVCTest {
    FirstViewController *fvc = [FirstViewController new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)JDFilterTest {
    FMJDViewController *jvc = [[FMJDViewController alloc] init];
    jvc.leftSlideEnable = NO;
    [self presentViewController:jvc animated:YES completion:nil];
}

- (void)coreTextTest {
    FMCoreTextView *coreText = [[FMCoreTextView alloc] initWithFrame:CGRectMake(0, 0, View_W, View_H)];
    coreText.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:coreText];
}

- (void)verticalButtonTest {
    NSArray *titleArr = @[@"免费课程", @"畅销课程", @"全部课程", @"全部学院"];
    NSArray *imageArr = @[@"add", @"Calendar", @"stomatologist", @"add"];
    for (int i = 0; i < 4; i ++) {
        FMVerticalButton *btn = [FMVerticalButton verticalButtonWithNormalImageName:imageArr[i]
                                                                  selectedImageName:nil
                                                                              title:titleArr[i]];
        CGFloat edge = 12.5;
        CGFloat margin = 45.f;
        btn.frame = CGRectMake(edge + i * ((View_W - 2 * edge - margin * 3) / 4 + margin) , 64, (View_W - 2 * edge - margin * 3) / 4, 50);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)sender {
    NSLog(@"123456 --- %@", sender.currentTitle);
}

- (void)labelTest {
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, View_W, 300)];
    testLabel.text = @"Time is a bird for ever on the wing!";
    testLabel.numberOfLines = 0;
    testLabel.font = [UIFont fontWithName:@"Zapfino" size:20];
    [self.view addSubview:testLabel];
}

- (void)scrollTitleViewTest {
    FMTitleHeaderView *headView = [[FMTitleHeaderView alloc] initWithFrame:CGRectMake(0, 64, View_W, 50)];
//    headView.fontSize = 10.f;
    headView.titleArr = @[@"全部课程", @"政治", @"军事", @"明星八卦", @"体育", @"财富"];
    [self.view addSubview:headView];
}

- (void)photoBrowserTest {
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
    collectionView.clipsToBounds = NO;
//    collectionView.contentInset = UIEdgeInsetsMake(100, 0, 100, 0);

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [collectionView addGestureRecognizer:longPressGesture];
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FMPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:FMPhotoCellID];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [longPress locationInView:_collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    //根据长按手势的状态进行处理。
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            //当没有点击到cell的时候不进行处理
            if (!indexPath) {
                break;
            }
            //开始移动
            [_collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程中更新位置坐标
            [_collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            //停止移动调用此方法
            [_collectionView endInteractiveMovement];
            break;
        default:
            //取消移动
            [_collectionView cancelInteractiveMovement];
            break;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FMPhotoCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
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
- (CGFloat)waterflowLayout:(FMWaterflowLayout *)waterflowLayout
      heightForItemAtIndex:(NSUInteger)index
                 itemWidth:(CGFloat)itemWidth {
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
