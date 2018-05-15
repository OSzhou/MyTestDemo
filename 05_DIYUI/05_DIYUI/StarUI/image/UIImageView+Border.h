//
//  UIImageView+Border.h
//  SenyintCollegeStudent
//
//  Created by    任亚丽 on 16/10/12.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>
/*解决系统边框遮挡图片问题 通过runtime替换了系统setImage方法
  使用注意点是在设image之前设border
 **/
@interface UIImageView (Border)

@end
