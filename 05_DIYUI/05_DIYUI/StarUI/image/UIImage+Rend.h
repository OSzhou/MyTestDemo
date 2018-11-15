//
//  UIImage+Rend.h
//  SenyintCollegeStudent
//
//  Created by    任亚丽 on 16/9/2.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rend)
#pragma mark ===创建边框图片
// 创建带边框图片
+ (UIImage *)createBorderImage:(UIImage *)img withSize:(CGSize)size WithBorderColor:(UIColor *)color WithWidth:(CGFloat)width;

// 创建带边框图片
- (UIImage *)createBorderImageWithSize:(CGSize)size WithBorderColor:(UIColor *)color WithWidth:(CGFloat)width;

#pragma mark ===调整图片大小
//按比例调整图片大小
- (UIImage*)imageScale:(CGFloat)scale;

//调整图片为指定大小
- (UIImage*)scaleToSize:(CGSize)size;

//调整图片为指定大小
+ (UIImage *)image:(UIImage *)img scaleToSize:(CGSize)size;

#pragma mark ===创建背景图片
// 创建size为1的指定颜色的image
+ (UIImage *)createImageWithColor:(UIColor *)color;

// 创建指定大小，指定颜色的image
+ (UIImage *)createImageColor:(UIColor *)color WithSize:(CGSize) size;

// 创建指定大小，指定颜色的image 并写入相册
+ (void )createAndSaveImageColor:(UIColor *)color WithSize:(CGSize) size;


#pragma mark ===截图
// 载取view指定范围的Image
+ (UIImage *)captureView:(UIView *)view withFrame:(CGRect)rect;

// 载取view指定范围的Image并存到相册
+ (UIImage *)captureViewAndSaveImage:(UIView *)view withFrame:(CGRect)rect;

@end
