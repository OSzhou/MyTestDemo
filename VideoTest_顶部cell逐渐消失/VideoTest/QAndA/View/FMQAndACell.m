//
//  FMQAndACell.m
//  VideoTest
//
//  Created by Windy on 2016/11/7.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMQAndACell.h"
#import "FMAnswerView.h"

@interface FMQAndACell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *answerBg;


@end

@implementation FMQAndACell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    int a = arc4random_uniform(3);
    for (int i = 0; i < a; i++) {
        FMAnswerView *av = [FMAnswerView answerView];
        av.frame = CGRectMake(0, i * 100, 375, 100);
        [self.answerBg addSubview:av];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
