//
//  FMTitleHeaderView.m
//  05_DIYUI
//
//  Created by Windy on 2017/2/21.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "FMTitleHeaderView.h"
#import "FMTitleLabel.h"

@interface FMTitleHeaderView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, assign) CGFloat offSetX;
@property (nonatomic, strong) FMTitleLabel *preLabel;

@end

@implementation FMTitleHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.middleMargin = 80.f;
        self.fontSize = 20.f;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleScrollView];
}

- (void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    // 定义临时变量
    CGFloat labelH = self.frame.size.height;
    CGFloat labelX = 0;
    
    // 添加label
    for (NSInteger i = 0; i < _titleArr.count; i++) {
        FMTitleLabel *label = [[FMTitleLabel alloc] init];
        label.font = [UIFont systemFontOfSize:self.fontSize];
        label.text = _titleArr[i];
        CGRect frame = label.frame;
        frame.origin.x = labelX + self.middleMargin;
        frame.origin.y = (labelH - self.fontSize) / 2;
        label.frame = frame;
        [label sizeToFit];
        labelX += label.frame.size.width + self.middleMargin;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        label.tag = i;
        [self.titleScrollView addSubview:label];
        if (i == 0) { // 最前面的label
            label.fm_scale = 1.0;
            _preLabel = label;
        }
    }
        // 设置contentSize
    self.titleScrollView.contentSize = CGSizeMake(labelX + self.middleMargin, 0);
}

- (void)labelClick:(UITapGestureRecognizer *)tap {
    _preLabel.fm_scale = 0.0;
    NSInteger index = tap.view.tag;
    CGFloat width = self.titleScrollView.frame.size.width;
    // 让对应的顶部标题居中显示
    FMTitleLabel *label = self.titleScrollView.subviews[index];//当前正在显示的label
    label.fm_scale = 1.0;
    _preLabel = label;
    CGPoint titleOffset = self.titleScrollView.contentOffset;
    titleOffset.x = label.center.x - width * 0.5;
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.titleScrollView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
//    NSLog(@"123456 --- %f --- %f", titleOffset.x, maxTitleOffsetX);
    _offSetX = titleOffset.x;
    [self.titleScrollView setContentOffset:titleOffset animated:YES];
    
    // 让其他label回到最初的状态
//    for (FMTitleLabel *otherLabel in self.titleScrollView.subviews) {
//        if (otherLabel != label && [otherLabel isKindOfClass:[FMTitleLabel class]]) otherLabel.fm_scale = 0.0;
//    }
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = scrollView.contentOffset.x / _offSetX + 80;//float类型
    if (scale < 0 || scale > self.titleScrollView.subviews.count - 1) return;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;//整型
    FMTitleLabel *leftLabel = self.titleScrollView.subviews[leftIndex];
    if (![leftLabel isKindOfClass:[FMTitleLabel class]]) return;
    // 获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    FMTitleLabel *rightLabel = (rightIndex == self.titleScrollView.subviews.count) ? nil : self.titleScrollView.subviews[rightIndex];
    if (![rightLabel isKindOfClass:[FMTitleLabel class]]) return;
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    
    // 设置label的比例
    leftLabel.fm_scale = leftScale;
    rightLabel.fm_scale = rightScale;
}*/

- (void)layoutSubviews {
    self.titleScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark --- lazy Loading

- (UIScrollView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _titleScrollView.backgroundColor = [UIColor cyanColor];
        _titleScrollView.delegate = self;
    }
    return _titleScrollView;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
}

@end
