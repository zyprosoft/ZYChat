//
//  GJGCChatFriendContentModel.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatContentBaseModel.h"
#import "GJGCChatFriendConstans.h"
#import "GJCFAudioModel.h"
#import "GJGCMessageExtendModel.h"
#import "EMMessageBody.h"

@interface GJGCChatFriendContentModel : GJGCChatContentBaseModel

#pragma mark - 通用属性

@property (nonatomic,assign)GJGCChatFriendContentType contentType;

@property (nonatomic,strong)NSAttributedString *senderName;

@property (nonatomic,assign)BOOL isGroupChat;

@property (nonatomic,assign)BOOL isFromSelf;

@property (nonatomic,strong)NSString *headUrl;

@property (nonatomic,strong)NSString *downloadTaskIdentifier;

@property (nonatomic,assign)NSInteger sex;

@property (nonatomic,strong)NSString *userId;

#pragma mark -  纯文本消息

@property (nonatomic,strong)NSAttributedString *simpleTextMessage;

@property (nonatomic,strong)NSString *originTextMessage;

@property (nonatomic,strong)NSArray *emojiInfoArray;

@property (nonatomic,strong)NSArray *phoneNumberArray;

@property (nonatomic,strong)NSArray *supportImageTagArray;

#pragma mark - 图片消息

@property (nonatomic,strong)NSString *imageMessageUrl;

@property (nonatomic,strong)NSString *imageLocalCachePath;

@property (nonatomic,strong)NSString *thumbImageCachePath;

@property (nonatomic,assign)NSInteger originImageWidth;

@property (nonatomic,assign)NSInteger originImageHeight;

#pragma mark - 语音消息

@property (nonatomic,strong)GJCFAudioModel *audioModel;

@property (nonatomic,strong)NSAttributedString *audioDuration;

@property (nonatomic,assign)BOOL isPlayingAudio;

@property (nonatomic,assign)BOOL isDownloading;

@property (nonatomic,assign)BOOL isRead;

#pragma mark - 帖子消息

@property (nonatomic,strong)NSAttributedString *postAttributedTitle;

@property (nonatomic,strong)NSString *postSrc;

@property (nonatomic,strong)NSString *postPrice;

@property (nonatomic,strong)NSString *postPuid;

@property (nonatomic,strong)NSString *postId;

@property (nonatomic,strong)NSString *postTitle;

@property (nonatomic,strong)NSString *postImg;

@property (nonatomic,strong)NSString *basePostId;

@property (nonatomic,strong)NSString *basePostTitle;

@property (nonatomic,strong)NSString *basePostImg;

@property (nonatomic,strong)NSString *postPicIdentifier;

#pragma mark - 新人欢迎卡片

@property (nonatomic,strong)NSAttributedString *titleString;

@property (nonatomic,strong)NSAttributedString *nameString;

@property (nonatomic,strong)NSAttributedString *starString;

@property (nonatomic,strong)NSAttributedString *ageString;

#pragma mark - 群主召唤Card

@property (nonatomic,strong)NSAttributedString *summonContentString;

@property (nonatomic,strong)NSAttributedString *summonTitleString;

@property (nonatomic,strong)NSAttributedString *summonDescriptionString;

@property (nonatomic,assign)NSTimeInterval summonExpireTime;

#pragma mark - 响应群主召唤Card

@property (nonatomic,strong)NSAttributedString *acceptSummonTitle;

#pragma mark - GIF表情

@property (nonatomic,strong)NSString *gifLocalId;

#pragma mark - 漂流瓶

@property (nonatomic,strong)NSAttributedString *driftBottleContentString;

#pragma mark - 环信消息时间戳标示

@property (nonatomic,assign)long long easeMessageTime;

@property (nonatomic,strong)EMMessageBody *messageBody;

#pragma mark - 扩展网页消息

@property (nonatomic,strong)NSString *webPageTitle;

@property (nonatomic,strong)NSData *webPageThumbImageData;

@property (nonatomic,strong)NSString *webPageSumary;

@property (nonatomic,strong)NSString *webPageUrl;

#pragma mark - 扩展音乐分享消息

@property (nonatomic,strong)NSString *musicSongName;

@property (nonatomic,strong)NSString *musicSongAuthor;

@property (nonatomic,strong)NSString *musicSongUrl;

@property (nonatomic,strong)NSString *musicSongId;

@property (nonatomic,assign)BOOL     isMusicPlaying;

#pragma mark - 短视频消息

@property (nonatomic,strong)NSURL *videoUrl;

@property (nonatomic,assign)BOOL isPlayingVideo;

#pragma mark - 鲜花消息

@property (nonatomic,strong)NSString *flowerTitle;


+ (GJGCChatFriendContentModel *)timeSubModel;

- (void)setupUserInfoByExtendUserContent:(GJGCMessageExtendUserModel *)userInfo;

@end
