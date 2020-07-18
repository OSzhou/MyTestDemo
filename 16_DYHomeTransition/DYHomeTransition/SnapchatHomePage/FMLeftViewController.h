//
//  FMLeftViewController.h
//  DYHomeTransition
//
//  Created by Zhouheng on 2019/1/17.
//  Copyright © 2019年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMContainerViewController.h"
@class FMLeftViewController;

@protocol FMPageCoverPushControllerDelegate <NSObject>

- (id<UIViewControllerInteractiveTransitioning>)fm_interactiveTransitionForPush;

- (void)leftViewController:(FMLeftViewController *)leftVc gesture:(UIPanGestureRecognizer *)gesture;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FMLeftViewController : FMContainerViewController <UINavigationControllerDelegate>

@property (nonatomic, assign) id<FMPageCoverPushControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
