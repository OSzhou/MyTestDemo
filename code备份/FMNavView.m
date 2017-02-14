//
//  FMNavView.m
//  SenyintCollegeStudent
//
//  Created by Windy on 2017/1/20.
//  Copyright © 2017年 任亚丽. All rights reserved.
//

#import "FMNavView.h"

@interface FMNavView ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, strong) UIButton *catalogBtn;

@end

@implementation FMNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_RGBA(0.f, 48.f, 57.f, 0.8);
        self.frame = CGRectMake(0, 0, Screen_Width, 64);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithContentTitle:(NSString *)topic buttonTitle:(NSString *)title {
    self.topic = topic;
    self.buttonTitle = title;
    return [self initWithFrame:CGRectZero];
}

- (void)setupUI {
    [self addSubview:self.backBtn];
    [self addSubview:self.topicLabel];
    [self addSubview:self.catalogBtn];
}

- (void)layoutSubviews {
    self.backBtn.frame = CGRectMake(0, 20, 37, 44);
    self.topicLabel.frame = CGRectMake(CGRectGetMaxX(self.backBtn.frame), 35, Screen_Width / 2, 20);
    self.catalogBtn.frame = CGRectMake(self.width - 60, 20, 60, 44);
}

- (void)setTopic:(NSString *)topic {
    _topic = topic;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)backBtnClick:(UIButton *)sender {
    !_backBtnBlock ?: _backBtnBlock(sender);
}
- (UILabel *)topicLabel {
    if (!_topicLabel) {
        _topicLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topicLabel.text = _topic;
        _topicLabel.textColor = [UIColor lightGrayColor];
    }
    return _topicLabel;
}

- (UIButton *)catalogBtn {
    if (!_catalogBtn) {
        _catalogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_catalogBtn setTitle:_buttonTitle forState:UIControlStateNormal];
        [_catalogBtn setTitleColor:COLOR_RGB(253.f, 117.f, 0.f) forState:UIControlStateNormal];
        _catalogBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_catalogBtn addTarget:self action:@selector(catalogBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _catalogBtn;
}

- (void)catalogBtnClick:(UIButton *)sender {
    !_catalogBtnBlock ?: _catalogBtnBlock(sender);
}

@end
