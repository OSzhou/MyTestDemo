//
//  FMRuntimeTest.m
//  StretchImageTest
//
//  Created by Windy on 2016/11/16.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMRuntimeTest.h"
#import <objc/runtime.h>

@interface FMRuntimeTest ()
{
    NSString *_str;
    NSTimer *_timer;
    UILabel *_label;
}
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FMRuntimeTest

- (void)printAllIvarAndProperty {
    unsigned int v_count;
    unsigned int p_count;
    Ivar *ivars = class_copyIvarList(objc_getClass([NSStringFromClass([self class]) UTF8String]), &v_count);
    for (int i = 0; i < v_count; i++) {
        NSString *ivarName = @(ivar_getName(ivars[i]));
        NSLog(@"Ivars --- %@",ivarName);
    }
    objc_property_t *propertys = class_copyPropertyList(objc_getClass([NSStringFromClass([self class]) UTF8String]), &p_count);
    for (int i = 0; i < p_count; i++) {
        NSString *property = @(property_getName(propertys[i]));
        NSLog(@"Property --- %@", property);
    }
}

@end
