//
//  YLRatingView.h
//  MingYiPro
//
//  Created by  haole on 14-7-1.
//  Copyright (c) 2014年  haole. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickCallBack)(NSInteger value);

@interface YLRatingView : UIView
/** 选中的图片 */
@property (nonatomic, strong) NSString *selectedImageName;
/** 非选中图片 */
@property (nonatomic, strong) NSString *unSelectedImageName;
/** 评分 */
@property (nonatomic, assign) CGFloat value;
/** 最大个数 */
@property (nonatomic, assign) NSInteger maxValue;
/** 星星的大小 */
@property (nonatomic, assign) CGFloat rateSize;
/** 星星间的距离 */
@property (nonatomic, assign) CGFloat gapWith;
/** 点击的回调事件 */
@property (nonatomic, copy) ClickCallBack rateEndBlock;

- (id)initWithFrame:(CGRect)frame
  selectedImageName:(NSString *)selectedImage
    unSelectedImage:(NSString *)unSelectedImage MaxValue:(NSInteger)max
              Value:(CGFloat)value;

@end
