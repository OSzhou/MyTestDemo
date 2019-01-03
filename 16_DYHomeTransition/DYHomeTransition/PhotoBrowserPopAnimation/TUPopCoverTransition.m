//
//  TUPopCoverTransition.m
//  DYHomeTransition
//
//  Created by Zhouheng on 2018/12/24.
//  Copyright © 2018年 Smile. All rights reserved.
//

#import "TUPopCoverTransition.h"
#import "UIView+anchorPoint.h"
#import "UIView+FrameChange.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

@interface TUPopCoverTransition ()
@property (nonatomic, assign, getter=isPopInitialized) BOOL popInitialized;
@property (nonatomic, assign) BOOL reverse;
@end

@implementation TUPopCoverTransition

+ (instancetype)transitionWithType:(TUPageCoverTransitionType)type{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(TUPageCoverTransitionType)type{
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
        case TUPageCoverTransitionTypePush:
            self.reverse = NO;
            //            [self doPushAnimation:transitionContext];
            //            [self mine_doPushAnimation:transitionContext];
            break;
            
        case TUPageCoverTransitionTypePop:
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
    toView.frame = CGRectMake(self.reverse ? -160 : Screen_W, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    
    self.reverse ? [containerView sendSubviewToBack:toView] : [containerView bringSubviewToFront:toView];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
//        fromView.frame = CGRectMake(!self.reverse ? -160 : Screen_W, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
//        toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
        fromView.alpha = 0;
    } completion:^(BOOL finished) {
//        if ([transitionContext transitionWasCancelled]) {
//            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
//            fromView.frame = CGRectMake(0, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
//        } else {
//            // reset from- view to its original state
//            [fromView removeFromSuperview];
//            fromView.frame = CGRectMake(!self.reverse ? -160 : Screen_W, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
//            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
//        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
/*
 //对tempView做动画，避免bug;
 UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
 tempView.frame = fromVC.view.frame;
 UIView *containerView = [transitionContext containerView];
 [containerView addSubview:tempView];
 fromVC.view.hidden = YES;
 [containerView addSubview:toView];
 [containerView insertSubview:toView atIndex:0];
 */
/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //对tempView做动画，避免bug;
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromVC.view.frame;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    fromVC.view.hidden = YES;
    [containerView insertSubview:toVC.view atIndex:0];
    //动画
    [tempView setAnchorPointTo:CGPointMake(0, 0.5)];
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    containerView.layer.sublayerTransform = transfrom3d;
    //增加阴影
    CAGradientLayer *fromGradient = [CAGradientLayer layer];
    fromGradient.frame = fromVC.view.bounds;
    fromGradient.colors = @[(id)[UIColor blackColor].CGColor,
                            (id)[UIColor blackColor].CGColor];
    fromGradient.startPoint = CGPointMake(0.0, 0.5);
    fromGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *fromShadow = [[UIView alloc]initWithFrame:fromVC.view.bounds];
    fromShadow.backgroundColor = [UIColor clearColor];
    [fromShadow.layer insertSublayer:fromGradient atIndex:1];
    fromShadow.alpha = 0.0;
    [tempView addSubview:fromShadow];
    CAGradientLayer *toGradient = [CAGradientLayer layer];
    toGradient.frame = fromVC.view.bounds;
    toGradient.colors = @[(id)[UIColor blackColor].CGColor,
                          (id)[UIColor blackColor].CGColor];
    toGradient.startPoint = CGPointMake(0.0, 0.5);
    toGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *toShadow = [[UIView alloc]initWithFrame:fromVC.view.bounds];
    toShadow.backgroundColor = [UIColor clearColor];
    [toShadow.layer insertSublayer:toGradient atIndex:1];
    toShadow.alpha = 1.0;
    [toVC.view addSubview:toShadow];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        fromShadow.alpha = 1.0;
        toShadow.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            [tempView removeFromSuperview];
            fromVC.view.hidden = NO;
        }
    }];
}

- (void)mine_doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //这里的toVC即将出现的页面
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect targetRect = [transitionContext finalFrameForViewController:toVC];
    NSLog(@"push --- %@", NSStringFromCGRect(targetRect));
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //对tempView做动画，避免bug;
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromVC.view.frame;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    fromVC.view.hidden = YES;
    [containerView insertSubview:toVC.view atIndex:0];
    
    //从右到左
    tempView.frame = CGRectOffset(targetRect, [UIScreen mainScreen].bounds.size.width, 0);
    
    //    UIView * view = [transitionContext containerView];
    //    [view addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.frame = targetRect;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            
        }
        [tempView removeFromSuperview];
        fromVC.view.hidden = NO;
    }];
}

/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    //拿到push时候的
    UIView *tempView = containerView.subviews.lastObject;
    [containerView addSubview:toVC.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.layer.transform = CATransform3DIdentity;
        fromVC.view.subviews.lastObject.alpha = 1.0;
        tempView.subviews.lastObject.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
            [tempView removeFromSuperview];
            toVC.view.hidden = NO;
        }
    }];
    
}

- (void)mine_doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    //这里的destinationViewController即将出现的页面
    UIViewController * destionationViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect targetRect = [transitionContext finalFrameForViewController:destionationViewController];
    NSLog(@"pop --- %@", NSStringFromCGRect(targetRect));
    //从左到右
    fromVC.view.frame = CGRectOffset(targetRect, 2 * [UIScreen mainScreen].bounds.size.width, 0);
    //destionationViewController.view.frame = CGRectOffset(<#CGRect rect#>, <#CGFloat dx#>, <#CGFloat dy#>)
    
    UIView * view = [transitionContext containerView];
    [view addSubview:fromVC.view];
    //弹簧效果动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
        }
    }];
}

@end
