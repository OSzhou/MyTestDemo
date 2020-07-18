//
//  FMLineLayout.m
//  05_DIYUI
//
//  Created by Windy on 2016/11/22.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMLineLayout.h"

@implementation FMLineLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        CGFloat relative = ABS(attrs.center.x - centerX);
        CGFloat scale = 1 - relative / self.collectionView.frame.size.width;
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    // 获取rect这个范围内，可视的item有几个
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    NSLog(@"111 --- %ld proposedContentOffset.x --- %f", (long)array.count, proposedContentOffset.x);
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    CGFloat minRelative = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minRelative) > ABS(attrs.center.x - centerX)) {
            minRelative = attrs.center.x - centerX;
        }
    }
//    NSLog(@"minRelative --- %f", minRelative);
    proposedContentOffset.x += minRelative;
    return proposedContentOffset;
}

@end
