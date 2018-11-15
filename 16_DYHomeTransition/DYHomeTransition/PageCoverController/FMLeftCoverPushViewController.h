//
//  FMLeftCoverPushViewController.h
//  DYHomeTransition
//
//  Created by Smile on 14/05/2018.
//  Copyright © 2018 Smile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FMPageCoverPushControllerDelegate <NSObject>

- (id<UIViewControllerInteractiveTransitioning>)fm_interactiveTransitionForPush;

@end
@interface FMLeftCoverPushViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic, assign) id<FMPageCoverPushControllerDelegate> delegate;
@end
