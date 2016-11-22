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
