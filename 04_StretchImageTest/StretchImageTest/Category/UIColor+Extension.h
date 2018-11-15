//
//  UIColor+Extension.h
//  StretchImageTest
//
//  Created by Windy on 2017/3/29.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
