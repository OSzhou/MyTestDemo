
//
//  PopoverAnimator.m
//  StretchImageTest
//
//  Created by Windy on 2016/11/22.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "PopoverAnimator.h"
#import "PopoverPresentViewController.h"

@interface PopoverAnimator () 
/** 记录是否展开 */
@property (nonatomic, assign) BOOL isPresent;

@end

@implementation PopoverAnimator

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    PopoverPresentViewController *pv = [[PopoverPresentViewController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    pv.presentFrame = _presentFrame;
    return pv;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    _isPresent = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:FMPopoverAnimatorWillShow object:self];
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _isPresent = NO;
     [[NSNotificationCenter defaultCenter] postNotificationName:FMPopoverAnimatorWillDismiss object:self];
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_isPresent) {
        NSLog(@"展开");
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0);
        UIView *container = [transitionContext containerView];
        [container addSubview:toView];
        toView.layer.anchorPoint = CGPointMake(0.5, 0.0);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        NSLog(@"关闭");
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.000001);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end