//
//  FMQAndAHeaderView.m
//  SenyintCollegeStudent
//
//  Created by Windy on 2016/10/28.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "FMQAndAHeaderView.h"

@interface FMQAndAHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation FMQAndAHeaderView

+ (instancetype)viewFromXib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:kNilOptions] lastObject];
}

@end
