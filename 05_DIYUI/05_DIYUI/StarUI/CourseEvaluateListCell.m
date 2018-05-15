//
//  CourseEvaluateListCell.m
//  SenyintCollegeStudent
//
//  Created by    任亚丽 on 16/10/12.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "CourseEvaluateListCell.h"
#import "YLRatingView.h"
@interface CourseEvaluateListCell ()
{
    __weak UIImageView *_userHeaderiv;
    __weak UILabel *_userNameLabel;
    __weak YLRatingView *_rateview;
    __weak UILabel *_evaluateLabel;
    __weak UILabel *_dateLabel;
}

@end

@implementation CourseEvaluateListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 35, 35)];
        iv.layer.borderColor = [UIColor lightGrayColor].CGColor;
        iv.layer.borderWidth = 1;
        iv.layer.cornerRadius = 35 / 2.;
        iv.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:iv];
        _userHeaderiv = iv;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 70, 20)];
        nameLabel.text = @"张三三";
        [self.contentView addSubview:nameLabel];
        _userNameLabel = nameLabel;
        
        YLRatingView *rateview = [[YLRatingView alloc] initWithFrame:CGRectMake(200, 22, 15 * 5 + 4, 15) selectedImageName:@"star_selected" unSelectedImage:@"star_normal" MaxValue:5 Value:3.50];
        rateview.userInteractionEnabled = NO;
        rateview.rateSize = 15;
        rateview.gapWith = 2;
        [self.contentView addSubview:rateview];
        _rateview = rateview;
        
        UILabel *evateLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, Screen_W - 90, 35)];
        evateLabel.font = [UIFont systemFontOfSize:14];
        evateLabel.numberOfLines = 0;
        evateLabel.text = @"老师讲的好老师讲的好老师讲的好老师讲的好老师讲的好老师讲的好";
        [self.contentView addSubview:evateLabel];
        _evaluateLabel = evateLabel;
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, 100, 14)];
        [self.contentView addSubview:dateLabel];
        _dateLabel = dateLabel;
        _dateLabel.text = @"2016-08-29";
    }
    return self;
}

@end
