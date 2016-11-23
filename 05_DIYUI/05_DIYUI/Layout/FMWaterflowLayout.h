//
//  FMWaterflowLayout.h
//  05_DIYUI
//
//  Created by Windy on 2016/11/23.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMWaterflowLayout;
@protocol FMWaterflowLayoutDelegate <NSObject>

@required
- (CGFloat)waterflowLayout:(FMWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (NSInteger)columnCountInWaterflowLayout:(FMWaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(FMWaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(FMWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(FMWaterflowLayout *)waterflowLayout;

@end
@interface FMWaterflowLayout : UICollectionViewLayout

@property (nonatomic, weak) id <FMWaterflowLayoutDelegate> delegate;

@end
