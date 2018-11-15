//
//  UIImage+Rend.m
//  SenyintCollegeStudent
//
//  Created by    任亚丽 on 16/9/2.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "UIImage+Rend.h"

@implementation UIImage (Rend)
#pragma mark ===创建边框图片
// 创建带边框图片
+ (UIImage *)createBorderImage:(UIImage *)img withSize:(CGSize)size WithBorderColor:(UIColor *)color WithWidth:(CGFloat)width
{
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(width / 2, width / 2, size.width - width, size.height - width));
    [color set];
    CGContextSetLineWidth(context, width);
    CGContextStrokePath(context);
    [img drawInRect:CGRectMake(width, width, size.width - width * 2, size.height - width * 2)];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

// 创建带边框图片
- (UIImage *)createBorderImageWithSize:(CGSize)size WithBorderColor:(UIColor *)color WithWidth:(CGFloat)width
{
    
    return [UIImage createBorderImage:self withSize:size WithBorderColor:color WithWidth:width];
    
//    UIGraphicsBeginImageContext(size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(context, CGRectMake(width / 2, width / 2, size.width - width, size.height - width));
//    [color set];
//    CGContextSetLineWidth(context, width);
//    CGContextStrokePath(context);
//    [self drawInRect:CGRectMake(width, width, size.width - width * 2, size.height - width * 2)];
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return theImage;
    
}

#pragma mark ===调整图片大小
//按比例调整图片大小
- (UIImage*)imageScale:(CGFloat)scale
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scale, self.size.height * scale)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//调整图片为指定大小
- (UIImage*)scaleToSize:(CGSize)size
{

    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

//调整图片为指定大小
+ (UIImage *)image:(UIImage *)img scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark ===创建背景图片
// 创建size为1的指定颜色的image
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

// 创建指定大小，指定颜色的image
+ (UIImage *)createImageColor:(UIColor *)color WithSize:(CGSize) size
{
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

// 创建指定大小，指定颜色的image 并写入相册
+ (void )createAndSaveImageColor:(UIColor *)color WithSize:(CGSize) size
{
    
    UIImage *img = [self createImageColor:color WithSize:size];
    UIImageWriteToSavedPhotosAlbum(img,nil, nil, nil);
}

#pragma mark ===截图
// 载取view指定范围的Image
+ (instancetype) captureView:(UIView *)view withFrame:(CGRect)rect
{
    UIGraphicsBeginImageContext(view.frame.size);
    UIRectClip(rect);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

// 载取view指定范围的Image并存到相册
+ (instancetype) captureViewAndSaveImage:(UIView *)view withFrame:(CGRect)rect
{
    UIImage *newImage = [self captureView:view withFrame:rect];
    UIImageWriteToSavedPhotosAlbum(newImage,nil, nil, nil);
    
    return newImage;
}

@end
