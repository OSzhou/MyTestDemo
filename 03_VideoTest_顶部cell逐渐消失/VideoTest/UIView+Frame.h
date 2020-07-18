//
//  UIView+Frame.h
//  SenyintCollegeStudent
//
//  Created by Windy on 16/10/14.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat centetX;

@property (nonatomic, assign) CGFloat centetY;
@property (nonatomic, assign) CGSize size;

+ (instancetype)viewFromXib;

@end
