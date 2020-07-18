//
//  PopoverPresentViewController.m
//  StretchImageTest
//
//  Created by Windy on 2016/11/22.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "PopoverPresentViewController.h"

@interface PopoverPresentViewController ()

@property (nonatomic, strong) UIView *coverView;

@end

@implementation PopoverPresentViewController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    return [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
}

- (void)containerViewWillLayoutSubviews {
    if (CGRectEqualToRect(_presentFrame, CGRectZero)) {
        self.presentedView.frame = CGRectMake(100, 56, 200, 200);
    } else {
        self.presentedView.frame = _presentFrame;
    }
    [self.containerView insertSubview:self.coverView atIndex:0];
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}

- (void)tapGesture {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
