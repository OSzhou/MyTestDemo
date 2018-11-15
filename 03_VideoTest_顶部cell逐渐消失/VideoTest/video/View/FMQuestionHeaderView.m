//
//  FMQuestionHeaderView.m
//  SenyintCollegeStudent
//
//  Created by Windy on 2016/10/28.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "FMQuestionHeaderView.h"
#import "FMQAndAHeaderView.h"

static NSString *headerID = @"header";
@implementation FMQuestionHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView dataModel:(id)dataModel {
    FMQuestionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!header) {
        header = [[self alloc] initWithReuseIdentifier:headerID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        FMQAndAHeaderView *view = [FMQAndAHeaderView viewFromXib];
        view.frame = self.contentView.frame;
        [self.contentView addSubview:view];
    }
    return self;
}

@end
