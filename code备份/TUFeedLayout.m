//
//  TUFeedLayout.m
//  tataufo
//
//  Created by 雷凯 on 2017/8/30.
//  Copyright © 2017年 tataufo. All rights reserved.
//

#import "TUFeedLayout.h"
#import "TUUserNameDisplayHelper.h"
#import "TUTextLinePositionModifier.h"
#import "TUFeedExtraModel.h"
#import "JSONKit.h"
#import "NSMutableAttributedString+Category.h" 
#import "NSDate+TimeAgoFormat.h"
#import "TUCardBannerModel.h"
#import "TUFeedPreferenceInfoLayout.h"
#import "TUFeedHelper.h"
#import "ContentInfo_PhotoInfo+Category.h"


@interface TUFeedLayout ()
///不显示评论
@property (nonatomic, assign) BOOL isCommentHidden;
///极简显示  目前是搜索出来的用
@property (nonatomic, assign) BOOL isSearchShow;
///用户名
@property (nonatomic, strong) NSMutableAttributedString *userNameText;
///标签
@property (nonatomic, strong) NSMutableAttributedString *topicText;
///内容
@property (nonatomic, strong) NSMutableAttributedString *contentText;
/// 非首页 拼的
@property (nonatomic, copy) NSString *recommendReason;
/// 翻译之前文本是否展开
@property (nonatomic, assign) BOOL isContentOpenUpBeforeTranslate;

@end

static const CGFloat topMargin = 1.0;

@implementation TUFeedLayout
- (instancetype)initWithModel:(TUFeedAttributedModel *)feedModel {
    
    return [self initWithModel:feedModel recommendReason:nil];
}

- (instancetype)initWithModel:(TUFeedAttributedModel *)feedModel recommendReason:(NSString *)recommendReason {
    if (!feedModel) return nil;
    self = [super init];
    _feedModel = feedModel;
    _recommendReason = recommendReason;
    
    [self layout];
    return self;
}

//MARK: - *********
//MARK: - 总的排版
- (void)layout {
    
    ///隐藏关注   个人页直接不显示关注按钮
    _isFollowHidden = _feedModel.showType == TUFeedShowTypeProfile;
    
    ///是否关注
    _isUserFollow = _feedModel.feed.contentInfo.author.relation == TUUserRelationTypeNone
                 || _feedModel.feed.contentInfo.author.relation == TUUserRelationTypeFollow
                 || _feedModel.feed.contentInfo.author.relation == TUUserRelationTypeFollowEachOther
                 || _feedModel.feed.contentInfo.author.userid == [G shared].user.userID;
    
    ///隐藏箭头 涉及到计算文字可用最大宽度等
    _isArrowHidden = _feedModel.showType == TUFeedShowTypeUploading
                  || _feedModel.showType == TUFeedShowTypeUploaded
                  || _feedModel.showType == TUFeedShowTypeDiscoverSearchResult;
  
    ///隐藏评论区域
    _isCommentHidden = _feedModel.showType == TUFeedShowTypeByUserComment
                    || _feedModel.showType == TUFeedShowTypeAuidoList;
    
    ///是否在搜索页面展示
    _isSearchShow = _feedModel.showType == TUFeedShowTypeDiscoverSearchResult;
    
    [self _layout];
    
}

//MARK: - 内部调用 注意代码顺序 会有计算关系
- (void)_layout {
    
    if (_feedModel.showType == TUFeedShowTypeUploading) {
        
        [self _layoutReadyPush];
        self.cellHeight = 62.0;
        return;
        
    }
    [self _layoutACNAwardLabel];
    [self _layoutUser];
    [self _layoutTopicAndContent];

    //无需隐藏时再去计算
    if (!_isSearchShow) {
        [self _layoutPhoto];
        [self _layoutVideo];
        [self _layoutFlashChat];
        [self _layoutAudio];
        [self _layoutMusic];
        [self _layoutLocation];
        [self _layoutLink];
        [self _layoutPreference];
        [self _layoutUserUpdateInfo];
        [self _layoutToolBar];
        [self _layoutLikeAndShareInfo];
        [self _layoutComment];
    }
    
    [self _layoutPrompt];
   
    _bottomMargin = 18.0;
    
    _feedInfoHeight += _userTopMargin;
    _feedInfoHeight += _userHeight;

    _feedInfoHeight += _photoTopMargin;
    _feedInfoHeight += _photoHeight;
    _feedInfoHeight += _videoTopMargin;
    _feedInfoHeight += _videoHeight;
    _feedInfoHeight += _flashChatTopMargin;
    _feedInfoHeight += _flashChatHeight;
    _feedInfoHeight += _audioTopMargin;
    _feedInfoHeight += _audioHeight;
    _feedInfoHeight += _musicTopMargin;
    _feedInfoHeight += _musicHeight;
    _feedInfoHeight += _locationTopMargin;
    _feedInfoHeight += _locationHeight;
    _feedInfoHeight += _linkTopMargin;
    _feedInfoHeight += _linkHeight;
    _feedInfoHeight += _preferenceTopMargin;
    _feedInfoHeight += _preferenceHeight;
    _feedInfoHeight += _userUpdateInfoTopMargin;
    _feedInfoHeight += _userUpdateInfoHeight;
    
    //正文距离顶部距离
    [self flexibleLayout];
    //预发贴
    self.height += _readyPushHeight;
    
    //正常
    self.height += _feedInfoHeight;
    self.height += _toolbarTopMargin;
    self.height += _toolbarHeight;
    self.height += _toolbarInfoTopMargin;
    self.height += _toolbarInfoHeight;
    
    self.height += _contentTopMargin;
    self.height += _contentHeight;
    
    self.height += _commentTopMargin;
    self.height += _commentHeight;
    self.height += _promptTopMargin;
    self.height += _promptHeight;
    self.height += _bottomMargin;
    
    self.cellHeight = self.height;

}
// 底部动态布局
- (void)flexibleLayout {
    
    _feedContentTopHeight = _feedInfoHeight + _toolbarTopMargin + _toolbarHeight + _toolbarInfoTopMargin + _toolbarInfoHeight + _contentTopMargin;
    _feedCommentTopHeight = _feedContentTopHeight + _contentHeight + _commentTopMargin;
    _feedBottomTimeHeight = _feedCommentTopHeight + _commentHeight + _promptTopMargin;

}

//MARK: 更新赞 分享 评论 数的状态
//目前的做法是 先减去需要重新减去需要重新计算的地方 布局计算 布局计算完成之后再加回去新计算的值
//如果以后界面改动大遇到问题 可以将值置为0后 在重新计算全部的值并相加
// 注意：这里的代码顺序改变 可能回产生bug
- (void)updateFeedStatusLayout {

    self.height -= _toolbarHeight;
    self.height -= _toolbarInfoTopMargin;
    self.height -= _toolbarInfoHeight;
    
    self.height -= _contentHeight;
    
    self.height -= _commentTopMargin;
    self.height -= _commentHeight;
    self.height -= _promptTopMargin;
    self.height -= _commentIndicatorHeight;
    self.height -= _promptHeight;
    
    [self _layoutToolBar];
    [self _layoutLikeAndShareInfo];
    [self _layoutComment];
    [self _layoutCommentIndicator];
    [self _layoutPrompt];
    
    self.height += _toolbarHeight;
    self.height += _toolbarInfoTopMargin;
    self.height += _toolbarInfoHeight;
    
    self.height += _contentHeight;
    
    self.height += _commentTopMargin;
    self.height += _commentHeight;
    self.height += _promptTopMargin;
    self.height += _commentIndicatorHeight;
    self.height += _promptHeight;
    
    self.cellHeight = self.height;
    
    [self flexibleLayout];
    
}

- (void)setShowCommentIndicator:(BOOL)showCommentIndicator {
    _showCommentIndicator = showCommentIndicator;
    if (showCommentIndicator) {
        [self updateFeedStatusLayout];
    }
}

- (void)_layoutCommentIndicator {
    _commentIndicatorHeight = 0.0;
    if (_showCommentIndicator) {
        _commentIndicatorHeight = 50.0;
    }
}

//MARK: - 展开全文
- (void)updateWhenContentOpenUp {
    _isContentOpenUpState = YES;
    _isContentOpenUpBeforeTranslate = YES;
    if (_allContentTextLayout) {
        
        self.height -= _contentHeight;
        
        _contentTextLayout = _allContentTextLayout;
        _contentHeight = _contentTextLayout.textBoundingSize.height;
        
        self.height += _contentHeight;
        
    }
    self.cellHeight = self.height;
    [self flexibleLayout];
}

