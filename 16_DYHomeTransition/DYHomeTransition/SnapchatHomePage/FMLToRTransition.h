//
//  FMLToRTransition.h
//  DYHomeTransition
//
//  Created by Zhouheng on 2019/1/18.
//  Copyright © 2019年 Smile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XWPageCoverTransitionType) {
    XWPageCoverTransitionTypePush = 0,
    XWPageCoverTransitionTypePop
};

NS_ASSUME_NONNULL_BEGIN

@interface FMLToRTransition : NSObject<UIViewControllerAnimatedTransitioning>

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

NS_ASSUME_NONNULL_END
