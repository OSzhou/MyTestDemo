//
//  FMNavView.h
//  SenyintCollegeStudent
//
//  Created by Windy on 2017/1/20.
//  Copyright © 2017年 任亚丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMNavView : UIView

@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, copy) void (^backBtnBlock)(UIButton *);
@property (nonatomic, copy) void (^catalogBtnBlock)(UIButton *);

- (instancetype)initWithContentTitle:(NSString *)topic buttonTitle:(NSString *)title;

@end
