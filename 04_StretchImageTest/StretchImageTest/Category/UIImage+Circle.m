//
//  UIImage+Circle.m
//  StretchImageTest
//
//  Created by Windy on 2017/3/27.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)
/*
    set:一般和属性相关
    add:一般和路径相关
 */

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
    [image drawAtPoint:CGPointMake(border, border)];//设置绘制的坐标原点
    
    // 5.获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
    
}

+ (UIImage *)circleImage:(UIImage*)image withParam:(CGFloat)inset borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
    
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
//    UIRectClip(CGRectMake(10, 10, 80, 80));//裁剪区域（just a test code）
    [image drawInRect:rect];

    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIImage *)createBorderImage:(UIImage *)img withBorderColor:(UIColor *)color WithWidth:(CGFloat)width {
    
    CGSize size = img.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(width / 2, width / 2, size.width - width, size.height - width));
    [color set];
    CGContextSetLineWidth(context, width);
    CGContextStrokePath(context);
    [img drawInRect:CGRectMake(width, width, size.width - width * 2, size.height - width * 2)];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

@end
