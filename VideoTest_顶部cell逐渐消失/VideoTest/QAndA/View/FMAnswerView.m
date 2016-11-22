//
//  FMAnswerView.m
//  VideoTest
//
//  Created by Windy on 2016/11/7.
//  Copyright © 2016年 Windy. All rights reserved.
//

#import "FMAnswerView.h"

@implementation FMAnswerView

//- (instancetype)init {
//    if (self = [super init]) {
//        <#statements#>
//    }
//}

+ (instancetype)answerView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

@end
