//
//  FMVerticalButton.h
//  05_DIYUI
//
//  Created by Windy on 2017/3/6.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMVerticalButton : UIButton

+ (instancetype)verticalButtonWithNormalImageName:(NSString *)imageName1
                                selectedImageName:(NSString *)imageName2
                                            title:(NSString *)title;

@end
