//
//  FMCollegeModel.m
//  SenyintCollegeStudent_2.0
//
//  Created by Windy on 2017/3/7.
//  Copyright © 2017年 任亚丽. All rights reserved.
//

#import "FMCollegeModel.h"

@implementation FMCollegeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id",
             @"des" : @"description"};
}

@end
