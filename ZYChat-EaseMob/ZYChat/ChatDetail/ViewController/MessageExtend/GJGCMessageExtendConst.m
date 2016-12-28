//
//  GJGCMessageExtendConst.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCMessageExtendConst.h"

const NSString  *kGJGCMessageExtendIsExtendMessageContent = @"is_extend_message_content";

const NSString  *kGJGCMessageExtendIsGroupMessage = @"is_group_message";


const NSString  *kGJGCMessageExtendGroupInfo = @"group";

//扩展属性公共模块
const NSString  *kGJGCMessageExtendUserInfo = @"user";
const NSString  *kGJGCMessageExtendUserName = @"username";
const NSString  *kGJGCMessageExtendUserHeadThumb = @"head_thumb";
const NSString  *kGJGCMessageExtendUserSex = @"sex";
const NSString  *kGJGCMessageExtendUserNickname = @"nickname";
const NSString  *kGJGCMessageExtendUserAge = @"age";

//内容部分公共标示
const NSString  *kGJGCMessageExtendContentData = @"data";
const NSString  *kGJGCMessageExtendMessageType = @"message_type";
const NSString  *kGJGCMessageExtendContentType = @"type";
const NSString  *kGJGCMessageExtendTitle = @"title";
const NSString  *kGJGCMessageExtendTextContent = @"content";
const NSString  *kGJGCMessageExtendContentProtocol = @"protocol";
const NSString  *kGJGCMessageExtendDisplayText = @"display_text";
const NSString  *kGJGCMessageExtendNotSupportDisplayText = @"not_support_display_text";
const NSString  *kGJGCMessageExtendUrl = @"url";
const NSString  *kGJGCMessageExtendThumbImageBase64Data = @"image_base_64";
const NSString  *kGJGCMessageExtendThumbImageUrl = @"image_thumb_url";
const NSString  *kGJGCMessageExtendSumary = @"sumary";
const NSString  *kGJGCMessageExtendTime= @"time";
const NSString  *kGJGCMessageExtendSource = @"source";

//扩展部分内容类型
const NSString  *vGJGCMessageExtendContentGIF = @"gif";
const NSString  *vGJGCMessageExtendContentMini = @"mini";
const NSString  *vGJGCMessageExtendContentWebPage = @"web_page";
const NSString  *vGJGCMessageExtendContentUserCard = @"user_card";
const NSString  *vGJGCMessageExtendContentWelcomeMember = @"welcome_member";
const NSString  *vGJGCMessageExtendContentMusicShare = @"music_share";
const NSString  *vGJGCMessageExtendContentSendFlower = @"send_flower";

const NSString  *vGJGCMessageExtendProtocolExchange = @"protocol_exchange";

//Gif消息扩展所用到得Key
const NSString  *kGJGCMessageExtendGifEmojiCode = @"emoji_code";
const NSString  *kGJGCMessageExtendGifVersion = @"version";
const NSString  *kGJGCMessageExtendExchangeGifPackageVersion = @"package_version";

//音乐分享消息
const NSString  *kGJGCMessageExtendMusicUrl = @"music_url";
const NSString  *kGJGCMessageExtendMusicSongAuthor = @"song_author";
const NSString  *kGJGCMessageExtendMusicSongId = @"song_id";
const NSString  *kGJGCMessageExtendMusicSongImageUrl = @"song_img_url";


@implementation GJGCMessageExtendConst

+ (NSArray *)extendContentSupportTypes
{
    return @[
              vGJGCMessageExtendContentGIF,
              vGJGCMessageExtendContentMini,
              vGJGCMessageExtendContentWebPage,
              vGJGCMessageExtendContentMusicShare,
              vGJGCMessageExtendContentSendFlower,
             ];
}

+ (NSArray *)extendGifPackageVersions
{
    return @[
             @"1.0",
             ];
}

+ (NSDictionary *)jsonModelForContentTypeDict
{
    return @{
             vGJGCMessageExtendContentGIF    :@"GJGCMessageExtendContentGIFModel",
             vGJGCMessageExtendContentWebPage:@"GJGCMessageExtendContentWebPageModel",
             vGJGCMessageExtendContentMusicShare:@"GJGCMessageExtendMusicShareModel",
             vGJGCMessageExtendContentSendFlower:@"GJGCMessageExtendSendFlowerModel",
             vGJGCMessageExtendContentMini:@"GJGCMessageExtendMiniMessageModel",
             };
}

+ (Class)jsonModelClassForMessageContentType:(NSString *)messsageType
{
    NSString *className = [[self jsonModelForContentTypeDict]objectForKey:messsageType];
    
    return NSClassFromString(className);
}

@end
