//
//  UIView+Frame.m
//  SenyintCollegeStudent
//
//  Created by Windy on 16/10/14.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    
    return self.frame.size;
    
}

- (CGFloat)centetY
{
    return self.center.y;
}

- (void)setCentetY:(CGFloat)centetY
{
    CGPoint center = self.center;
    center.y = centetY;
    self.center = center;
}
- (CGFloat)centetX
{
    return self.center.x;
}
- (void)setCentetX:(CGFloat)centetX
{
    CGPoint center = self.center;
    center.x = centetX;
    self.center = center;
}
- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

+ (instancetype)viewFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


@end
