//
//  FMTimerHelper.h
//  GCD_Test
//
//  Created by Smile on 2020/12/7.
//  Copyright © 2020 tataUFO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMTimerHelper : NSObject

+ (instancetype)proxyWithTarget:(id)target;
@property (weak, nonatomic) id target;

@end

NS_ASSUME_NONNULL_END
