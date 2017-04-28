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
/*
 for (int i = 0; i < 2; i ++) {
 NSString *title = i == 0 ? @"收费类型" : @"学习状态";
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 64 + i * 200, 100, 30)];
 label.text = title;
 label.textColor = [UIColor blackColor];
 [self.view addSubview:label];
 for (int j = 0; j < 2; j ++) {
 UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50 + j * 80, 114 + i * 200, 60, 25)];
 btn.backgroundColor = [UIColor lightGrayColor];
 NSString *subTitle;
 if (!i) {
 subTitle = j == 0 ? @"免费" : @"收费";
 } else {
 subTitle = j == 0 ? @"已加入" : @"未加入";
 }
 [btn setTitle:subTitle forState:UIControlStateNormal];
 [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
 [self.view addSubview:btn];
 }
 NSString *bottomTitle = i == 0 ? @"重置" : @"确定";
 UIButton *bbtn = [[UIButton alloc] initWithFrame:CGRectMake(0 + i * self.bounds.width / 2, self.bounds.height - 50, self.bounds.width / 2, 50)];
 [bbtn setTitle:bottomTitle forState:UIControlStateNormal];
 [bbtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
 [self.view addSubview:bbtn];
 }
 */
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
