//
//  CustomCardView.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CustomCardView.h"

@interface CustomCardView ()

@property (nonatomic, strong) UIView *containerView;

@property (strong, nonatomic) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;
@property (strong, nonatomic) UILabel     *titleLabel;

@end

@implementation CustomCardView
 
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadComponent];
    }
    return self;
}

- (void)loadComponent {
    self.containerView = [UIView new];
    self.topImageView = [[UIImageView alloc] init];
    self.bottomImageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.twoSidedView = [[TwoSidedView alloc] init];
    
//    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.topImageView.layer setMasksToBounds:YES];
//
//    self.bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.bottomImageView.layer setMasksToBounds:YES];
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_containerView];
    
    [_containerView addSubview:self.titleLabel];
    [_containerView addSubview:self.twoSidedView];
    
    self.backgroundColor = [UIColor colorWithRed:0.951 green:0.951 blue:0.951 alpha:1.00];
    
    _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"funny"]];
    
    _bottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nice"]];
    
    // 设置topView
    self.twoSidedView.topView = _topImageView;
    // 设置bottomView
    self.twoSidedView.bottomView = _bottomImageView;
    
}

- (void)cc_layoutSubviews  {
    self.containerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.twoSidedView.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64);
    self.topImageView.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64);
    self.bottomImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64);
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height - 64, self.frame.size.width, 64);
}

- (void)installData:(NSDictionary *)element {
//    self.topImageView.image  = [UIImage imageNamed:element[@"image"]];
//    self.topImageView.transform = CGAffineTransformIdentity;
    self.titleLabel.text = element[@"title"];
    self.titleLabel.transform = CGAffineTransformIdentity;
//    [self performSelector:@selector(turnAround) withObject:nil afterDelay:1];
}

- (void)turnAround {
    [self.twoSidedView turnWithDuration:2 completion:^{
        NSLog(@"翻转完成");
    }];
}

@end
