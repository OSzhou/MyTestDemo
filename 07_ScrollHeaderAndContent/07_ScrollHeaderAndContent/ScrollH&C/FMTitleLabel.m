//
//  FMTitleLabel.m
//  05_DIYUI
//
//  Created by Windy on 2017/2/21.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "FMTitleLabel.h"

@implementation FMTitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.textColor = [UIColor colorWithRed:XMGRed green:XMGGreen blue:XMGBlue alpha:1.0];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setFm_scale:(CGFloat)fm_scale {
    _fm_scale = fm_scale;
    CGFloat transformScale = 1 + fm_scale * 0.3;
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}

@end
