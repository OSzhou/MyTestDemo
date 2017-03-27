//
//  UIImage+Circle.h
//  StretchImageTest
//
//  Created by Windy on 2017/3/27.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Circle)
/**
 * image: 图片  borderWidth：边框宽  color：边框颜色
 */
+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;
/**
 * image: 图片 inset:距离imageView的内切距
 */
+ (UIImage *)circleImage:(UIImage*)image withParam:(CGFloat)inset borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;
/**
 * 只给图片加边框
 */
+ (UIImage *)createBorderImage:(UIImage *)img withBorderColor:(UIColor *)color WithWidth:(CGFloat)width;
@end
