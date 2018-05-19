//
//  FMTestView.m
//  podTest
//
//  Created by Smile on 2018/5/19.
//  Copyright © 2018 Smile. All rights reserved.
//

#import "FMTestView.h"

@implementation FMTestView

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
