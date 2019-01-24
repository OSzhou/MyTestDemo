//
//  FMMiddleViewController.m
//  DYHomeTransition
//
//  Created by Zhouheng on 2019/1/17.
//  Copyright © 2019年 Smile. All rights reserved.
//

#import "FMMiddleViewController.h"
#import "FMLeftViewController.h"
#import "FMRightViewController.h"
#import "FMCentralInteractiveTransition.h"
#import "Masonry.h"
#import "UIView+FrameChange.h"
#import "FMContainerViewController.h"

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSUInteger, FMGestureDirection) {
    
    FMGestureDirectionToLeft,
    FMGestureDirectionToRight
    
};

@interface FMMiddleViewController ()<XWPageCoverPushControllerDelegate, FMPageCoverPushControllerDelegate>

@property (nonatomic, strong) FMCentralInteractiveTransition *interactiveTransitionPush;

@property (nonatomic, strong) FMContainerViewController *leftVc;
@property (nonatomic, strong) FMContainerViewController *rightVc;
@property (nonatomic, assign) CGFloat leftStartX;
@property (nonatomic, assign) CGFloat rightStartX;
@property (nonatomic, assign) FMGestureDirection direction;

@end

@implementation FMMiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    [self gestureTest];
}

- (void)gestureTest {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:pan];
    [self.view addSubview:self.leftVc.view];
    _leftStartX = -Screen_W;
    _leftVc.view.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    [self.view addSubview:self.rightVc.view];
    _rightStartX = Screen_W;
    _rightVc.view.frame = CGRectMake(Screen_W, 0, Screen_W, Screen_H);
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    //手势百分比
    static CGFloat percent = 0;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            
            
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            CGFloat transitionX = [gesture translationInView:gesture.view].x;
            
            if (transitionX > 0) {
                NSLog(@" --- 向右");
                _direction = FMGestureDirectionToRight;
            } else {
                NSLog(@" --- 向左");
                _direction = FMGestureDirectionToLeft;
            }
            
            if (_leftVc.view.x == 0) {
                if (_direction == FMGestureDirectionToLeft) {
                    
                } else {
                    transitionX = Screen_W;
                }
            } else if (_rightVc.view.x == 0) {
                if (_direction == FMGestureDirectionToRight) {
                    
                } else {
                    transitionX = -Screen_W;
                }
            }
            
            _leftVc.view.x = _leftStartX + transitionX;
            _rightVc.view.x = _rightStartX + transitionX;
            
            percent = fabs(transitionX) / Screen_W;
            NSLog(@"percent --- %f", percent);
        }
            break;
        case UIGestureRecognizerStateEnded: {
            NSLog(@"percent --- %f", percent);
            CGFloat transitionX = 0.f;
            switch (_direction) {
                case FMGestureDirectionToLeft: {
                    if (percent >= .5) {
                        transitionX = -Screen_W;
                    }
                }
                    break;
                case FMGestureDirectionToRight: {
                    if (percent >= .5) {
                        transitionX = Screen_W;
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
            [UIView animateWithDuration:.25 animations:^{
                _leftVc.view.x = _leftStartX + transitionX;
                _rightVc.view.x = _rightStartX + transitionX;
            }];
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)leftViewController:(FMLeftViewController *)leftVc gesture:(UIPanGestureRecognizer *)gesture {
    [self panGesture:gesture];
}

- (void)transitionAnimation {
    
    self.title = @"翻页效果";
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic2.jpeg"]];
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或向左滑动push" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(74);
    }];
    _interactiveTransitionPush = [FMCentralInteractiveTransition interactiveTransitionWithTransitionType:XWInteractiveTransitionTypePush GestureDirection:XWInteractiveTransitionGestureDirectionLeftAndRight];
    typeof(self)weakSelf = self;
    //    _interactiveTransitionPush.pushConifg = ^(){
    //        [weakSelf push];
    //    };
    _interactiveTransitionPush.left_pushConifg = ^{
        [weakSelf push];
    };
    _interactiveTransitionPush.right_pushConifg = ^{
        [weakSelf rightPush];
    };
    //此处传入self.navigationController， 不传入self，因为self.view要形变，否则手势百分比算不准确；
    [_interactiveTransitionPush addPanGestureForViewController:self];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)backToRoot
{
    self.navigationController.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)push{
    
    FMRightViewController*pushVC = [FMRightViewController new];
    self.navigationController.delegate = pushVC;
    pushVC.delegate = self;
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)rightPush {
    FMLeftViewController *pushVC = [FMLeftViewController new];
    self.navigationController.delegate = pushVC;
    pushVC.delegate = self;
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPush{
    return _interactiveTransitionPush;
}

- (id<UIViewControllerInteractiveTransitioning>)fm_interactiveTransitionForPush{
    return _interactiveTransitionPush;
}

- (FMContainerViewController *)leftVc {
    if (!_leftVc) {
        _leftVc = [[FMLeftViewController alloc] init];
//        _leftVc.delegate = self;
    }
    return _leftVc;
}

- (FMContainerViewController *)rightVc {
    if (!_rightVc) {
        _rightVc = [[FMRightViewController alloc] init];
    }
    return _rightVc;
}

@end