- (void)updateWhenContentTranslation {
    // 减去之前的高度
    self.height -= _contentHeight;
    // 重新布局
    [self _layoutTopicAndContent];
    // 是否是展开状态
    _isContentOpenUpState = _isContentOpenUpBeforeTranslate;
    if (_allContentTextLayout && _isContentOpenUpBeforeTranslate) {
        _contentTextLayout = _allContentTextLayout;
        _contentHeight = _contentTextLayout.textBoundingSize.height;
    }
    // 加上现在的高度
    self.height += _contentHeight;
    self.cellHeight = self.height;
    [self flexibleLayout];
}

//MARK: - 更新关注
- (void)updateFollow:(BOOL)isFollow {
    
    NSString *followStr;
    if (isFollow) {
        followStr = TULocalizedString(@"已关注", @"已关注");
    }else {
        followStr = TULocalizedString(@"+关注", @"+关注");
    }
    
    NSString *str = [NSString stringWithFormat:@"%@", followStr];
    NSMutableAttributedString *followText = [[NSMutableAttributedString alloc] initWithString:str];
    followText.yy_color = [UIColor appTitleLightGrayColor];
    followText.yy_font = [UIFont appFontWithBoldFontSize:14];
    followText.yy_ligature = @0;
   
    if (!isFollow) {
        followText.yy_color = [UIColor appBlueColor];
        YYTextHighlight *followHighlight = [[YYTextHighlight alloc]init];
        followHighlight.userInfo = @{kTextHighlightUserFollowKey : _feedModel.feed.contentInfo.author};
        [followText yy_setTextHighlight:followHighlight range:NSMakeRange(0, str.length)];
    }

    YYTextContainer *followContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    followContainer.maximumNumberOfRows = 1;
    YYTextLayout *followTextLayout = [YYTextLayout layoutWithContainer:followContainer text:followText];
    _followTextLayout = followTextLayout;
}

//MARK: - 预发贴排版
- (void)_layoutReadyPush {
    
    _readyPushHeight = 0.0;
    _readyPushNormalTextLayout = nil;
    _readyPushNormalTextSize = CGSizeZero;
    _readyPushErrorTextLayout = nil;
    _readyPushErrorTextSize = CGSizeZero;
  
    if (_feedModel.showType == TUFeedShowTypeUploading) {
        _readyPushHeight = 62.0;//41.0;
        
        NSMutableAttributedString *normalText = [[NSMutableAttributedString alloc] initWithString:TULocalizedString(@"正在上传...", @"正在上传...")];
        normalText.yy_font = [UIFont appFontWithFontSize:12];
        normalText.yy_color = [UIColor appTitleBlackColor];
        normalText.yy_ligature = @0;
        NSMutableParagraphStyle *normalParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        normalParagraphStyle.lineSpacing = 1;
        normalText.yy_paragraphStyle = normalParagraphStyle;
        YYTextContainer *normalContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        normalContainer.maximumNumberOfRows = 1;
        YYTextLayout *normalTextLayout = [YYTextLayout layoutWithContainer:normalContainer text:normalText];
        _readyPushNormalTextLayout = normalTextLayout;
        _readyPushNormalTextSize = normalTextLayout.textBoundingSize;
        
        NSMutableAttributedString *errorText = [[NSMutableAttributedString alloc] initWithString:TULocalizedString(@"重新发布", @"重新发布")];
        errorText.yy_font = [UIFont appFontWithFontSize:12];
        errorText.yy_color = [UIColor appTitleBlackColor];
        errorText.yy_ligature = @0;
        NSMutableParagraphStyle *errorParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        errorParagraphStyle.lineSpacing = 1;
        errorText.yy_paragraphStyle = errorParagraphStyle;
        YYTextContainer *errorContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        errorContainer.maximumNumberOfRows = 1;
        YYTextLayout *errorTextLayout = [YYTextLayout layoutWithContainer:errorContainer text:errorText];
        _readyPushErrorTextLayout = errorTextLayout;
        _readyPushErrorTextSize = errorTextLayout.textBoundingSize;
    }
}

//MARK: - ACN 奖励label排版
- (void)_layoutACNAwardLabel {
    
    _isHasACNLabel = NO;
    _ACNTextHeight = 0.0;
    _ACNTextBottomMargin = 0.0;
    _awardACNTextLayout = nil;
    if (_feedModel.isHasACNLabel) {
        
        NSMutableAttributedString *pointStr = [[NSMutableAttributedString alloc] initWithString:@" · "];
        pointStr.yy_font = [UIFont appFontWithBoldFontSize:14];
        pointStr.yy_color = [UIColor appTitleBlackColor];
        pointStr.yy_ligature = @0;
        
        NSString *acnRewardStr = _feedModel.feed.contentInfo.acnReward;
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc] initWithString:acnRewardStr];
        textStr.yy_font = [UIFont appFontWithBoldFontSize:14];
        textStr.yy_color = [UIColor appLightGreenColor];
        textStr.yy_ligature = @0;
                
        [pointStr appendAttributedString:textStr];
        
        YYTextHighlight *textHighlight = [[YYTextHighlight alloc]init];
        [pointStr yy_setTextHighlight:textHighlight range:NSMakeRange(0, pointStr.string.length)];
        
        YYTextContainer *ACNTextContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        ACNTextContainer.maximumNumberOfRows = 1;
        
        YYTextLayout *ACNTextLayout = [YYTextLayout layoutWithContainer:ACNTextContainer text:pointStr];
        
        _ACNTextHeight = ACNTextLayout.textBoundingSize.height;
        _ACNTextBottomMargin = 9.0;
        _awardACNTextLayout = ACNTextLayout;
        _isHasACNLabel = YES;
    }
    
}

//MARK: - 用户信息排版
- (void)_layoutUser {
    
    _isHasUser = NO;
    _userTopMargin = 16.0;// 18.0
    _userHeight = 0.0;
    _userNameTextLayout = nil;
    _reasonTextLayout = nil;
    
    if (!_feedModel.feed
     || !_feedModel.feed.contentInfo
     || !_feedModel.feed.contentInfo.author
     || _feedModel.feed.contentInfo.author.userid == 0) {
        
        return;
    }
    
    _isHasUser = YES;
    
    //先计算用户声望&关注按钮区
    [self _layoutFollowButton];

    ///昵称
    NSString *nameStr = [TUUserNameDisplayHelper getUserNameWithUserID:_feedModel.feed.contentInfo.author.userid];
    if (KILLNil(nameStr).length == 0) {
        nameStr = _feedModel.feed.contentInfo.author.nickname;
    }
    
    if (KILLNil(nameStr).length == 0) {
#if DEV
        nameStr = TULocalizedString(@"错误账户", @"错误账户");
#elif FORCE_PRODUCTION_URL
        nameStr = TULocalizedString(@"错误账户", @"错误账户");
#else
        nameStr = TULocalizedString(@"昵称", @"昵称");
#endif
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:KILLNil(nameStr)];
    nameText.yy_color = [UIColor appTitleBlackColor];
    nameText.yy_font = [UIFont appFontWithBoldFontSize:14];
    nameText.yy_ligature = @0;
    YYTextHighlight *nameHighlight = [[YYTextHighlight alloc]init];
    nameHighlight.userInfo = @{kTextHighlightBriefUserKey : _feedModel.feed.contentInfo.author};
    [nameText yy_setTextHighlight:nameHighlight range:NSMakeRange(0, KILLNil(nameStr).length)];
    _userNameText = nameText;
    YYTextContainer  *nameContarer = [[YYTextContainer alloc]init];
    
    CGFloat nameMaxWidth = KDeviceWidth-63;//KDeviceWidth -18 -36 -9   |左边距18|头像36|间隔9
    
    if (_followTextLayout) {///-关注的宽
        nameMaxWidth -= _followTextLayout.textBoundingSize.width;
    }
    
    if (!_isArrowHidden) {//不显示箭头 48
        nameMaxWidth -= 48;
    }
    
    nameContarer.size = CGSizeMake(nameMaxWidth, CGFLOAT_MAX);
    nameContarer.maximumNumberOfRows = 1;
    nameContarer.truncationType = YYTextTruncationTypeEnd;
    YYTextLayout *userNameTextLayout = [YYTextLayout layoutWithContainer:nameContarer text:nameText];

    _userNameTextLayout = userNameTextLayout;
    
//    [self _layoutReason];
    [self _layoutLocationText];

    CGFloat height = userNameTextLayout.textBoundingSize.height;
    if (_locationTextLayout) {
        height += _locationTextLayout.textBoundingSize.height;
    }
    //如果计算出来的高度没有头像及其间距的高度高的话 就返回头像高度
    if (height <46.0) {
        height = 46.0;
    }
    
    
    _userHeight = height;
}

//MARK: - 用户声望&关注按钮区
- (void)_layoutFollowButton {
    
    _followTextLayout = nil;
    
    ///关注
    if (!_isFollowHidden && !_isUserFollow) {
        [self updateFollow:NO];
    }

}

