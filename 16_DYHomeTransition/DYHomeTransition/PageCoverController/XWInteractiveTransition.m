//
//  XWInteractiveTransition.m
//  XWTrasitionPractice
//
//  Created by YouLoft_MacMini on 15/11/24.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import "XWInteractiveTransition.h"

@interface XWInteractiveTransition ()

@property (nonatomic, weak) UIViewController *vc;
/**手势方向*/
@property (nonatomic, assign) XWInteractiveTransitionGestureDirection direction;
/**手势类型*/
@property (nonatomic, assign) XWInteractiveTransitionType type;
/** push方向是左还是右 */
@property (nonatomic, assign) BOOL isLeft;
/** 同一次交互中是否改变了手势的方向 */
@property (nonatomic, assign) CGFloat preDistance;
@end

@implementation XWInteractiveTransition

+ (instancetype)interactiveTransitionWithTransitionType:(XWInteractiveTransitionType)type GestureDirection:(XWInteractiveTransitionGestureDirection)direction{
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(XWInteractiveTransitionType)type GestureDirection:(XWInteractiveTransitionGestureDirection)direction{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
        _preDistance = -1000;
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    //手势百分比
    CGFloat percent = 0;
    CGPoint translation = [panGesture translationInView:panGesture.view];
//    NSLog(@" 实际方向 --- %.2f", translation.x);
//    NSLog(@" 接收方向 --- %zd", _direction);
    switch (_direction) {
        case XWInteractiveTransitionGestureDirectionLeft:{
            /** locationInView:获取到的是手指点击屏幕实时的坐标点；
             translationInView：获取到的是手指移动后，在相对坐标中的偏移量 */
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            if (translation.x < 0) {
                percent = fabs(transitionX) / panGesture.view.frame.size.width;
            } else {
                percent = 0;
            }
        }
            break;
        case XWInteractiveTransitionGestureDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            if (translation.x > 0) {
                percent = fabs(transitionX) / panGesture.view.frame.size.width;
            } else {
                percent = 0;
            }
        }
            break;
        case XWInteractiveTransitionGestureDirectionUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            if (translation.y < 0) {
                percent = transitionY / panGesture.view.frame.size.width;
            } else {
                percent = 0;
            }
        }
            break;
        case XWInteractiveTransitionGestureDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            if (translation.y > 0) {
                percent = transitionY / panGesture.view.frame.size.width;
            } else {
                percent = 0;
            }
        }
            break;
            // Mine
        case XWInteractiveTransitionGestureDirectionLeftAndRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            _isLeft = transitionX > 0 ? NO : YES;
            if (_preDistance == -1000) {
                _preDistance = transitionX;
            } else {
                if (_preDistance < 0 && transitionX < 0) {
                    percent = fabs(transitionX) / panGesture.view.frame.size.width;
                } else if (_preDistance > 0 && transitionX > 0) {
                    percent = fabs(transitionX) / panGesture.view.frame.size.width;
                } else {
                    percent = 0;
                }
            }
        }
            break;
        default:
            break;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            self.interation = NO;
            if (percent > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            _preDistance = -1000;
            break;
        }
        default:
            break;
    }
}

- (void)startGesture{
    switch (_type) {
        case XWInteractiveTransitionTypePresent:{
            !_presentConifg ?: _presentConifg();
        }
            break;
        case XWInteractiveTransitionTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        case XWInteractiveTransitionTypePush:{
            // 原来自带的push接口
            !_pushConifg ?: _pushConifg();
            if (_isLeft) {
                !_left_pushConifg?:_left_pushConifg();
            } else {
                !_right_pushConifg?:_right_pushConifg();
            }
        }
            break;
        case XWInteractiveTransitionTypePop:
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
    }
}
@end
