//
//  TUFeedLayout.h
//  tataufo
//
//  Created by 雷凯 on 2017/8/30.
//  Copyright © 2017年 tataufo. All rights reserved.
//这个类主要尝试使用预排版解决tableView卡顿问题

#import "TULayout.h"
#import "YYText.h"
#import "TUFeedAttributedModel.h"
#import "TUFeedPreferenceInfoLayout.h"
#import "TUFeedTranslateModel.h"

@interface TUFeedLayout : TULayout

@property (nonatomic, strong) TUFeedAttributedModel *feedModel;

//MARK: -发布状态的发布控件
/****************发布状态的发布控件*********************/
///发布状态的发布控件高度
@property (nonatomic, assign) CGFloat readyPushHeight;
@property (nonatomic, strong) YYTextLayout *readyPushNormalTextLayout;
@property (nonatomic, assign) CGSize readyPushNormalTextSize;
@property (nonatomic, strong) YYTextLayout *readyPushErrorTextLayout;
@property (nonatomic, assign) CGSize readyPushErrorTextSize;
/****************发布状态的发布控件*********************/

//MARK: - 用户信息区域
/*****************用户信息区域********************************/
///有用户信息
@property (nonatomic, assign) BOOL isHasUser;
///用户信息顶部的留白间距
@property (nonatomic, assign) CGFloat userTopMargin;
///用户信息区域总高度 (不含顶部留白)
@property (nonatomic, assign) CGFloat userHeight;
///用户信息文本排版
@property (nonatomic, strong) YYTextLayout *userNameTextLayout;
///关注
@property (nonatomic, strong) YYTextLayout *followTextLayout;
///推荐原因的文本排版
@property (nonatomic, strong) YYTextLayout *reasonTextLayout;
///是否已关注
@property (nonatomic, assign) BOOL isUserFollow;
///是否隐藏箭头
@property (nonatomic, assign) BOOL isArrowHidden;
///是否是需要隐藏关注的页面
@property (nonatomic, assign) BOOL isFollowHidden;
/*****************用户信息区域********************************/

//MARK: - 正文文本区
/*****************正文文本区********************************/
///正文文本区顶部间距
@property (nonatomic, assign) CGFloat contentTopMargin;
///正文排版 未展开 isContentOpenUpState == NO时用这
@property (nonatomic, strong) YYTextLayout *contentTextLayout;
///全文  已展开  isContentOpenUpState == YES时用这
@property (nonatomic, strong) YYTextLayout *allContentTextLayout;
///正文文本区总高度(不含顶部留白)
@property (nonatomic, assign) CGFloat contentHeight;
///有文本信息
@property (nonatomic, assign) BOOL isHasContent;
///是否可以展开
@property (nonatomic, assign) BOOL isCanContentOpenUp;
///当前是否是展开状态
@property (nonatomic, assign) BOOL isContentOpenUpState;
///展开
@property (nonatomic, strong) YYTextLayout *openUpTextLayout;

/*****************正文文本区********************************/

//MARK: - 图片区
/*******************图片区*******************************/
///图片区顶部间距
@property (nonatomic, assign) CGFloat photoTopMargin;
///图片区总高度
@property (nonatomic, assign) CGFloat photoHeight;
///照片需要展示的行的分隔距离
@property (nonatomic, assign) NSInteger photoRowSpacing;
///照片需要展示的列的分隔距离
@property (nonatomic, assign) NSInteger photoColumnsSpacing;
///图片数量
@property (nonatomic, assign) NSInteger photoCount;
///有图片
@property (nonatomic, assign) BOOL isHasPhoto;

///图片最大高
@property (nonatomic, assign) CGFloat photoMaxHeight;
///图片最小高
@property (nonatomic, assign) CGFloat photoMinHeight;

/// 是否是以前的贴子
@property (nonatomic, assign) BOOL isOldPhotos;
/// 上次看到第几页
@property (nonatomic, assign) NSInteger markPage;
/*******************图片区*******************************/

//MARK: - 视频&闪拍区
/*******************视频&闪拍区*******************************/
///视频&闪拍区顶部间距
@property (nonatomic, assign) CGFloat videoTopMargin;
///视频&闪拍区总高度
@property (nonatomic, assign) CGFloat videoHeight;
///视频&闪拍数量
@property (nonatomic, assign) NSInteger videoCount;
///视频&闪拍封面预览图数量
@property (nonatomic, assign) NSInteger videoPreviewImageCount;
///是否有视频
@property (nonatomic, assign) BOOL isHasVideo;
/*******************视频&闪拍区*******************************/

