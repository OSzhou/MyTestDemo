//
//  CCDraggableCardView.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/6.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CCDraggableConfig.h"
#import "TwoSidedView.h"

@interface CCDraggableCardView : UIView

@property (nonatomic) CGAffineTransform originalTransform;

@property (nonatomic, strong) TwoSidedView *twoSidedView;

- (void)cc_layoutSubviews;

@end
