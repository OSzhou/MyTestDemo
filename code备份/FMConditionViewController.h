//
//  FMConditionViewController.h
//  SenyintCollegeStudent_2.0
//
//  Created by Windy on 2017/3/24.
//  Copyright © 2017年 任亚丽. All rights reserved.
//

#import "SCBaseViewController.h"

@interface FMConditionViewController : SCBaseViewController

@property (nonatomic, assign) BOOL leftSlideEnable;

@property (nonatomic, assign) CGSize bounds;

- (void)addViewToKeyWindow;
- (void)filterViewShow;

@end
