//
//  UIApplication+FMExtension.h
//  05_DIYUI
//
//  Created by Windy on 2017/7/21.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (FMExtension)

/**
 *  获取正在显示的控制器
 *
 *  @return viewController
 */
- (UIViewController *)fm_activityViewController;


@end
