//
//  HttpRequestTool.h
//  11_图片批量上传
//
//  Created by Windy on 2017/5/24.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestTool : NSObject

// GET请求
+ (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(NSDictionary * dictionary))success
                 failure:(void (^)(NSError * error))failure;


// POST请求
+ (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure;

// 上传图片
+ (void)uploadWithURLString:(NSString *)URLString
                 parameters:(id)parameters
                 uploadData:(NSData *)uploadData
                 uploadName:(NSString *)uploadName
                    success:(void (^)())success
                    failure:(void (^)(NSError *))failure;

// 上传多张图片
+ (void)uploadMostImageWithURLString:(NSString *)URLString
                          parameters:(id)parameters
                         uploadDatas:(NSArray *)uploadDatas
                          uploadName:(NSString *)uploadName
                             success:(void (^)())success
                             failure:(void (^)(NSError *))failure;

@end
