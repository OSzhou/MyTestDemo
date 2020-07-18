//
//  PopoverAnimator.h
//  StretchImageTest
//
//  Created by Windy on 2016/11/22.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PopoverAnimator : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
/** rect */
@property (nonatomic, assign) CGRect presentFrame;
@end

/** 
    自定义转场动画的步骤：
    1.继承于NSObject并遵循<相应><代理>的animator类，决定动画如何执行
        UIViewControllerTransitioningDelegate代理可以放在推出的页面内，也可以是被推出的页面内
        但是都不好，最好放在animator里，这样代码的耦合性低，便于复用。
    2.继承于UIPresentationController的viewController，决定谁去执行动画
    3.被推出的页面
 */
