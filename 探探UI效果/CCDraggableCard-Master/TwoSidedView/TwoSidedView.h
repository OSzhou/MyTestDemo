//
//  TwoSidedView.h
//  TwoSidedView
//
//  Created by 蔡强 on 2017/12/12.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoSidedView : UIView

/** 顶部view */
@property (nonatomic, strong) UIView *topView;
/** 底部view */
@property (nonatomic, strong) UIView *bottomView;

/**
 翻转

 @param duration 翻转动画所需时间
 @param completion 动画结束后的回调
 */
- (void)turnWithDuration:(NSTimeInterval)duration completion:(void(^)(void))completion;

@end
