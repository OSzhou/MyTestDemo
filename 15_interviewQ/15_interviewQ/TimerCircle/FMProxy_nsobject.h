//
//  FMProxy_nsobject.h
//  15_interviewQ
//
//  Created by Zhouheng on 2019/5/13.
//  Copyright © 2019年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FMProxy_nsobject : NSObject

+(instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