//MARK: - 推荐原因排版
- (void)_layoutReason {
    
    _reasonTextLayout = nil;
    
    if (_feedModel.showType != TUFeedShowTypeNormal
     && _feedModel.showType != TUFeedShowTypeBanner) {
        return;
    }
    
    NSMutableAttributedString *reasonText = [[NSMutableAttributedString alloc] init];
    
    if (_feedModel.showType == TUFeedShowTypeBanner) {
        
        if (_feedModel.cardBannerModel.cardBanner.title && _feedModel.cardBannerModel.cardBanner.title.length >0) {
            [reasonText yy_appendString:@" · "];
            [reasonText yy_appendString:_feedModel.cardBannerModel.cardBanner.title];
        }
        
    }else {
        
        if (_feedModel.feed.recommendReasonArray && _feedModel.feed.recommendReasonArray.count >0) {
            [reasonText yy_appendString:@" · "];
            Response11033_Data_RecommendReason * reasonModel = _feedModel.feed.recommendReasonArray.firstObject;
            
            NSInteger reasonType = reasonModel.type;
            
            //用户
            if (reasonType == 1 || reasonType == 2  || reasonType == 4 || reasonType == 5 || reasonType == 6 || reasonType == 7 ||reasonType == 8 ) {
                
                if (!reasonModel.usersArray || reasonModel.usersArray.count == 0) {
                    
                    return;
                }
                
                BriefUser *userInfo = reasonModel.usersArray.firstObject;
                NSString *userName = [TUUserNameDisplayHelper getUserNameWithUserID:userInfo.userid];
                if (KILLNil(userName).length == 0) {
                    userName = userInfo.nickname;
                }
                
                NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc]initWithString:KILLNil(userName)];
                [reasonText appendAttributedString:nameText];
                
                //好友赞
                if (reasonType  == 1 || reasonType  == 5) {
                    
                    if (reasonModel.num >1) {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:TULocalizedString(@"等%zd位好友赞了", @"等%zd位好友赞了"), reasonModel.num]];
                        [reasonText appendAttributedString:addText];
                        
                        
                    }else {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString:TULocalizedString(@"赞了", @"赞了")];
                        [reasonText appendAttributedString:addText];
                    }
                }
                
                //好友评论
                if (reasonType  == 2 || reasonType == 6) {
                    
                    if (reasonModel.num>1) {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:TULocalizedString(@"等%zd位好友评论了", @"等%zd位好友评论了"), reasonModel.num]];
                        [reasonText appendAttributedString:addText];
                        
                    }else {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString:TULocalizedString(@"评论了", @"评论了")];
                        [reasonText appendAttributedString:addText];
                    }
                    
                }
                
                //好友加入
                if (reasonType  == 4) {
                    
                    if (reasonModel.num >1) {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:TULocalizedString(@"等%zd位好友加入过", @"等%zd位好友加入过"), reasonModel.num]];
                        [reasonText appendAttributedString:addText];
                        
                        
                        
                    }else {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString:TULocalizedString(@"加入过", @"加入过")];
                        [reasonText appendAttributedString:addText];
                        
                    }
                    
                }
                
                //好友关注
                if (reasonType  == 7) {
                    
                    
                    if (reasonModel.num >1) {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:TULocalizedString(@"等%zd位好友关注过", @"等%zd位好友关注过"), reasonModel.num]];
                        [reasonText appendAttributedString:addText];
                        
                    }else {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString:TULocalizedString(@"关注", @"关注")];
                        [reasonText appendAttributedString:addText];
                        
                        
                    }
                    
                }
                
                //好友参与
                if (reasonType == 8) {
                    
                    if (reasonModel.num >1) {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString: [NSString stringWithFormat:TULocalizedString(@"等%zd位好友参与过", @"等%zd位好友参与过"), reasonModel.num]];
                        [reasonText appendAttributedString:addText];
                        
                    }else {
                        
                        NSMutableAttributedString *addText = [[NSMutableAttributedString alloc]initWithString:TULocalizedString(@"参与过", @"参与过")];
                        [reasonText appendAttributedString:addText];
                        
                        
                    }
                    
                }
                
            }
            
            //标签
            if (reasonType == 3 || reasonType == 9) {
                
                if (!reasonModel.topicInfo) {
                    
                    return;
                }
                
                NSString *addStr = @"";
                
                if (reasonType == 3) {
                    addStr = TULocalizedString(@"来自你关注的标签", @"来自你关注的标签");
                }
                
                if (reasonType == 9) {
                    addStr =  TULocalizedString(@"你参与过的标签", @"你参与过的标签");
                }
                
                
                NSMutableAttributedString *addText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", KILLNil(addStr)]];
                [reasonText appendAttributedString:addText];
            }
            
            //你申请过好友 || 你赞过他/她的动态 || 你评论过他/她的动态 这里用的是后台返回的 || 你可能认识ta || 你的同学 || 你的同事 || 兴趣推荐
            if (reasonType == 10 || reasonType == 11 || reasonType == 12 || reasonType == 14 || reasonType == 15 || reasonType == 16 || reasonType == 17 || reasonType == 19) {
                [reasonText yy_appendString:reasonModel.msg];
            }
            
        } else if(KILLNil(_recommendReason).length >0) {
            [reasonText yy_appendString:@" · "];
            [reasonText yy_appendString:_recommendReason];
        }
        
    }
    
    if (reasonText.length >0) {
        reasonText.yy_color = [UIColor appTitleGrayColor];
        reasonText.yy_font = [UIFont appFontWithFontSize:12.0];
        reasonText.yy_ligature = @0;
        
        YYTextContainer *reasonContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        reasonContainer.maximumNumberOfRows = 1;
        _reasonTextLayout = [YYTextLayout layoutWithContainer:reasonContainer text:reasonText];
    }
    /*
    if (reasonText.length >0) {
        
        CGFloat reasonMaxWidth = KDeviceWidth - 63.0;
        if (!_isArrowHidden) {
            reasonMaxWidth -= 48.0;
        }
        
        YYTextContainer *reasonContainer = [YYTextContainer containerWithSize:CGSizeMake(reasonMaxWidth, CGFLOAT_MAX)];
        reasonContainer.maximumNumberOfRows = 1;
        YYTextLayout *reasonLayout = [YYTextLayout layoutWithContainer:reasonContainer text:reasonText];
        _reasonTextLayout = reasonLayout;
    }*/
    
}



//MARK: - 标签和内容区
- (void)_layoutTopicAndContent {
    
    _contentTopMargin = 0.0;
    _contentHeight = 0.0;
    _isHasContent = NO;
    _contentTextLayout = nil;
    _isCanContentOpenUp = NO;
    _isContentOpenUpState = NO;
    _openUpTextLayout = nil;
    _allContentTextLayout = nil;
    
    NSMutableAttributedString *topicAndContentText = [[NSMutableAttributedString alloc] init];
      // 7.0 -> 标签改到内容里
//    [self _layoutTopic];
    if (_isTranslated) {
        [self _layoutTranslateContent];
    } else {
        [self _layoutContent];
    }
    [self _layoutTanslateText];
    if (_topicText || _contentText) {
      
        _isHasContent = YES;
        _contentTopMargin = 3.0;
        
        if (_userNameText) {
            
            NSString *nameStr = [NSString stringWithFormat:@"%@ ", KILLNil(_userNameText.string)];
            NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
            nameText.yy_color = [UIColor appTitleBlackColor];
            nameText.yy_font = [UIFont appFontWithBoldFontSize:14];
            nameText.yy_ligature = @0;
            YYTextHighlight *nameHighlight = [[YYTextHighlight alloc]init];
            nameHighlight.userInfo = @{kTextHighlightBriefUserKey : _feedModel.feed.contentInfo.author};
            [nameText yy_setTextHighlight:nameHighlight range:NSMakeRange(0, KILLNil(nameStr).length)];
            [topicAndContentText appendAttributedString:nameText];
            
        }
        
        if (_topicText) {
            [topicAndContentText appendAttributedString:_topicText];
        }
        if (_contentText) {
            [topicAndContentText appendAttributedString:_contentText];
        }
        
        YYTextContainer *contentContainer = [YYTextContainer containerWithSize:CGSizeMake(KDeviceWidth -36.0, CGFLOAT_MAX)];
        if (_feedModel.showType == TUFeedShowTypeDiscoverSearchResult) {
            contentContainer.maximumNumberOfRows = 2;
            contentContainer.truncationType = YYTextTruncationTypeEnd;
        }else {
            contentContainer.maximumNumberOfRows = 2;
        }
        
        YYTextLayout *contentTextLayout = [YYTextLayout layoutWithContainer:contentContainer text:topicAndContentText];
        _contentTextLayout = contentTextLayout;
        YYTextContainer *allContentContainer = [YYTextContainer containerWithSize:CGSizeMake(KDeviceWidth -36.0, CGFLOAT_MAX)];
        allContentContainer.maximumNumberOfRows = 0;
        YYTextLayout *allContentTextLayout = [YYTextLayout layoutWithContainer:allContentContainer text:topicAndContentText];
        _allContentTextLayout = allContentTextLayout;
        
        if (allContentTextLayout.lines.count > 2) {
            if (_feedModel.showType == TUFeedShowTypeDiscoverSearchResult) {
                _isCanContentOpenUp = NO;
            }else {
                _isCanContentOpenUp = YES;
                NSMutableAttributedString *openUpText = [[NSMutableAttributedString alloc] initWithString:TULocalizedString(@"展开--Full Text", @"展开--Full Text")];
                openUpText.yy_color = [UIColor appTitleGrayColor];
                openUpText.yy_font = [UIFont appFontWithFontSize:14];
                openUpText.yy_ligature = @0;
                YYTextHighlight *openUpHighlight = [[YYTextHighlight alloc]init];
                [openUpText yy_setTextHighlight:openUpHighlight range:NSMakeRange(0, openUpText.string.length)];
                YYTextContainer *openUpContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
                YYTextLayout *openUpLayout = [YYTextLayout layoutWithContainer:openUpContainer text:openUpText];
                _openUpTextLayout = openUpLayout;
            }

        }
        
        _contentHeight = contentTextLayout.textBoundingSize.height;
        
    }
}


