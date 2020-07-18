//
//  FMLeftCoverPushViewController.m
//  DYHomeTransition
//
//  Created by Smile on 14/05/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "FMLeftCoverPushViewController.h"
#import "XWInteractiveTransition.h"
#import "FMLeftToRightCoverTransition.h"
#import "Masonry.h"

@interface FMLeftCoverPushViewController ()
@property (nonatomic, strong) XWInteractiveTransition *interactiveTransitionPop;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@end

@implementation FMLeftCoverPushViewController

- (void)dealloc{
    NSLog(@"翻页效果 被推出页面 --- 销毁了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"翻页效果";
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zrx4.jpg"]];
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
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
    _interactiveTransitionPop = [XWInteractiveTransition interactiveTransitionWithTransitionType:XWInteractiveTransitionTypePop GestureDirection:XWInteractiveTransitionGestureDirectionLeft];
    //给当前控制器的视图添加手势
    [_interactiveTransitionPop addPanGestureForViewController:self];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    _operation = operation;
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    NSLog(@"111 ---");
    return [FMLeftToRightCoverTransition transitionWithType:operation == UINavigationControllerOperationPush ? XWPageCoverTransitionTypePush : XWPageCoverTransitionTypePop];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if (_operation == UINavigationControllerOperationPush) {
        XWInteractiveTransition *interactiveTransitionPush = [_delegate fm_interactiveTransitionForPush];
        NSLog(@"222 ---");
        return interactiveTransitionPush.interation ? interactiveTransitionPush : nil;
    }else{
        NSLog(@"333 ---");
        return _interactiveTransitionPop.interation ? _interactiveTransitionPop : nil;
    }
}


@end
