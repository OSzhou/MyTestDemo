//
//  FMPhotoPreViewController.m
//  DYHomeTransition
//
//  Created by Zhouheng on 2018/12/24.
//  Copyright © 2018年 Smile. All rights reserved.
//

#import "FMPhotoPreViewController.h"
#import "TUPopInteractiveTransition.h"
#import "TUPopCoverTransition.h"
#import "Masonry.h"
@interface FMPhotoPreViewController () 

@property (nonatomic, strong) TUPopInteractiveTransition *interactiveTransitionPop;
@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

@implementation FMPhotoPreViewController

- (void)dealloc{
    NSLog(@"翻页效果 被推出页面 --- 销毁了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"翻页效果";
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic1.jpg"]];
    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(50, 50, 100, 100);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或向右滑动pop" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(74);
    }];
    //初始化手势过渡的代理
    _interactiveTransitionPop = [TUPopInteractiveTransition interactiveTransitionWithTransitionType:TUInteractiveTransitionTypePop GestureDirection:TUInteractiveTransitionGestureDirectionDown];
    //给当前控制器的视图添加手势
    [_interactiveTransitionPop addPanGestureForViewController:self];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    _operation = operation;
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    if (operation == UINavigationControllerOperationPush || !_interactiveTransitionPop.interation) {
        return nil;
    }
    return [TUPopCoverTransition transitionWithType:operation == UINavigationControllerOperationPush ? TUPageCoverTransitionTypePush : TUPageCoverTransitionTypePop];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if (_operation == UINavigationControllerOperationPush) {
        return nil;
    }else{
        return _interactiveTransitionPop.interation ? _interactiveTransitionPop : nil;
    }
}

@end