//MARK: - 帖子的标签
- (void)_layoutTopic {
    _topicText = nil;
    if (_feedModel.showType != TUFeedShowTypeTopicHome && _feedModel.feed.contentInfo.topicInfoArray && _feedModel.feed.contentInfo.topicInfoArray.count >0 && [_feedModel.feed.contentInfo.topicInfoArray.firstObject isKindOfClass:[TopicInfo class]]) {
        
        TopicInfo *topInfo = _feedModel.feed.contentInfo.topicInfoArray.firstObject;
        
        if (KILLNil(topInfo.topicName).length >0) {
            NSString *topicStr = [NSString stringWithFormat:@"#%@ ", KILLNil(topInfo.topicName)];
            NSMutableAttributedString *topicText = [[NSMutableAttributedString alloc] initWithString:topicStr];
            topicText.yy_color = [UIColor appTopicColor];
            topicText.yy_font = [UIFont appFontWithFontSize:14];
            topicText.yy_ligature = @0;
            YYTextHighlight *topicHighlight = [[YYTextHighlight alloc]init];
            topicHighlight.userInfo = @{kTextHighlightTopicInfoKey : topInfo};
            [topicText yy_setTextHighlight:topicHighlight range:NSMakeRange(0, topicStr.length)];
            _topicText = topicText;
        }
        
    }
    
}

//MARK: - 帖子文本内容排版
- (void)_layoutContent {
    
    _contentText = nil;
    
    if (_feedModel.feed.contentInfo.content && _feedModel.feed.contentInfo.content.length >0) {
        
        UIFont *textFont = [UIFont appFontWithFontSize:14];
        
        NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:_feedModel.feed.contentInfo.content];
        
        contentText.yy_font = textFont;
        contentText.yy_color = [UIColor appTitleBlackColor];
        contentText.yy_ligature = @0;
        contentText = [contentText mutAttrStrWithEmojiTransformedWithFont:textFont];
        contentText = [contentText mutAttrStrWithLinkInfos:_feedModel.feed.contentInfo.linkInfoArray Font:textFont isVideoFeed:NO isShowLinkGuide:YES];
        contentText = [contentText mutAttrStrHighlightLinkWithFont:textFont];
        
        // @用户信息 高亮
        if (_feedModel.feed.contentInfo.atInfoListArray && _feedModel.feed.contentInfo.atInfoListArray.count >0) {
            contentText = [contentText mutAttrStrAtInfoList:_feedModel.feed.contentInfo.atInfoListArray];
        }
        
        // 标签
        if (_feedModel.feed.contentInfo.topicInfoArray && _feedModel.feed.contentInfo.topicInfoArray.count > 0) {
            
            // *** 测试代码 ***
//            TopicInfo *topInfo = _feedModel.feed.contentInfo.topicInfoArray.firstObject;
//            if (KILLNil(topInfo.topicName).length > 0) {
//                NSMutableAttributedString *testStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"#%@%@",KILLNil(topInfo.topicName), @" "]];
//                [contentText appendAttributedString:testStr];
//            }
            // *** 测试代码 ***
            
            contentText = [contentText mutAttrStrTopicInfoList:_feedModel.feed.contentInfo.topicInfoArray withFont:textFont];
        }
        
        // 搜索关键字 高亮
        if (_feedModel.keywords && _feedModel.keywords.count >0) {
            contentText = [contentText mutAttrStrHighlightKeywords:_feedModel.keywords];
        }
        
        _contentText = contentText;
    }
    
}
//MARK: - 翻译后帖子文本内容排版
- (void)_layoutTranslateContent {
    _contentText = nil;
    if (_translateResult && _translateResult.length >0) {
        UIFont *contentFont = [UIFont appFontWithFontSize:14];
        NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:_translateResult];
        contentText.yy_font = contentFont;
        contentText.yy_color = [UIColor appTitleBlackColor];
        contentText.yy_ligature = @0;
        contentText = [contentText mutAttrStrWithEmojiTransformedWithFont:contentFont];
        contentText = [contentText mutAttrStrWithLinkInfos:_feedModel.feed.contentInfo.linkInfoArray Font:contentFont isVideoFeed:NO isShowLinkGuide:YES];
        contentText = [contentText mutAttrStrHighlightLinkWithFont:contentFont];
        if (_feedModel.feed.contentInfo.atInfoListArray && _feedModel.feed.contentInfo.atInfoListArray.count >0) {
            contentText = [contentText mutAttrStrAtInfoList:_feedModel.feed.contentInfo.atInfoListArray];
        }
        if (_feedModel.feed.contentInfo.topicInfoArray && _feedModel.feed.contentInfo.topicInfoArray.count > 0) {
            contentText = [contentText mutAttrStrTopicInfoList:_feedModel.feed.contentInfo.topicInfoArray withFont:contentFont];
        }
        if (_feedModel.keywords && _feedModel.keywords.count >0) {
            contentText = [contentText mutAttrStrHighlightKeywords:_feedModel.keywords];
        }
        _contentText = contentText;
    }
}

//MARK: - 图片排版
- (void)_layoutPhoto {
    
    _photoTopMargin = 0.0;
    _photoCount = 0;
    _photoHeight = 0.0;
    _photoRowSpacing = 0;
    _photoColumnsSpacing = 0;
    _photoMinHeight = 0.0;
    _photoMaxHeight = 0.0;
    _isHasPhoto = NO;
    
    if ([_feedModel containPhotoContent]) {
        
        _isHasPhoto = YES;
        _photoTopMargin = topMargin;
        _photoCount = _feedModel.feed.contentInfo.photoInfoArray.count;
        _photoRowSpacing = [self getPhotoRowSpacing];
        _photoColumnsSpacing = [self getPhotoColumnsSpacing];
        
        CGPoint minPhotoOrigin = CGPointZero;
        CGSize minSize = [self getPhotoItemSize];
//        CGFloat maxPhotoY = 0.0;
//        CGFloat minPhotoY = 0.0;
        
        for (NSInteger i=0; i<_photoCount; i++) {
//            CGSize minSize = [self getPhotoItemSizeWithIndex:i];
            ContentInfo_PhotoInfo *info = _feedModel.feed.contentInfo.photoInfoArray[i];
            
            // 图片宽高比范围  3:4 ~ 2:1
            minPhotoOrigin = CGPointMake(i * minSize.width, 0.0);
                
            info.minRect = CGRectMake(minPhotoOrigin.x, minPhotoOrigin.y, minSize.width, minSize.height);
            
            _photoHeight = minSize.height;
        }
    }
}

//MARK: - 视频&闪拍排版
- (void)_layoutVideo {
    
    _videoTopMargin = 0;
    _videoCount = 0;
    _videoPreviewImageCount = 0;
    _videoHeight = 0.0;
    _isHasVideo = NO;
    
    if ([_feedModel containVideo]) {
        
        _videoTopMargin = 1.f;//9;
        _videoPreviewImageCount = _feedModel.feed.contentInfo.photoInfoArray.count;
        _videoCount = 1;
        _videoHeight = [self getVideoHeight];
        _isHasVideo = YES;

        
    }else {
        
        return;
    }
    
}

