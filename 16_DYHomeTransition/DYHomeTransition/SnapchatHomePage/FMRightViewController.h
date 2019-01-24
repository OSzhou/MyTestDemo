//
//  FMRightViewController.h
//  DYHomeTransition
//
//  Created by Zhouheng on 2019/1/17.
//  Copyright © 2019年 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMContainerViewController.h"

@protocol XWPageCoverPushControllerDelegate <NSObject>

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPush;

@end

NS_ASSUME_NONNULL_BEGIN

@interface FMRightViewController : FMContainerViewController<UINavigationControllerDelegate>

@property (nonatomic, assign) id<XWPageCoverPushControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
