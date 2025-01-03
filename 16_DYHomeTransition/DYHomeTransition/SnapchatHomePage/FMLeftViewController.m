//
//  FMLeftViewController.m
//  DYHomeTransition
//
//  Created by Zhouheng on 2019/1/17.
//  Copyright © 2019年 Smile. All rights reserved.
//

#import "FMLeftViewController.h"
#import "FMCentralInteractiveTransition.h"
#import "FMLToRTransition.h"
#import "Masonry.h"
@interface FMLeftViewController ()

@property (nonatomic, strong) FMCentralInteractiveTransition *interactiveTransitionPop;
@property (nonatomic, assign) UINavigationControllerOperation operation;

@end

@implementation FMLeftViewController

- (void)dealloc{
    NSLog(@"翻页效果 被推出页面 --- 销毁了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"翻页效果";
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zrx4.jpg"]];
//    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
//    [self gestureTest];
}

- (void)gestureTest {
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:pan];
    
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftViewController:gesture:)]) {
        [self.delegate leftViewController:self gesture:gesture];
    }
    
}

- (void)transitionAnimation {
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
    _interactiveTransitionPop = [FMCentralInteractiveTransition interactiveTransitionWithTransitionType:XWInteractiveTransitionTypePop GestureDirection:XWInteractiveTransitionGestureDirectionLeft];
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
    return [FMLToRTransition transitionWithType:operation == UINavigationControllerOperationPush ? XWPageCoverTransitionTypePush : XWPageCoverTransitionTypePop];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if (_operation == UINavigationControllerOperationPush) {
        FMCentralInteractiveTransition *interactiveTransitionPush = [_delegate fm_interactiveTransitionForPush];
        NSLog(@"222 ---");
        return interactiveTransitionPush.interation ? interactiveTransitionPush : nil;
    }else{
        NSLog(@"333 ---");
        return _interactiveTransitionPop.interation ? _interactiveTransitionPop : nil;
    }
}


@end
