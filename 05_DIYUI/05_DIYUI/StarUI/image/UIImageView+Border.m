//
//  UIImageView+Border.m
//  SenyintCollegeStudent
//
//  Created by    任亚丽 on 16/10/12.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "UIImageView+Border.h"
#import <objc/runtime.h>
@implementation UIImageView (Border)

+ (void)load
{
    [super load];

    //获取对象方法
    Method sysMethod = class_getInstanceMethod([self class], @selector(setImage:));
    Method ylMethod = class_getInstanceMethod([self class], @selector(setBorderImage:));
    //  class_getClassMethod([self class], @selector()); //获取类方法
    
    //Swizzle
    method_exchangeImplementations(sysMethod, ylMethod);

}

- (void)setBorderImage:(UIImage *)image
{
    if (self.layer.borderWidth) {
        UIGraphicsBeginImageContext(self.bounds.size);
        [image drawInRect:CGRectMake(self.layer.borderWidth, self.layer.borderWidth, self.bounds.size.width - self.layer.borderWidth * 2, self.bounds.size.height - self.layer.borderWidth * 2)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [self setBorderImage:image];
    
}

@end
