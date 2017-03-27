//
//  UIImage+Circle.m
//  StretchImageTest
//
//  Created by Windy on 2017/3/27.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)

+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
    // 图片的宽度和高度
    CGFloat imageWH = image.size.width;
    
    // 设置圆环的宽度
    CGFloat border = borderWidth;
    
    // 圆形的宽度和高度
    CGFloat ovalWH = imageWH + 2 * border;
    
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);
    
    // 2.画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    
    [color set];
    
    [path fill];
    
    // 3.设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, imageWH, imageWH)];
    [clipPath addClip];
    
    // 4.绘制图片
    [image drawAtPoint:CGPointMake(border, border)];
    
    // 5.获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
    
}

+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置边线的宽度及颜色
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];

    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

@end