//MARK: - 闪聊排版
- (void)_layoutFlashChat {
    
    _flashChatTopMargin = 0.0;
    _flashChatHeight = 0.0;
    _flashChatNameHeight = 0.0;
    _flashChatDetailHeight = 0.0;
    _isHasFlashChat = NO;
    _flashChatNameTextLayout = nil;
    _flashChatDetailTextLayout = nil;
    _flashChatID = 0;
    _flashChatIconUrlStr = nil;
    _flashChatBackgroundColor = nil;
    
    if (_feedModel.feed.contentInfo.type == TUFeedContentTypeFlashChat && _feedModel.feed.contentInfo.extra && _feedModel.feed.contentInfo.extra.length >0) {
        

        NSDictionary *dict = [_feedModel.feed.contentInfo.extra objectFromJSONStringWithParseOptions:JKSerializeOptionEscapeUnicode];
        
        if (!dict) {
            
            return;
        }
        
        TUFeedExtraModel *extraModel = [[TUFeedExtraModel alloc ]initWithDictionary:dict];
        
        if (!extraModel) {
            return;
        }
        _feedModel.feedExtraModel = extraModel;
        
        _flashChatBackgroundColor = [self getFlashChatBackgroundColorWithExtraImgStr:extraModel.img];

        NSString *extra_model_name = @"";
        
        if (extraModel.name && extraModel.name.length >=1) {
            
            extra_model_name = extraModel.name;
        }
        
        NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:extra_model_name];
        nameText.yy_font = [UIFont appFontWithBoldFontSize:18];
        nameText.yy_color = [UIColor appTitleBlackColor];
        nameText.yy_ligature = @0;
        YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(KDeviceWidth -224, CGFLOAT_MAX)];
        nameContainer.maximumNumberOfRows = 2;
        _flashChatNameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText];
        _flashChatNameHeight = _flashChatNameTextLayout.textBoundingSize.height;

        NSString *extra_model_msg = @"";
        
        if (extraModel.msg && extraModel.msg.length >=1) {
            
            extra_model_msg = extraModel.msg;
        }
        
        NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:extra_model_msg];
        detailText.yy_font = [UIFont appFontWithFontSize:12];
        detailText.yy_color = [UIColor appTitleBlackColor];
        detailText.yy_ligature = @0;
        YYTextContainer *detailContainer = [YYTextContainer containerWithSize:CGSizeMake(KDeviceWidth -224, CGFLOAT_MAX)];
        detailContainer.maximumNumberOfRows = 1;
        _flashChatDetailTextLayout = [YYTextLayout layoutWithContainer:detailContainer text:detailText];
        _flashChatDetailHeight = _flashChatDetailTextLayout.textBoundingSize.height;
        
        _flashChatID = extraModel.idField;
        
        NSString *extra_model_img = @"";
        
        if (extraModel.img && extraModel.img.length >=1) {
            
            extra_model_img = extraModel.img;
        }
        
        _flashChatIconUrlStr = extra_model_img;
        
        _flashChatTopMargin = 9;
        _flashChatHeight = 123.0;
        _isHasFlashChat = YES;
        
    }else {
        
        return;
    }
}

//MARK: - 音频区排版
- (void)_layoutAudio {
    
    _audioTopMargin = 0.0;
    _audioHeight = 0.0;
    _isHasAudio = NO;
    
    if (_feedModel.feed.contentInfo.type == TUFeedContentTypeAudio && _feedModel.feed.contentInfo.wave && _feedModel.feed.contentInfo.wave.length>0) {
        
        _audioTopMargin = topMargin;//9.0;
        _audioHeight = 88.0;
        _isHasAudio = YES;
        
    }else {
        
        return;
    }
    
}

//MARK: - 音乐区排版
- (void)_layoutMusic {
    
    _musicTopMargin = 0.0;
    _musicHeight = 0.0;
    _isHasMusic = NO;
    
    if (_feedModel.feed.contentInfo.type == TUFeedContentTypeMusic && _feedModel.feed.contentInfo.musicInfo) {
        
        _musicTopMargin = topMargin;//9.0;
        _musicHeight = 88.0;
        _isHasMusic = YES;
        
    }else {
        
        return;
    }
    
}
//MARK: - 位置区排版
- (void)_layoutLocation {
    
    _locationTopMargin = 0.0;
    _locationHeight = 0.0;
    _isHasLocation = NO;
    
    if (_feedModel.feed.contentInfo.type == TUFeedContentTypeLocation && _feedModel.feed.contentInfo.locationInformation) {
        
        _locationTopMargin = topMargin;//9.0;
        _locationHeight = 82.0;
        _isHasLocation = YES;
        
    }
    
}

//MARK: - 链接区排版
- (void)_layoutLink {
    
    _linkTopMargin = 0.0;
    _linkHeight = 0.0;
    _linkTitleTextLayout = nil;
    _isHasLink = NO;
    if ([_feedModel containLink]) {
        _isHasLink = YES;
        _linkTopMargin = topMargin;//9.0;
        _linkHeight = 60.0;
        _linkTitleTextLayout = nil;
        
        NSString *linkTitle = TULocalizedString(@"分享链接", @"分享链接");
        
        if (_feedModel.feed.contentInfo.pageInfo.title && _feedModel.feed.contentInfo.pageInfo.title.length >0) {
            
            linkTitle = _feedModel.feed.contentInfo.pageInfo.title;
        }
        
        NSMutableAttributedString *linkText = [[NSMutableAttributedString alloc] initWithString:linkTitle];
        
        linkText.yy_font = [UIFont appFontWithBoldFontSize:18];
        linkText.yy_color = [UIColor appTitleBlackColor];
        linkText.yy_ligature = @0;
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(KDeviceWidth -114, CGFLOAT_MAX)];
        container.maximumNumberOfRows = 2;
        YYTextLayout *linkTextLayout = [YYTextLayout layoutWithContainer:container text:linkText];
        _linkTitleTextLayout = linkTextLayout;
        _linkTitleSize = linkTextLayout.textBoundingSize;

    }
    
}

//MARK: - 用户更新信息区 （注册、教育、工作）
- (void)_layoutUserUpdateInfo {
    
    _userUpdateInfoTopMargin = 0.0;
    _userUpdateInfoHeight = 0.0;
    _userUpdateInfoContentTextLayout = nil;
    _isHasUserUpdateInfo = NO;

    if ((_feedModel.feed.contentInfo.type == TUFeedContentTypeExperience || _feedModel.feed.contentInfo.type == TUFeedContentTypeRegistered) && _feedModel.feed.contentInfo.extra && _feedModel.feed.contentInfo.extra.length >0) {

        NSDictionary *dict = [_feedModel.feed.contentInfo.extra objectFromJSONStringWithParseOptions:JKSerializeOptionEscapeUnicode];
        
        if (!dict) {
            
            return;
        }
        
        TUFeedExtraModel *extraModel = [[TUFeedExtraModel alloc ]initWithDictionary:dict];
        
        if (!extraModel) {
            return;
        }
        _feedModel.feedExtraModel = extraModel;
        
        if (extraModel.content && extraModel.content.length >=1) {
            NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:extraModel.content];
            contentText.yy_font = [UIFont appFontWithBoldFontSize:18];
            contentText.yy_color = [UIColor appAnyModeWhiteColor];
            contentText.yy_ligature = @0;
            YYTextContainer *contentContainer = [YYTextContainer containerWithSize:CGSizeMake(KDeviceWidth -141, CGFLOAT_MAX)];
            contentContainer.maximumNumberOfRows = 2;
            contentContainer.truncationType = YYTextTruncationTypeEnd;
            YYTextLayout *contentTextLayout = [YYTextLayout layoutWithContainer:contentContainer text:contentText];
            _userUpdateInfoContentTextLayout = contentTextLayout;
            _userUpdateInfoTopMargin = topMargin;//9.0;
            _userUpdateInfoHeight = 60.0;
            _isHasUserUpdateInfo = YES;
        }
        
    }
    
}

//MARK: - 偏好区
- (void)_layoutPreference {

    /*******************偏好区**************************/
    _isHasPreference = NO;
    _preferenceTopMargin = 0.0;
    _preferenceHeight = 0.0;
    _preferenceInfoLayoutArrM = nil;
    
    if ([_feedModel containPreference]) {
        
        _isHasPreference = YES;
        _preferenceTopMargin = topMargin;//9.0;
        _preferenceHeight = 88.0;
        
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:_feedModel.feed.contentInfo.preferenceInfoListArray.count];
        for (ContentInfo_PreferenceInfo *info in _feedModel.feed.contentInfo.preferenceInfoListArray) {
            
            TUFeedPreferenceInfoLayout *infoLayout = [[TUFeedPreferenceInfoLayout alloc]initWithModel:info];
            
            if (infoLayout) {
                
                [arrM addObject:infoLayout];
            }
        }
        
        _preferenceInfoLayoutArrM = arrM;

    }
    
}

//MARK: - 点赞评论分享区排版
- (void)_layoutToolBar {
    
    _isHasToolBar = NO;
    _toolbarTopMargin = 0.0;
    _toolbarHeight = 0.0;
    
    if (_feedModel.feed.contentInfo) {
        _toolbarTopMargin = 13.5;
        _isHasToolBar = YES;
        _toolbarHeight = 32.0;
    }
    
}

