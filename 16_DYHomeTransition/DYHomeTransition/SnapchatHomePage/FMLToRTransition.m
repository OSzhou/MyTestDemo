//
//  FMLToRTransition.m
//  DYHomeTransition
//
//  Created by Zhouheng on 2019/1/18.
//  Copyright © 2019年 Smile. All rights reserved.
//

#import "FMLToRTransition.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@interface FMLToRTransition ()
@property (nonatomic, assign, getter=isPopInitialized) BOOL popInitialized;
@property (nonatomic, assign) BOOL reverse;
@end

@implementation FMLToRTransition

+ (instancetype)transitionWithType:(XWPageCoverTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XWPageCoverTransitionType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}
/**
 *  动画时长
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1;
}
/**
 *  如何执行过渡动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (_type) {
        case XWPageCoverTransitionTypePush:
            self.reverse = NO;
            //            [self doPushAnimation:transitionContext];
            //            [self mine_doPushAnimation:transitionContext];
            break;
            
        case XWPageCoverTransitionTypePop:
            self.reverse = YES;
            //            [self doPopAnimation:transitionContext];
            //            [self mine_doPopAnimation:transitionContext];
            break;
    }
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    toView.frame = CGRectMake(self.reverse ? Screen_W : -Screen_W, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    
    self.reverse ? [containerView sendSubviewToBack:toView] : [containerView bringSubviewToFront:toView];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.frame = CGRectMake(!self.reverse ? Screen_W : -Screen_W, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            fromView.frame = CGRectMake(0, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        } else {
            // reset from- view to its original state
            [fromView removeFromSuperview];
            fromView.frame = CGRectMake(!self.reverse ? Screen_W : -Screen_W, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
