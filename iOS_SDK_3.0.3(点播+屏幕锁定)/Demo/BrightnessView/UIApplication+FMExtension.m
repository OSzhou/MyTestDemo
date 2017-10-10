//
//  UIApplication+FMExtension.m
//  05_DIYUI
//
//  Created by Windy on 2017/7/21.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "UIApplication+FMExtension.h"

@implementation UIApplication (FMExtension)

- (UIViewController *)fm_activityViewController {
    __block UIWindow *normalWindow = [self.delegate window];
    if (normalWindow.windowLevel != UIWindowLevelNormal) {
        [self.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.windowLevel == UIWindowLevelNormal) {
                normalWindow = obj;
                *stop        = YES;
            }
        }];
    }
    return [self p_nextTopForViewController:normalWindow.rootViewController];
}

- (UIViewController *)p_nextTopForViewController:(UIViewController *)inViewController {
    while (inViewController.presentedViewController) {
        inViewController = inViewController.presentedViewController;
    }
    if ([inViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectController = ((UITabBarController *)inViewController).selectedViewController;
        if (selectController) {
            UIViewController *selectedVC = [self p_nextTopForViewController:selectController];
            return selectedVC;
        } else {
            return inViewController;
        }
    } else if ([inViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visibleVC = ((UINavigationController *)inViewController).visibleViewController;
        if (visibleVC) {
            UIViewController *selectedVC = [self p_nextTopForViewController:visibleVC];
            return selectedVC;
        } else {
            return inViewController;
        }
    } else {
        return inViewController;
    }
}

@end