//MARK: - 闪聊区
/**********************闪聊区**********************************/
///闪聊区顶部间距
@property (nonatomic, assign) CGFloat flashChatTopMargin;
///闪聊区总高度
@property (nonatomic, assign) CGFloat flashChatHeight;
///闪聊名称的高度
@property (nonatomic, assign) CGFloat flashChatNameHeight;
///闪聊信息的高度
@property (nonatomic, assign) CGFloat flashChatDetailHeight;
///是否有闪聊
@property (nonatomic, assign) BOOL isHasFlashChat;
///闪聊名称的文字排版
@property (nonatomic, strong) YYTextLayout *flashChatNameTextLayout;
///闪聊详情的文字排版
@property (nonatomic, strong) YYTextLayout *flashChatDetailTextLayout;
///闪聊室id
@property (nonatomic, assign) NSInteger flashChatID;
///闪聊室图片地址
@property (nonatomic, copy) NSString *flashChatIconUrlStr;
///闪聊区背景色
@property (nonatomic, strong) UIColor *flashChatBackgroundColor;
/**********************闪聊区**********************************/

//MARK: - 音频区
/**********************音频区**********************************/
///音频区顶部间距
@property (nonatomic, assign) CGFloat audioTopMargin;
///音频区总高度
@property (nonatomic, assign) CGFloat audioHeight;
///是否有音频
@property (nonatomic, assign) BOOL isHasAudio;
///音频背景模糊样式缓存
@property (nonatomic, assign) TUFeedPreferenceInfoLayoutStyle audioLayoutStyle;
/**********************音频区**********************************/


//MARK: - 网络链接区
/**********************网络链接区**********************************/
///链接区顶部间距
@property (nonatomic, assign) CGFloat linkTopMargin;
///链接区总高度
@property (nonatomic, assign) CGFloat linkHeight;
///链接标题大小
@property (nonatomic, assign) CGSize linkTitleSize;
///是否有链接
@property (nonatomic, assign) CGFloat isHasLink;
///链接标题文本排版
@property (nonatomic, strong) YYTextLayout *linkTitleTextLayout;
/**********************网络链接区**********************************/

//MARK: - 用户更新信息区 （注册、教育、工作）
/**************用户更新信息区*******************************/
///用户更新信息顶部间距
@property (nonatomic, assign) CGFloat userUpdateInfoTopMargin;
///用户更新信息高度
@property (nonatomic, assign) CGFloat userUpdateInfoHeight;
///用户更新信息内容
@property (nonatomic, strong) YYTextLayout *userUpdateInfoContentTextLayout;

///是否有用户更新信息内容
@property (nonatomic, assign) BOOL isHasUserUpdateInfo;
/*******************用户更新信息区**************************/

//MARK: - 偏好区
/**************偏好区*******************************/
///偏好顶部间距
@property (nonatomic, assign) CGFloat preferenceTopMargin;
///偏好高度
@property (nonatomic, assign) CGFloat preferenceHeight;
///偏好组
@property (nonatomic, strong) NSMutableArray<TUFeedPreferenceInfoLayout *> *preferenceInfoLayoutArrM;
///是否有偏好
@property (nonatomic, assign) BOOL isHasPreference;
/*******************偏好区**************************/

/*** 7.0.0 -> flexible 底部的动态布局 ***/
//MARK: - 6.8从卡片顶部到正文内容区的高度 不包含正文内容区的顶部间距 (7.0->)包含toolbar和点赞
@property (nonatomic, assign) CGFloat feedContentTopHeight;
//MARK: - 从卡片顶部到点赞评论工具栏的高度 不包含点赞评论区的顶部间距
/// 评论区
@property (nonatomic, assign) CGFloat feedCommentTopHeight;
/// 时间 贴子权限等
@property (nonatomic, assign) CGFloat feedBottomTimeHeight;
/*** 7.0.0 -> flexible 底部的动态布局 ***/


/***********************从卡片顶部到点赞评论工具栏的高度 不包含点赞评论区的顶部间距********************************/
@property (nonatomic, assign) CGFloat feedInfoHeight;
/***********************从卡片顶部到点赞评论工具栏的高度 不包含点赞评论区的顶部间距********************************/

//点赞评论工具区
/***********************点赞评论工具区*******************************/
///点赞评论工具区顶部间距
@property (nonatomic, assign) CGFloat toolbarTopMargin;
///点赞评论工具区总高度
@property (nonatomic, assign) CGFloat toolbarHeight;
///是否有评论点赞这一栏 目前都有
@property (nonatomic, assign) BOOL isHasToolBar;
///点赞分享数信息
@property (nonatomic, assign) BOOL isHasToolBarInfo;
///点赞分享数信息顶部间距
@property (nonatomic, assign) CGFloat toolbarInfoTopMargin;
///点赞分享数信息高度
@property (nonatomic, assign) CGFloat toolbarInfoHeight;
///点赞数文字排版
@property (nonatomic, strong) YYTextLayout *likeCountTextLayout;
///评论数字排版
@property (nonatomic, strong) YYTextLayout *commentCountTextLayout;
/***********************点赞评论工具区*******************************/

