//
//  FMGridLayout.m
//  05_DIYUI
//
//  Created by Windy on 2016/11/22.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMGridLayout.h"

@interface FMGridLayout ()
/** 所有布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end
@implementation FMGridLayout

- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (void)prepareLayout {
    [super prepareLayout];
    //每次进来都要清空一次数组，因为这是自己管理的属性数组，不是使用系统的
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat width = self.collectionView.frame.size.width * 0.5;
        if (i == 0) {
            CGFloat height = width;
            CGFloat x = 0;
            CGFloat y = 0;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 1) {
            CGFloat height = width * 0.5;
            CGFloat x = width;
            CGFloat y = 0;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 2) {
            CGFloat height = width * 0.5;
            CGFloat x = width;
            CGFloat y = height;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 3) {
            CGFloat height = width * 0.5;
            CGFloat x = 0;
            CGFloat y = width;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 4) {
            CGFloat height = width * 0.5;
            CGFloat x = 0;
            CGFloat y = width + height;
            attrs.frame = CGRectMake(x, y, width, height);
        } else if (i == 5) {
            CGFloat height = width;
            CGFloat x = width;
            CGFloat y = width;
            attrs.frame = CGRectMake(x, y, width, height);
        } else {//6个一循环, 过了六个从数组取对应的属性就行了
            UICollectionViewLayoutAttributes *lastAttrs = self.attrsArray[i - 6];
            CGRect lastFrame =  lastAttrs.frame;
            lastFrame.origin.y += 2 * width;
            attrs.frame = lastFrame;//是将取出的frame修改后赋值给attrs,而不是修改从数组取出的原始值
        }
        [self.attrsArray addObject:attrs];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize {
    int count = (int)[self.collectionView numberOfItemsInSection:0];
    int rows = (count + 3 - 1) / 3;
    CGFloat rowH = self.collectionView.frame.size.width * 0.5;
    return  CGSizeMake(0, rows * rowH);
}

@end
