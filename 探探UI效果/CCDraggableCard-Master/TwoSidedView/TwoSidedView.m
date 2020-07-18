//
//  TwoSidedView.m
//  TwoSidedView
//
//  Created by 蔡强 on 2017/12/12.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "TwoSidedView.h"

@implementation TwoSidedView {
    BOOL _isTurning;  // 是否正在翻转
    BOOL _isReversed; // 是否反面朝上
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isTurning  = NO;
        _isReversed = NO;
    }
    return self;
}

/** 设置顶部view */
- (void)setTopView:(UIView *)topView {
    _topView = topView;
    
    [self addSubview:_topView];
    [self bringSubviewToFront:_topView];
}

/** 设置底部view */
- (void)setBottomView:(UIView *)bottomView {
    _bottomView = bottomView;
    
    [self addSubview:_bottomView];
    [self sendSubviewToBack:_bottomView];
}

/**
 翻转
 
 @param duration 翻转动画所需时间
 @param completion 动画结束后的回调
 */
- (void)turnWithDuration:(NSTimeInterval)duration completion:(void(^)(void))completion{
    if (!self.topView || !self.bottomView) {
        NSAssert(NO, @"未设置topView或bottomView");
    }
    
    // 正在动画中不能重复执行
    if (_isTurning) {
        return;
    }
    
    _isTurning = YES;
    
    if (_isReversed) { // 此时反面朝上
        // 从反面翻转到正面
        [UIView transitionFromView:self.bottomView toView:self.topView duration:duration options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            !completion ?: completion();
            _isTurning  = NO;
            _isReversed = NO;
        }];
    } else { // 此时正面朝上
        // 从正面翻转到反面
        [UIView transitionFromView:self.topView toView:self.bottomView duration:duration options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            !completion ?: completion();
            _isTurning  = NO;
            _isReversed = YES;
        }];
    }
}

@end
