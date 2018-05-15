//
//  FMLeftToRightCoverTransition.h
//  DYHomeTransition
//
//  Created by Smile on 14/05/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XWPageCoverTransitionType) {
    XWPageCoverTransitionTypePush = 0,
    XWPageCoverTransitionTypePop
};

@interface FMLeftToRightCoverTransition : NSObject<UIViewControllerAnimatedTransitioning>
/**
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) XWPageCoverTransitionType type;
/**
 *  初始化动画过渡代理
 * @prama type 初始化pop还是push的代理
 */
+ (instancetype)transitionWithType:(XWPageCoverTransitionType)type;
- (instancetype)initWithTransitionType:(XWPageCoverTransitionType)type;
@end