//MARK: 布局点赞和热度数信息
///布局点赞和热度数信息
- (void)_layoutLikeAndShareInfo {
   
    _toolbarInfoTopMargin = 0.0;
    _toolbarInfoHeight = 0.0;
    _likeCountTextLayout = nil;
    _commentCountTextLayout = nil;
    _isHasToolBarInfo = NO;

    if (_feedModel.feed.contentInfo.likeCount >0) {
        NSString *likeText = [NSString stringWithFormat:TULocalizedString(@"%@赞", @"%@赞"), [TUFeedHelper thousandsWithCount:_feedModel.feed.contentInfo.likeCount]];
        likeText = [likeText stringByAppendingString:@" "];
        NSMutableAttributedString *likeCountText = [[NSMutableAttributedString alloc] initWithString:likeText];
        likeCountText.yy_font = [UIFont appFontWithBoldFontSize:14];
        likeCountText.yy_color = [UIColor appTitleBlackColor];
        likeCountText.yy_ligature = @0;
        YYTextHighlight *likeCountHighlight = [[YYTextHighlight alloc]init];
        [likeCountText yy_setTextHighlight:likeCountHighlight range:NSMakeRange(0, likeCountText.string.length)];
        
        YYTextContainer *likeContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        likeContainer.maximumNumberOfRows = 1;
        YYTextLayout *likeLayout = [YYTextLayout layoutWithContainer:likeContainer text:likeCountText];
        _likeCountTextLayout = likeLayout;
    }
    
    // 评论条数 -> 热度（7.0）
    NSUInteger commentCount = _feedModel.feed.contentInfo.contentValue;
    if (commentCount > 0) {
        NSString *pointStr = @"";
        if (_likeCountTextLayout) {
            pointStr = @"·";
        }
        
        NSMutableAttributedString *commentCountText = [[NSMutableAttributedString alloc] initWithString:[[NSString stringWithFormat:TULocalizedString(@"%@ %@热度", @"%@ %@热度"), pointStr, [TUFeedHelper thousandsWithCount:commentCount]] stringByAppendingString:@" "]];
        commentCountText.yy_font = [UIFont appFontWithBoldFontSize:14];
        commentCountText.yy_color = [UIColor appTitleBlackColor];
        commentCountText.yy_ligature = @0;
        YYTextHighlight *commentCountHighlight = [[YYTextHighlight alloc] init];
        [commentCountText yy_setTextHighlight:commentCountHighlight range:NSMakeRange(0, commentCountText.string.length)];
        
        YYTextContainer *commentContentContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        commentContentContainer.maximumNumberOfRows = 1;
        
        YYTextLayout *commentCountLayout = [YYTextLayout layoutWithContainer:commentContentContainer text:commentCountText];
        _commentCountTextLayout = commentCountLayout;
    }
    
    if (_likeCountTextLayout || _commentCountTextLayout) {
        _toolbarInfoTopMargin = 4.5;
        _isHasToolBarInfo = YES;
        if (_likeCountTextLayout) {
            _toolbarInfoHeight = _likeCountTextLayout.textBoundingSize.height;
        } else if (_commentCountTextLayout) {
            _toolbarInfoHeight = _commentCountTextLayout.textBoundingSize.height;
        }
    }
    
}


//MARK: - 评论区排版
- (void)_layoutComment {
    
    _commentTopMargin = 0.0;
    _commentHeight = 0.0;
    _isHasComment = NO;
   
    if (!_isCommentHidden) {
        [self _layoutCommentContent];
    }
    // 查看n条评论 -> 6.9.0 去除 -> 7.0 又添加回来了
    [self _layoutCommentMore];
   
    if (_feedModel.feed.contentInfo.commentCount >0) {
        _commentTopMargin = 9.0;
        /*_commentTopMargin = 4.5;
        if (_likeCountTextLayout) {
            _commentTopMargin = 9.0;
        }*/
    }
}

//MARK: 评论内容区排版
- (void)_layoutCommentContent {
    
    _commentTextLayoutArrM = nil;
    _notContainCommentBodyArrM = nil;
    
    if (_feedModel.feed.contentInfo.commentsArray && _feedModel.feed.contentInfo.commentsArray.count >0) {
        
        _commentTextLayoutArrM = [NSMutableArray new];
        _notContainCommentBodyArrM = [NSMutableArray new];
        
        _isHasComment = YES;
        
        NSUInteger index = 0;
        
        for (Comment *comment in _feedModel.feed.contentInfo.commentsArray) {
            
            if (![self.feedModel.feed.contentInfo.commentsArray[index] isKindOfClass:[Comment class]]) {
                continue;
            }
            
            NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] init];
            
            //评论人名字
            NSString *commentNameStr = [TUUserNameDisplayHelper getUserNameWithUserID:comment.commenter.userid];
            
            if (KILLNil(commentNameStr).length == 0) {
                
                commentNameStr = comment.commenter.nickname;
                
            }
            
            if (KILLNil(commentNameStr).length >0) {
                
                NSMutableAttributedString *commenterText = [[NSMutableAttributedString alloc] initWithString:KILLNil(commentNameStr)];
                commenterText.yy_font = [UIFont appFontWithBoldFontSize:14];
                commenterText.yy_color = [UIColor appTitleBlackColor];
                commenterText.yy_ligature = @0;
                YYTextHighlight *commenterHighlight = [[YYTextHighlight alloc]init];
                commenterHighlight.userInfo = @{kTextHighlightBriefUserKey : comment.commenter};
                [commenterText yy_setTextHighlight:commenterHighlight range:NSMakeRange(0, KILLNil(commentNameStr).length)];
                
                [commentText appendAttributedString:commenterText];
            }
            
            if (comment.hasCommentTarget && comment.commentTarget) {
                
                NSMutableAttributedString *addText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", TULocalizedString(@"回复", @"回复")]];
                addText.yy_font = [UIFont appFontWithFontSize:14];
                addText.yy_color = [UIColor appTitleBlackColor];
                addText.yy_ligature = @0;
                [commentText appendAttributedString:addText];
                
                NSString *commentTargetNameStr = [TUUserNameDisplayHelper getUserNameWithUserID:comment.commentTarget.userid];
                
                if (KILLNil(commentTargetNameStr).length ==0) {
                    
                    commentTargetNameStr = comment.commentTarget.nickname;
                }
                
                if (KILLNil(commentTargetNameStr).length >0) {
                    
                    NSMutableAttributedString *commentTargetNameText = [[NSMutableAttributedString alloc] initWithString:KILLNil(commentTargetNameStr)];
                    commentTargetNameText.yy_font = [UIFont appFontWithBoldFontSize:14];
                    commentTargetNameText.yy_color = [UIColor appTitleBlackColor];
                    commentTargetNameText.yy_ligature = @0;
                    YYTextHighlight *commentTargetNamerHighlight = [[YYTextHighlight alloc]init];
                    commentTargetNamerHighlight.userInfo = @{kTextHighlightBriefUserKey : comment.commentTarget};
                    [commentTargetNameText yy_setTextHighlight:commentTargetNamerHighlight range:NSMakeRange(0, KILLNil(commentTargetNameStr).length)];
                    [commentText appendAttributedString:commentTargetNameText];
                    
                }
                
            }
            
            NSMutableAttributedString *addText = [[NSMutableAttributedString alloc] initWithString:@" "];
            addText.yy_font = [UIFont appFontWithBoldFontSize:14];
            addText.yy_color = [UIColor appTitleBlackColor];
            addText.yy_ligature = @0;
            [commentText appendAttributedString:addText];
            // 注意：要进行copy，不然数组已保存对象会受后面操作影响
            NSString *notContainCommentBodyStr = [commentText.string copy];
            if (notContainCommentBodyStr && notContainCommentBodyStr.length >0) {
                [_notContainCommentBodyArrM addObject:notContainCommentBodyStr];
            }
            
            NSString *bodyStr = @"";
            if (comment.body && comment.body.length >0) {
                
                bodyStr = comment.body;
                
            }
            
            if (bodyStr && bodyStr.length >0) {
                
                NSMutableAttributedString *bodyText = [[NSMutableAttributedString alloc] initWithString:bodyStr];
                bodyText.yy_font = [UIFont appFontWithFontSize:14];
                bodyText.yy_color = [UIColor appTitleBlackColor];
                bodyText.yy_ligature = @0;
                bodyText =   [bodyText mutAttrStrWithEmojiTransformedWithFont:[UIFont appFontWithFontSize:14]];
                bodyText = [bodyText mutAttrStrHighlightLinkWithFont:[UIFont appFontWithFontSize:14]];
                
                [commentText appendAttributedString:bodyText];
            }
            
            if (comment.mediaItemsArray && comment.mediaItemsArray.count >0) {
                
                if (comment.mediaItemsArray.firstObject && [comment.mediaItemsArray.firstObject isKindOfClass:[MediaInfo class]]) {
                    
                    MediaInfo *mediaInfo = comment.mediaItemsArray.firstObject;
                    
                    NSString *mediaStr = @"";
                    
                    if (mediaInfo.type == 1) {
                        
                        mediaStr = TULocalizedString(@"[图片]", @"[图片]");
                        
                    }else if (mediaInfo.type == 2) {
                        
                        mediaStr = TULocalizedString(@"[表情]", @"[表情]");
                    }
                    
                    NSMutableAttributedString *mediaText = [[NSMutableAttributedString alloc] initWithString:mediaStr];
                    mediaText.yy_font = [UIFont appFontWithFontSize:14];
                    mediaText.yy_color = [UIColor appTitleBlackColor];
                    mediaText.yy_ligature = @0;
                    [commentText appendAttributedString:mediaText];
                    
                }
            }
            
            YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(KDeviceWidth - 36, CGFLOAT_MAX)];
            
            YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:commentText];
            if (textLayout) {
                [_commentTextLayoutArrM addObject:textLayout];
                _commentHeight += textLayout.textBoundingSize.height;
            }
            
            index += 1;
        }
    }
}

