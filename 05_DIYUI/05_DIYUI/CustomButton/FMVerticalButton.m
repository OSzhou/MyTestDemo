//
//  FMVerticalButton.m
//  05_DIYUI
//
//  Created by Windy on 2017/3/6.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "FMVerticalButton.h"

@implementation FMVerticalButton

+ (instancetype)verticalButtonWithNormalImageName:(NSString *)imageName1
                                selectedImageName:(NSString *)imageName2
                                            title:(NSString *)title {
    FMVerticalButton *btn = [[FMVerticalButton alloc] init];
    if (imageName1 && ![imageName1 isEqualToString:@""]) {
        [btn setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
    }
    if (imageName2 && ![imageName2 isEqualToString:@""]) {
        [btn setImage:[UIImage imageNamed:imageName2] forState:UIControlStateSelected];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btn;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btn_w = self.frame.size.width;
    CGFloat btn_h = self.frame.size.height;
    CGFloat image_h = btn_h - 15;
    self.imageView.frame = CGRectMake(0, 0, btn_w, image_h);
    self.titleLabel.frame = CGRectMake(0, image_h, btn_w, btn_h - image_h);
}

@end
