//
//  FMCollegeModel.h
//  SenyintCollegeStudent_2.0
//
//  Created by Windy on 2017/3/7.
//  Copyright © 2017年 任亚丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMCollegeModel : NSObject

/** 背景图片 */
@property (nonatomic, copy) NSString *backgroundImage;
/** 医院描述 */
@property (nonatomic, copy) NSString *des;
/** 完成课程数 */
@property (nonatomic, assign) NSInteger finishedCourseCount;
/** 医院id */
@property (nonatomic, assign) NSInteger hospitalId;
/** 医院图片 */
@property (nonatomic, copy) NSString *hospitalImage;
/** 医院名称 */
@property (nonatomic, copy) NSString *hospitalName;
/** id */
@property (nonatomic, assign) NSInteger ID;
/** 学院名称 */
@property (nonatomic, copy) NSString *name;
/** 评分 */
@property (nonatomic, assign) CGFloat score;
/** 学员数 */
@property (nonatomic, assign) NSInteger studentCount;

@end
