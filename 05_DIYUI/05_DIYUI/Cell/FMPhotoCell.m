//
//  FMPhotoCell.m
//  05_DIYUI
//
//  Created by Windy on 2016/11/22.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMPhotoCell.h"

@implementation FMPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imageView.layer.borderWidth = 10;
}

@end
