//
//  FMBrightnessView.h
//  05_DIYUI
//
//  Created by Windy on 2017/7/21.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMBrightnessView : UIView

/** 调用单例记录播放状态是否锁定屏幕方向*/
@property (nonatomic, assign) BOOL     isLockScreen;
/** 是否允许横屏,来控制只有竖屏的状态*/
@property (nonatomic, assign) BOOL     isAllowLandscape;
@property (nonatomic, assign) BOOL     isStatusBarHidden;
/** 是否是横屏状态 */
@property (nonatomic, assign) BOOL     isLandscape;
+ (instancetype)sharedBrightnessView;

@end
