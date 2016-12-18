//
//  GJGCMessageExtendConst.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

//是否扩展消息内容
extern const NSString  *kGJGCMessageExtendIsExtendMessageContent;

extern const NSString  *kGJGCMessageExtendIsGroupMessage;

extern const NSString  *kGJGCMessageExtendGroupInfo;

//扩展属性公共模块
extern const NSString  *kGJGCMessageExtendUserInfo;
extern const NSString  *kGJGCMessageExtendUserName;
extern const NSString  *kGJGCMessageExtendUserHeadThumb;
extern const NSString  *kGJGCMessageExtendUserSex;
extern const NSString  *kGJGCMessageExtendUserNickname;
extern const NSString  *kGJGCMessageExtendUserAge;

//内容部分公共标示
extern const NSString  *kGJGCMessageExtendMessageType;
extern const NSString  *kGJGCMessageExtendContentData;
extern const NSString  *kGJGCMessageExtendContentType;
extern const NSString  *kGJGCMessageExtendTitle;
extern const NSString  *kGJGCMessageExtendTextContent;
extern const NSString  *kGJGCMessageExtendContentProtocol;
extern const NSString  *kGJGCMessageExtendDisplayText;
extern const NSString  *kGJGCMessageExtendNotSupportDisplayText;
extern const NSString  *kGJGCMessageExtendUrl;
extern const NSString  *kGJGCMessageExtendThumbImageBase64Data;
extern const NSString  *kGJGCMessageExtendThumbImageUrl;
extern const NSString  *kGJGCMessageExtendSumary;
extern const NSString  *kGJGCMessageExtendTime;
extern const NSString  *kGJGCMessageExtendSource;

//扩展部分内容类型
extern const NSString  *vGJGCMessageExtendContentGIF;
extern const NSString  *vGJGCMessageExtendContentMini;
extern const NSString  *vGJGCMessageExtendContentWebPage;
extern const NSString  *vGJGCMessageExtendContentUserCard;
extern const NSString  *vGJGCMessageExtendContentWelcomeMember;
extern const NSString  *vGJGCMessageExtendContentMusicShare;
extern const NSString  *vGJGCMessageExtendProtocolExchange;
extern const NSString  *vGJGCMessageExtendContentSendFlower;

//Gif消息扩展所用到得Key
extern const NSString  *kGJGCMessageExtendGifEmojiCode;
extern const NSString  *kGJGCMessageExtendGifVersion;
extern const NSString  *kGJGCMessageExtendExchangeGifPackageVersion;

//网页消息扩展所用到的Key

//音乐分享扩展所使用到得Key
extern const NSString  *kGJGCMessageExtendMusicUrl;
extern const NSString  *kGJGCMessageExtendMusicSongAuthor;
extern const NSString  *kGJGCMessageExtendMusicSongId;
extern const NSString  *kGJGCMessageExtendMusicSongImageUrl;



@interface GJGCMessageExtendConst : NSObject

+ (NSArray *)extendContentSupportTypes;

+ (NSArray *)extendGifPackageVersions;

+ (Class)jsonModelClassForMessageContentType:(NSString *)messsageType;

@end
