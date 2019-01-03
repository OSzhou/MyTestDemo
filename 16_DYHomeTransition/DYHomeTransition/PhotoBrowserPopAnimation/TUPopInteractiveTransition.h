//
//  TUPopInteractiveTransition.h
//  DYHomeTransition
//
//  Created by Zhouheng on 2018/12/24.
//  Copyright © 2018年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureConifg)(void);

typedef NS_ENUM(NSUInteger, TUInteractiveTransitionGestureDirection) {//手势的方向
    
    TUInteractiveTransitionGestureDirectionLeft = 0,
    TUInteractiveTransitionGestureDirectionRight,
    TUInteractiveTransitionGestureDirectionUp,
    TUInteractiveTransitionGestureDirectionDown
    
};

typedef NS_ENUM(NSUInteger, TUInteractiveTransitionType) {//手势控制哪种转场
    
    TUInteractiveTransitionTypePresent = 0,
    TUInteractiveTransitionTypeDismiss,
    TUInteractiveTransitionTypePush,
    TUInteractiveTransitionTypePop,
    
};

@interface TUPopInteractiveTransition : UIPercentDrivenInteractiveTransition

/**记录是否开始手势，判断pop操作是 手势触发 还是 返回键 触发*/
@property (nonatomic, assign) BOOL interation;

/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg presentConifg;

/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg pushConifg;

// 初始化方法
+ (instancetype)interactiveTransitionWithTransitionType:(TUInteractiveTransitionType)type GestureDirection:(TUInteractiveTransitionGestureDirection)direction;

- (instancetype)initWithTransitionType:(TUInteractiveTransitionType)type GestureDirection:(TUInteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