//MARK: 查看%x条评论
- (void)_layoutCommentMore {
    
    _moreCommentTextLayout = nil;
    _moreCommentTopMargin = 0.0;
    
    if (_feedModel.feed.contentInfo.commentCount > 0) {
        
        _isHasComment = YES;
        
        NSMutableAttributedString *moreCommentText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:TULocalizedString(@"查看%@条评论", @"查看%@条评论"),[TUFeedHelper thousandsWithCount:_feedModel.feed.contentInfo.commentCount]]];
        
        moreCommentText.yy_font = [UIFont appFontWithFontSize:14];
        moreCommentText.yy_color = [UIColor appTitleGrayColor];
        moreCommentText.yy_ligature = @0;
        YYTextBorder *border = [YYTextBorder borderWithFillColor:[UIColor grayColor] cornerRadius:3];
        border.fillColor = [UIColor appCellSelectColor];
        
        YYTextHighlight *moreCommentHighlight = [[YYTextHighlight alloc]init];
        [moreCommentHighlight setBackgroundBorder:border];
        [moreCommentText yy_setTextHighlight:moreCommentHighlight range:NSMakeRange(0, moreCommentText.string.length)];
        
        YYTextContainer *moreCommentContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        moreCommentContainer.maximumNumberOfRows = 1;
        _moreCommentTextLayout = [YYTextLayout layoutWithContainer:moreCommentContainer text:moreCommentText];
        
        if (_feedModel.feed.contentInfo.commentsArray.count >0) {
            _moreCommentTopMargin = 3.0;
        }
        
        _commentHeight += _moreCommentTopMargin;
        _commentHeight += _moreCommentTextLayout.textBoundingSize.height;
    }
}

//MARK: - 时间地点 & 隐私 & 6.9.0 -> 推荐理由改到下面
- (void)_layoutPrompt {
    
    _promptTopMargin = 0.0;
    _promptHeight = 0.0;
    _isHasPrompt = NO;
    
    [self _layoutPermit];
    [self _layoutReason];
    
    [self _layoutDateAndLocation];
    
    if (_timeAndLocationTextLayout || _permitTextLayout) {
        _isHasPrompt = YES;
        
        /*if (_isHasComment || _likeCountTextLayout) {
            _promptTopMargin = 9.0;
        }else {
            _promptTopMargin = 4.5;
        }*/
        _promptTopMargin = _showCommentIndicator ? 0.0 : 9.0;
        
        if (_timeAndLocationTextLayout) {
            _promptHeight = _timeAndLocationTextLayout.textBoundingSize.height;
        }else if (_permitTextLayout) {
            _promptHeight = _permitTextLayout.textBoundingSize.height;
        }
        
    }
    
}

//MARK: 发帖时间、地点
- (void)_layoutDateAndLocation {
    
    _timeAndLocationTextLayout = nil;
    
    NSDate *addTimeDate = [NSDate dateWithTimeIntervalSince1970:_feedModel.feed.contentInfo.addtime];
    NSString *timeStr = @"";
    
    if (addTimeDate) {
        if (_feedModel.showType == TUFeedShowTypeNormal
         || _feedModel.showType == TUFeedShowTypeBanner) {
          timeStr = [addTimeDate formatChatAsTimeAgoFBStyleWithType:TUTimeShowTypeHomePage];
        }else {
          timeStr = [addTimeDate formatChatAsTimeAgoFBStyleWithType:TUTimeShowTypeNormal];
        }
    }
    
    NSMutableAttributedString *timeAndLocationText = [[NSMutableAttributedString alloc] init];
    // 时间
    if (KILLNil(timeStr).length >0) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:KILLNil(timeStr)];
        timeText.yy_font = [UIFont appFontWithFontSize:12];
        timeText.yy_color = [UIColor appTitleGrayColor];
        timeText.yy_ligature = @0;
        [timeAndLocationText appendAttributedString:timeText];
    }
    
    //地点
    /*if (_feedModel.feed.contentInfo.publishLocation && _feedModel.feed.contentInfo.publishLocation.length >0) {
        NSMutableAttributedString *locationText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@", _feedModel.feed.contentInfo.publishLocation]];
        locationText.yy_font = [UIFont appFontWithFontSize:12];
        locationText.yy_color = [UIColor appTitleGrayColor];
        locationText.yy_ligature = @0;
        if (_feedModel.keywords && _feedModel.keywords.count >0) {
            locationText = [locationText mutAttrStrHighlightKeywords:_feedModel.keywords];
        }
        [timeAndLocationText appendAttributedString:locationText];
    }*/
    
    if (timeAndLocationText && timeAndLocationText.string && timeAndLocationText.string.length >0) {
        CGFloat maxWidth = KDeviceWidth -36.0;
        if (_permitTextLayout && _feedModel.showType != TUFeedShowTypeDiscoverSearchResult) {
            maxWidth -= _permitTextLayout.textBoundingSize.width;
        }else if (_feedModel.showType == TUFeedShowTypeDiscoverSearchResult) {
            maxWidth -= 98.0;
        }
        
        if (maxWidth <1.0) {
            maxWidth = 1.0;
        }
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
        container.maximumNumberOfRows = 1;
        container.truncationType = YYTextTruncationTypeEnd;
        YYTextLayout *textLayout =  [YYTextLayout layoutWithContainer:container text:timeAndLocationText];
        _timeAndLocationTextLayout = textLayout;
    }
    
    
}
//MARK: 地点
- (void)_layoutLocationText {
    
    //地点
    if (_feedModel.feed.contentInfo.locationInformation && _feedModel.feed.contentInfo.locationInformation.publishLocation.length >0 && _feedModel.feed.contentInfo.type != TUFeedContentTypeLocation) {
        NSMutableAttributedString *locationText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _feedModel.feed.contentInfo.locationInformation.publishLocation]];
        locationText.yy_font = [UIFont appFontWithFontSize:12];
        locationText.yy_color = [UIColor appTitleBlackColor];
        locationText.yy_ligature = @0;
        if (_feedModel.keywords && _feedModel.keywords.count >0) {
            locationText = [locationText mutAttrStrHighlightKeywords:_feedModel.keywords];
        }
       
        // 添加点击事件
        YYTextHighlight *locationHighlight = [[YYTextHighlight alloc]init];
        [locationText yy_setTextHighlight:locationHighlight range:NSMakeRange(0, KILLNil(locationText.string).length)];
        
        if (locationText.length >0) {
            
            CGFloat locationTextMaxWidth = KDeviceWidth - 63.0;
            if (!_isArrowHidden) {
                locationTextMaxWidth -= 48.0;
            }
            
            YYTextContainer *locationTextContainer = [YYTextContainer containerWithSize:CGSizeMake(locationTextMaxWidth, CGFLOAT_MAX) insets:UIEdgeInsetsMake(0, 0, 5, 0)];
            locationTextContainer.maximumNumberOfRows = 1;
            YYTextLayout *locationTextLayout = [YYTextLayout layoutWithContainer:locationTextContainer text:locationText];
            _locationTextLayout = locationTextLayout;
        
        }
    }
    
}

//MARK: 隐私
- (void)_layoutPermit {
    
    _permitTextLayout = nil;
    
    ///是否是用户本人
    BOOL isUser = _feedModel.feed.contentInfo.author.userid == [G shared].user.userID;
    
    /// 1.公开，2.好友可见，3.自己可见
    if (_feedModel.feed.contentInfo.permit >=2  && isUser) {
        
        NSString *permitStr = TULocalizedString(@"仅互相关注的人可见", @"仅互相关注的人可见");
        
        if (_feedModel.feed.contentInfo.permit == 3) {
            
            permitStr = TULocalizedString(@"私密", @"私密");
        }
        
        NSMutableAttributedString *permitText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" · %@", permitStr]];
        permitText.yy_font = [UIFont appFontWithFontSize:12];
        permitText.yy_color = [UIColor appTitleGrayColor];
        permitText.yy_ligature = @0;
        YYTextContainer *permitContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        permitContainer.maximumNumberOfRows = 1;
        _permitTextLayout = [YYTextLayout layoutWithContainer:permitContainer text:permitText];
    }
}

