//
//  TUPopCoverTransition.h
//  DYHomeTransition
//
//  Created by Zhouheng on 2018/12/24.
//  Copyright © 2018年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TUPageCoverTransitionType) {
    TUPageCoverTransitionTypePush = 0,
    TUPageCoverTransitionTypePop
};

@interface TUPopCoverTransition : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) TUPageCoverTransitionType type;
/**
 *  初始化动画过渡代理
 * @prama type 初始化pop还是push的代理
 */
+ (instancetype)transitionWithType:(TUPageCoverTransitionType)type;
- (instancetype)initWithTransitionType:(TUPageCoverTransitionType)type;

@end