//MARK: - 评论列表区
/*********************评论列表区*****************************/
///评论区的顶部间距
@property (nonatomic, assign) CGFloat commentTopMargin;
///评论区的总高度
@property (nonatomic, assign) CGFloat commentHeight;

///评论的排版
@property (nonatomic, strong) NSMutableArray <YYTextLayout *>*commentTextLayoutArrM;

///含昵称 回复：等信息  不包含评论内容
@property (nonatomic, strong) NSMutableArray <NSString *>*notContainCommentBodyArrM;

///是否有评论列表
@property (nonatomic, assign) BOOL isHasComment;

@property (nonatomic, assign) CGFloat moreCommentTopMargin;
///查看更多评论文本排版
@property (nonatomic, strong) YYTextLayout *moreCommentTextLayout;
/*********************评论列表区*****************************/

/*********************评论引导区*****************************/
/// 是否显示评论引导
@property (nonatomic, assign) BOOL showCommentIndicator;
///评论引导高度
@property (nonatomic, assign) CGFloat commentIndicatorHeight;

/*********************评论引导区*****************************/

//MARK: - 提示区（时间地点 && 隐私权限）
/*********************提示区 （时间地点 && 隐私权限）*******************************/
///是否需要显示 查看权限 或 时间地点
@property (nonatomic, assign) BOOL isHasPrompt;
///提示区顶部间距
@property (nonatomic, assign) CGFloat promptTopMargin;
///提示区高度
@property (nonatomic, assign) CGFloat promptHeight;
///查看权限文本排版
@property (nonatomic, strong) YYTextLayout *permitTextLayout;
///时间、地点文本排版
@property (nonatomic, strong) YYTextLayout *timeAndLocationTextLayout;
/*********************提示区 （时间地点 && 隐私权限）*******************************/

///距离底部的间距
@property (nonatomic, assign) CGFloat bottomMargin;

//MARK: - 翻译相关
/// contentView翻译结果
@property (nonatomic, copy) NSString *translateResult;
/// contentView是否正在显示翻译过的内容
@property (nonatomic, assign) BOOL isTranslated;
/// comment翻译状态
@property (nonatomic, strong) NSMutableArray <TUFeedTranslateModel *>*commentTranslationStatusArr;
/// promptView上的翻译提示
@property (nonatomic, strong) YYTextLayout *translateTextLayout;

//MARK: - 音乐区
/**********************音乐区**********************************/

///音乐区顶部间距
@property (nonatomic, assign) CGFloat musicTopMargin;
///音乐区总高度
@property (nonatomic, assign) CGFloat musicHeight;
///是否有音乐
@property (nonatomic, assign) BOOL isHasMusic;
///音乐是否正在播放
@property (nonatomic, assign) BOOL isPlaying;
///音乐是否正在下载
@property (nonatomic, assign) BOOL isLoading;

/**********************音频区**********************************/

//MARK: - 位置图片区
/**********************位置图片区*********************************/

///位置图片区顶部间距
@property (nonatomic, assign) CGFloat locationTopMargin;
///位置图片区总高度
@property (nonatomic, assign) CGFloat locationHeight;
///是否有位置图片
@property (nonatomic, assign) BOOL isHasLocation;
///地点排版
@property (nonatomic, strong) YYTextLayout *locationTextLayout;

/**********************位置图片区*********************************/

/***** ACN相关 *****/

/// 是否是近期热门 或 历史最佳 或 昨日最佳
@property (nonatomic, assign) BOOL isRecentHotOrBestReward;
/// 分享成功后通知，用来判断是否显示ACN引导
@property (nonatomic, assign) BOOL isSharedSuccess;
/// 是否有ACN 奖励label
@property (nonatomic, assign) BOOL isHasACNLabel;
/// 奖励多少ACN排版
@property (nonatomic, strong) YYTextLayout *awardACNTextLayout;
/// 奖励ACN label 距离顶部间距
@property (nonatomic, assign) CGFloat ACNTextBottomMargin;
/// 奖励ACN label
@property (nonatomic, assign) CGFloat ACNTextHeight;

/***** ACN相关 *****/

//MARK: - 方法
///初始化
- (instancetype)initWithModel:(TUFeedAttributedModel *)feedModel;
- (instancetype)initWithModel:(TUFeedAttributedModel *)feedModel recommendReason:(NSString *)recommendReason;
///计算布局
- (void)layout;

///更新赞 分享 评论 数的状态
- (void)updateFeedStatusLayout;

///更新关注
- (void)updateFollow:(BOOL)isFollow;

///展开全文
- (void)updateWhenContentOpenUp;

/// 翻译contentView的时候
- (void)updateWhenContentTranslation;


@end