//MARK: 翻译
- (void)_layoutTanslateText {
    
    _translateTextLayout = nil;
    NSString *text = TULocalizedString(@"查看翻译", @"查看翻译");
    if (_isTranslated || _feedModel.isTranslated) {
        text = TULocalizedString(@"查看原文", @"查看原文");
    }
    NSMutableAttributedString *translateText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" · %@", text]];
    translateText.yy_font = [UIFont appFontWithBoldFontSize:12];
    if (_feedModel.isAuditReport) {
        translateText = [[NSMutableAttributedString alloc] initWithString:text];
        translateText.yy_font = [UIFont appFontWithFontSize:12];
    }
    
    translateText.yy_color = [UIColor appTitleGrayColor];
    translateText.yy_ligature = @0;
    YYTextContainer *translateTextContainer = [YYTextContainer containerWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    translateTextContainer.maximumNumberOfRows = 1;
    
    _translateTextLayout = [YYTextLayout layoutWithContainer:translateTextContainer text:translateText];
    
}


//MARK: - 闪聊的计算处理
///返回闪聊的背景色
- (UIColor *)getFlashChatBackgroundColorWithExtraImgStr:(NSString *)extraImgStr {
    
    if ([extraImgStr hasStr:@"dianying"] || [extraImgStr hasStr:@"gaoxiao"] || [extraImgStr hasStr:@"yinyue"] || [extraImgStr hasStr:@"yundong"]) {
        
        return [UIColor appBlueGreenColor];
    }
    
    if ([extraImgStr hasStr:@"meishi"] || [extraImgStr hasStr:@"yishu"] || [extraImgStr hasStr:@"zatan"] || [extraImgStr hasStr:@"qinggan"]) {
        
        return [UIColor appGirlPinkColor];
        
    }
    
    if ([extraImgStr hasStr:@"ACG"] || [extraImgStr hasStr:@"bagua"] || [extraImgStr hasStr:@"kexue"] || [extraImgStr hasStr:@"fashion"]) {
        
        return [UIColor appGreenColor];
        
    }
    
    return [UIColor clearColor];
}

//MARK: - 图片的计算处理
///返回图片的高度  如果需要调整图片在这里调整  调整后要注意  图片点击展示全图会不会有问题
//- (CGFloat)getPhotoHeight {
//
//        if (_photoCount == 1) {
//
//            ContentInfo_PhotoInfo *model = _feedModel.feed.contentInfo.photoInfoArray.firstObject;
//            CGFloat photoWidth = KDeviceWidth;
//            CGFloat height = model.height <= 1.0 ? 300:model.height;
//            CGFloat width = model.width <= 1.0 ? 400:model.width;
//            CGFloat photoHeight = floor((height *photoWidth /width) *100) / 100;
//
//            if (photoHeight > KDeviceWidth * 0.8) {
//
//                photoHeight = floor((KDeviceWidth * 0.8) *100) / 100;
//            }
//
//            return photoHeight;
//        }
//
//        if (_photoCount == 2) {
//
//            return (KDeviceWidth - 1.0) * 0.5;
//        }
//
//        if (_photoCount == 3) {
//
//            return (KDeviceWidth - 2.0) / 3.0;
//        }
//
//        if (_photoCount == 4) {
//
//            return ((KDeviceWidth - 1.0) * 0.5) * 2.0 + 1.0;
//        }
//
//        if (_photoCount == 5 || _photoCount == 6) {
//
//            return (KDeviceWidth - 2.0) / 3.0 * 2.0 + 1.0;
//        }
//
//        if (_photoCount >= 7) {
//
//            return (KDeviceWidth - 2.0) / 3.0 * 3.0 + 2.0;
//        }
//
//
//    return 0.0;
//}

///照片需要展示的行的分隔距离
- (NSInteger)getPhotoRowSpacing {
    return 0;
//        if (_photoCount >= 2) {// 4
//
//            return 1;
//
//        } else {
//
//            return 0;
//        }
}

///照片需要展示的列的分隔距离
- (NSInteger)getPhotoColumnsSpacing {
    return 0;
//    if (_photoCount >= 3) {// 2
//
//        return 1;
//
//    } else {
//
//        return 0;
//    }
    
}

///单个图片的大小
- (CGSize)getPhotoItemSize {
    
    ContentInfo_PhotoInfo *info = _feedModel.feed.contentInfo.photoInfoArray.firstObject;
    CGFloat w = info.width, h = info.height;
    CGFloat scale = w / h;
    if (scale < 3.0 / 4.0) {
        
        scale = 3.0 / 4.0;
        _isOldPhotos = YES;
        
    } else if (scale > 2.0) {
        
        scale = 2.0;
        _isOldPhotos = YES;
        
    } else {
        _isOldPhotos = NO;
    }
    
    return CGSizeMake(KDeviceWidth, KDeviceWidth / scale);
    /*
    if (_photoCount == 1) {
     
        return CGSizeMake(KDeviceWidth, [self getPhotoHeight]);
    }
    
    if (_photoCount == 2 || _photoCount == 4) {
     
        CGFloat photoWidth = (KDeviceWidth - 1.0) * 0.5;
     
        return CGSizeMake(photoWidth, photoWidth);
    }
    
    if (_photoCount >= 3.0 && _photoCount != 4) {
     
        CGFloat photoWidth = (KDeviceWidth - 2.0) / 3.0;
     
        return CGSizeMake(photoWidth, photoWidth);
    }*/
    
}

/// 6.8 -> 单个图片的大小 items:第二行的photo个数
//- (CGSize)getPhotoItemSizeWithIndex:(NSInteger)index {
//    if (_photoCount == 1 || _photoCount == 2 || index == 0) {
//        return CGSizeMake(KDeviceWidth, KDeviceWidth);
//    }
//    if (_photoCount >= 3 && _photoCount <= 5) {
//        NSInteger items = _photoCount - 1;
//        CGFloat photoWidth = (KDeviceWidth - (items - 1)) / items;
////        CGFloat photoWidth = (KDeviceWidth - (index - 1)) / index;
//        return CGSizeMake(photoWidth, photoWidth);
//    }
//    switch (_photoCount) {
//        case 6:
//        case 8: {
//            NSInteger items = _photoCount / 2 - 1;
//            if (index <= items) {
//                CGFloat photoWidth = (KDeviceWidth - (items - 1)) / items;
//                return CGSizeMake(photoWidth, photoWidth);
//            } else {
//                CGFloat photoWidth = (KDeviceWidth - items) / (items + 1);
//                return CGSizeMake(photoWidth, photoWidth);
//            }
//        }
//            break;
//        case 7:
//        case 9:{
//            NSInteger items = (_photoCount - 1) / 2;
//            CGFloat photoWidth = (KDeviceWidth - (items - 1)) / items;
//            return CGSizeMake(photoWidth, photoWidth);
//        }
//        default:
//            return CGSizeMake(1.0, 1.0);
//            break;
//    }
//}


//MARK: - 视频的计算处理
///返回视频的高度
- (CGFloat)getVideoHeight {
    
    if (_videoPreviewImageCount > 0) {
        
        ContentInfo_PhotoInfo *model = _feedModel.feed.contentInfo.photoInfoArray.firstObject;
        CGFloat vodeoWidth = KDeviceWidth;
        CGFloat height = model.height <= 1.0 ? 400:model.height;
        CGFloat width = model.width <= 1.0 ? 400:model.width;
        CGFloat scale = (height *1.0)  / (width *1.0);
        CGFloat scaleFloor = floor((scale) *100) / 100;
        CGFloat vodeoHeight = vodeoWidth * scaleFloor;
        
        if (vodeoHeight > KDeviceWidth) {
            
            vodeoHeight = KDeviceWidth;
            
            vodeoHeight = floor((vodeoHeight) *100) / 100;
        }
        
        return vodeoHeight;
    }
    
    return 0.0;
}

- (NSMutableArray *)commentTranslationStatusArr {
    if (!_commentTranslationStatusArr) {
        _commentTranslationStatusArr = [NSMutableArray new];
        for (int i = 0; i < self.commentTextLayoutArrM.count; i++) {
            TUFeedTranslateModel *model = [[TUFeedTranslateModel alloc] init];
            [_commentTranslationStatusArr addObject:model];
        }
    }
    return _commentTranslationStatusArr;
}

@end
