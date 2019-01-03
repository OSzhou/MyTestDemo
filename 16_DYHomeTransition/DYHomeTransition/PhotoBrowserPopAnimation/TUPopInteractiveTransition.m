//
//  TUPopInteractiveTransition.m
//  DYHomeTransition
//
//  Created by Zhouheng on 2018/12/24.
//  Copyright © 2018年 Smile. All rights reserved.
//

#import "TUPopInteractiveTransition.h"

@interface TUPopInteractiveTransition ()
/** 被推出的控制器 */
@property (nonatomic, weak) UIViewController *vc;
/**手势方向*/
@property (nonatomic, assign) TUInteractiveTransitionGestureDirection direction;
/**手势类型*/
@property (nonatomic, assign) TUInteractiveTransitionType type;
/** 同一次交互中是否改变了手势的方向 */
@property (nonatomic, assign) CGFloat preDistance;

@end

@implementation TUPopInteractiveTransition

+ (instancetype)interactiveTransitionWithTransitionType:(TUInteractiveTransitionType)type GestureDirection:(TUInteractiveTransitionGestureDirection)direction{
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(TUInteractiveTransitionType)type GestureDirection:(TUInteractiveTransitionGestureDirection)direction{
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
    /** locationInView:获取到的是手指点击屏幕实时的坐标点；
     translationInView：获取到的是手指移动后，在相对坐标中的偏移量 */
    CGPoint translation = [panGesture translationInView:panGesture.view];
    
    switch (_direction) {
        case TUInteractiveTransitionGestureDirectionLeft:{
            
            if (translation.x < 0) {
                percent = fabs(translation.x) / panGesture.view.frame.size.width;
            } else {
                percent = 0;
            }
            
        }
            break;
        case TUInteractiveTransitionGestureDirectionRight:{
            
            if (translation.x > 0) {
                percent = fabs(translation.x) / panGesture.view.frame.size.width;
            } else {
                percent = 0;
            }
            
        }
            break;
        case TUInteractiveTransitionGestureDirectionUp:{
            
            if (translation.y < 0) {
                percent = fabs(translation.y) / panGesture.view.frame.size.width;
            } else {
                percent = 0;
            }
            
        }
            break;
        case TUInteractiveTransitionGestureDirectionDown:{
            NSLog(@" translation.y --- %f", translation.y);
            if (translation.y > 0) {
                percent = fabs(translation.y) / panGesture.view.frame.size.width;
            } else {
                percent = 0;
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
        case TUInteractiveTransitionTypePresent:{
            !_presentConifg ?: _presentConifg();
        }
            break;
        case TUInteractiveTransitionTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        case TUInteractiveTransitionTypePush:{
           
            !_pushConifg ?: _pushConifg();
            
        }
            break;
        case TUInteractiveTransitionTypePop:
            
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
    }
}

@end
