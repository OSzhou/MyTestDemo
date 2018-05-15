//
//  YLRatingView.m
//  MingYiPro
//
//  Created by  haole on 14-7-1.
//  Copyright (c) 2014年  haole. All rights reserved.
//

#import "YLRatingView.h"

@implementation YLRatingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame selectedImageName:(NSString *)selectedImage unSelectedImage:(NSString *)unSelectedImage MaxValue:(NSInteger)max Value:(CGFloat)value {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedImageName = selectedImage;
        _unSelectedImageName = unSelectedImage;
        _maxValue = max;
        _value = value;
    }
    return self;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    [self reloadRate];
}

- (void)reloadRate {
    for (int i = 0; i < _maxValue; i ++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100 + i];
        if (!btn) {
            btn = [[UIButton alloc] initWithFrame:CGRectMake((_rateSize + _gapWith)*i, 0, _rateSize, _rateSize)];
            [btn setBackgroundImage:[UIImage imageNamed:_unSelectedImageName] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:_selectedImageName] forState:UIControlStateSelected];
            btn.adjustsImageWhenHighlighted = NO;
            [btn addTarget:self action:@selector(rateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + i;
            [self addSubview:btn];
        }
        if (i < _value) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
}

- (void)rateBtnClick:(UIButton *)btn {
    _value = btn.tag - 100 + 1;
    [self reloadRate];
    if (self.rateEndBlock) {
        self.rateEndBlock(_value);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.userInteractionEnabled) { //点击  评价功能
        [self reloadRate];
    } else { //展示评价 不能点击
        for (int i = 0; i < _maxValue; i ++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((_rateSize + _gapWith)*i, 0, _rateSize, _rateSize)];
            [self addSubview:iv];
            iv.image = [UIImage imageNamed:_unSelectedImageName];
            if (_value > i && _value < i + 1) {
                iv.image = [self createImageWithBgImage:iv.image andCutImage:[UIImage imageNamed:_selectedImageName] WithSize:CGSizeMake(_rateSize, _rateSize) WithValue:_value - i];
            } else {
                if (i < _value) {
                    iv.image = [UIImage imageNamed:_selectedImageName];
                }
            }
        }
    }
}

// 创建小数点星星image
- (UIImage *)createImageWithBgImage:(UIImage *)bgImg andCutImage:(UIImage *)cutImg WithSize:(CGSize)size WithValue:(CGFloat )value {
    //切图注意是以象素为基准
//    CGImageRef imageRef = CGImageCreateWithImageInRect([cutImg CGImage], CGRectMake(0, 0, cutImg.size.width * cutImg.scale * value, cutImg.size.height * cutImg.scale));
//    UIImage* cupImage = [UIImage imageWithCGImage: imageRef];
//    CGImageRelease(imageRef);

    UIGraphicsBeginImageContext(CGSizeMake(size.width * value, size.height));
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextClipToRect(context, CGRectMake(0, 0, size.width, size.height));
    [cutImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *cupImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(size);
    [bgImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [cupImage drawInRect:CGRectMake(0, 0, size.width * value, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
