//
//  FMNormalChatCell.m
//  SenyintCollegeStudent
//
//  Created by Windy on 2016/10/25.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "FMNormalChatCell.h"

@interface FMNormalChatCell ()

@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation FMNormalChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 5;
    [super setFrame:frame];
}

@end
