//
//  FMWaterflowLayout.m
//  05_DIYUI
//
//  Created by Windy on 2016/11/23.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMWaterflowLayout.h"

static const NSInteger FMDefaultColumnCount = 3;
static const CGFloat FMDefaultColumnMargin = 10;
static const CGFloat FMDefaultRowMargin = 10;
static const UIEdgeInsets FMDefaultEdgeInsets = {10, 10, 10, 10};

@interface FMWaterflowLayout ()

@property (nonatomic, strong) NSMutableArray *attrsArray;
@property (nonatomic, strong) NSMutableArray *columnHeights;
@property (nonatomic, assign) CGFloat contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;

@end
@implementation FMWaterflowLayout

- (CGFloat)rowMargin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return FMDefaultRowMargin;
    }
}

- (CGFloat)columnMargin {
    if (self.delegate && [self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate  columnMarginInWaterflowLayout:self];
    } else {
        return FMDefaultColumnMargin;
    }
}

- (NSInteger)columnCount {
    if (self.delegate && [self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate  columnCountInWaterflowLayout:self];
    } else {
        return FMDefaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets {
    if (self.delegate && [self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return FMDefaultEdgeInsets;
    }
}

- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (void)prepareLayout {
    [super prepareLayout];
    [self.columnHeights removeAllObjects];
    //距离顶部间距
    for (int i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    [self.attrsArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = 0;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(waterflowLayout:heightForItemAtIndex:itemWidth:)]) {
        h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
//    } else {
//        h = 50 + arc4random_uniform(100);
//    }
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (int i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    //更行最短一列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    //记录最大内容高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize {
    /*
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    for (int i = 1; i < FMDefaultColumnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (maxColumnHeight < columnHeight) {
            maxColumnHeight = columnHeight;
        }
    }*/
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
