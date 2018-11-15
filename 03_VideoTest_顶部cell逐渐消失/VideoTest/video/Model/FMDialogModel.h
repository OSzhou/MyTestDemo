//
//  FMDialogModel.h
//  SenyintCollegeStudent
//
//  Created by Windy on 2016/10/25.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

typedef NS_ENUM(NSInteger, NSContentType) {
    NS_CONTENT_TYPE_CHAT,//默认从0开始
    NS_CONTENT_TYPE_QA_QUESTION,
    NS_CONTENT_TYPE_QA_ANSWER,
};
@interface FMDialogModel : NSObject

/**
 *  对话数组
 *  time      NSInteger 对话时间
 *  content   NSString  内容
 *  username  NSString  用户名
 *  viewerId  NSString  观看者ID
 *  dataType  NSString  (@"1" 自己,@"2" 别人)
 */

/**
 *  问答数组
 *  time      NSInteger 对话时间
 *  content   NSString  内容
 *  username  NSString  用户名
 *  encryptId NSString  问答ID
 *  dataType  NSString  (@"1" 提问,@"2" 回答)
 */

/** 内容 */
@property(nonatomic,strong) NSString        *content;
/** 用户名 */
@property(nonatomic,strong) NSString        *username;
/** 观看者ID */
@property(nonatomic,strong) NSString        *viewerId;
/** 问答ID */
@property(nonatomic,strong) NSString        *encryptId;
/** 是否是公聊 */
@property(nonatomic,assign) BOOL            isPublicChat;
/** 头像 */
@property(nonatomic,strong) NSString        *avatar;
/** 对话类型：0：聊天 1：提问 2：回答 */
@property(nonatomic,assign) NSContentType   dataType;

/** 辅助属性 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/** 转化后的富文本聊天记录 */
@property (nonatomic, strong) NSMutableAttributedString *attrContent;

@end
