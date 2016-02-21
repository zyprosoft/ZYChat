//
//  GJGCGroupPersonInformationShowMap.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCGroupPersonInformationShowMap.h"
#import "GJGCInformationCellStyle.h"
#import "GJGCChatSystemNotiCellStyle.h"
#import "GJGCInformationGroupShowItem.h"

@implementation GJGCGroupPersonInformationShowMap

+ (NSDictionary *)groupContentItemIndexMap
{
    return @{
             @"个人相册" : @"0",
             
             @"账号" : @"1",
             
             @"等级" : @"2",
             
             @"加入群组" : @"3",
             
             @"职业" : @"4",
             
             @"活动区域" : @"5",
             
             @"家乡" : @"6",
             
             @"注册时间" : @"7",
             
             @"简介" : @"8",
             
             };
}

+ (NSDictionary *)personContentItemIndexMap
{
    return @{
             @"群相册" : @"0",
             
             @"群账号" : @"1",
             
             @"群等级" : @"2",
             
             @"群位置" : @"3",
             
             @"群主" : @"4",
             
             @"群成员" : @"5",
             
             @"群标签" : @"6",
             
             @"创建时间" : @"7",
             
             @"群简介" : @"8",
             
             };

}

+ (NSInteger)indexForPersonTagName:(NSString *)tagName
{
    return [[[GJGCGroupPersonInformationShowMap personContentItemIndexMap]objectForKey:tagName]intValue];
}

+ (NSInteger)indexForGroupTagName:(NSString *)tagName
{
    return [[[GJGCGroupPersonInformationShowMap groupContentItemIndexMap]objectForKey:tagName]intValue];
}

+ (void)formateCommonTopCellSeprateStyle:(GJGCInformationCellContentModel *)item
{
    
}

+ (void)formateCommonBottomCellSeprateStyle:(GJGCInformationCellContentModel *)item
{
    
}


+ (GJGCInformationCellContentModel *)itemWithContentValueBaseText:(NSString *)textContent tagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeBaseTextContent;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomShort;
    item.tag = [GJGCInformationCellStyle formateBaseTextTag:tagName];
    item.baseContent = [GJGCInformationCellStyle formateBaseTextContent:textContent];
    if ([@"群  账  号" isEqualToString:tagName]) {
        item.isGroupAccount = YES;
        item.shouldShowIndicator = YES;
    }
    
    NSString *realTagStr = [tagName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([realTagStr rangeOfString:@"账号"].location != NSNotFound) {
        item.haveLongPress = YES;
    }
    else {
        item.haveLongPress = NO;
    }
    
    return item;
}

+ (GJGCInformationCellContentModel *)itemWithContentValueSummaryText:(NSString *)summaryContent tagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeBaseTextContent;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomShort;
    item.tag = [GJGCInformationCellStyle formateBaseTextTag:tagName];
    item.baseContent = [GJGCInformationCellStyle formateSummaryText:summaryContent];
    
    return item;
}

+ (GJGCInformationCellContentModel *)itemWithTextAndIcon:(NSString *)text icon:(NSString *)iconName tagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeBaseTextAndIcon;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomShort;
    item.tag = [GJGCInformationCellStyle formateBaseTextTag:tagName];
    item.iconImageName = iconName;
    item.headUrl = iconName;
    item.baseContent = [GJGCInformationCellStyle formateNameTrailMode:text];
    
    return item;
}

+ (GJGCInformationCellContentModel *)itemWithLevelValue:(NSString *)level tagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeLevelType;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomShort;
    item.tag = [GJGCInformationCellStyle formateBaseTextTag:tagName];
    item.level = [GJGCChatSystemNotiCellStyle formateGroupLevel:[NSString stringWithFormat:@"Lv.%@",level]];
    
    return item;
}

+ (GJGCInformationCellContentModel *)itemWithPersonPhotoBox:(NSArray *)photoUrls
                                                       name:(NSString *)name
                                                   distance:(NSString *)distance
                                                       time:(NSString *)time
                                                        sex:(NSString *)sex
                                                        age:(NSString *)age
                                                   starName:(NSString *)starName
                                                 helloCount:(NSString *)helloCount
                                               expandLabels:(NSString *)expandLabels
                                             labelColorType:(NSString *)labelColorType
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypePersonPhotoBox;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopFullBottomFull;
    item.name = [GJGCInformationCellStyle formatePersonPhotoBoxName:name];
    item.distance = [GJGCInformationCellStyle formatePersonPhotoBoxDistanceOrTime:distance];
    item.personLastActiveTime = [GJGCInformationCellStyle formatePersonPhotoBoxDistanceOrTime:time];
    item.personSex = [sex integerValue];
    item.personAge = ([sex intValue] == 1)? [GJGCInformationCellStyle formatePersonPhotoBoxManAge:age]:[GJGCInformationCellStyle formatePersonPhotoBoxWomenAge:age];
    item.personStarName = [GJGCInformationCellStyle formatePersonPhotoBoxStarNameOrHelloCount:starName];
    item.personHelloCount = [GJGCInformationCellStyle formatePersonPhotoBoxStarNameOrHelloCount:helloCount];
    item.photoBoxArray = photoUrls;
    item.expandLabels = expandLabels;
    item.labelColorType = labelColorType;
    return item;
}

+ (GJGCInformationCellContentModel *)itemWithGroupPhotoBox:(NSArray *)photoUrls name:(NSString *)name distance:(NSString *)distance tagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeGroupPhotoBox;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopFullBottomFull;
    item.name = [GJGCInformationCellStyle formateGroupPhotoBoxName:name];
    item.distance = [GJGCInformationCellStyle formateGroupPhotoBoxDistance:distance];
    item.photoBoxArray = photoUrls;
    
    return item;

}

+ (GJGCInformationCellContentModel *)itemWithGroupShow:(NSArray *)groupInfoArray text:(NSString *)text tagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeGroupShow;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomFull;
    item.tag = [GJGCInformationCellStyle formateBaseTextTag:tagName];
    
    /* 处理内部 */
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < groupInfoArray.count ; i++) {
        
        NSDictionary *itemDict = [groupInfoArray objectAtIndex:i];
        GJGCInformationGroupShowItemModel *itemModel = [[GJGCInformationGroupShowItemModel alloc]init];
        itemModel.name = [GJGCInformationCellStyle formateNameTrailMode:[itemDict objectForKey:@"name"]];
        itemModel.headUrl = [itemDict objectForKey:@"avatar"];
        itemModel.groupId = [[itemDict objectForKey:@"groupId"] longLongValue];

        [itemArray addObject:itemModel];
    }
    item.personShowGroupArray = itemArray;
    
    
    return item;
}

+ (GJGCInformationCellContentModel *)itemWithMemberShow:(NSArray *)memberInfoArray text:(NSString *)text tagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeMemberShow;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomShort;
    item.tag = [GJGCInformationCellStyle formateBaseTextTag:tagName];
    item.groupShowMemeberArray = memberInfoArray;
    item.baseContent = [GJGCInformationCellStyle formateBaseTextContent:text];
    
    
    return item;
}

+ (GJGCInformationCellContentModel *)itemWithDistrictId:(NSString *)districtName streetId:(NSString *)streetName withTagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeBaseTextContent;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomShort;
    item.tag = [GJGCInformationCellStyle formateBaseTextTag:tagName];
    
    // 设置活动区域默认值
    if (districtName.length > 0 && streetName.length > 0) {
        districtName = [NSString stringWithFormat:@"%@-%@",districtName,streetName];
    }
    else {
        districtName = @"待完善";
    }
    item.baseContent = [GJGCInformationCellStyle formateBaseTextContent:districtName];
    
    return item;
}

+ (GJGCInformationCellContentModel *)itemWithFeedListCount:(NSInteger)count imageUrl:(NSString *)imageUrl content:(NSString *)content tagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeFeedList;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopFullBottomFull;
    item.tag = [GJGCInformationCellStyle formateBaseTextTag:tagName];
    item.feedListCount = [GJGCInformationCellStyle formateBaseTextTag:[NSString stringWithFormat:@"%ld条",(long)count]];
    item.baseContent = [GJGCInformationCellStyle formateFeedContent:content];
    item.feedListImageUrl = imageUrl;
    
    return item;
}

/**
 *  行业
 */
+ (GJGCInformationCellContentModel *)itemWithCompany:(NSString *)company withTagName:(NSString *)tagName
{
    GJGCInformationCellContentModel *item = [[GJGCInformationCellContentModel alloc]init];
    item.baseContentType = GJGCInformationContentTypeBaseTextContent;
    item.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomShort;
    item.tag = [GJGCInformationCellStyle formateBaseTextTag:tagName];
    item.baseContent = [GJGCInformationCellStyle formateBaseTextContent:company];
    
    return item;
}

+ (void)resetSubSectionForPersonInformationArray:(NSArray *)informationArray
{
    /* 忽略相册块 */
    for (NSInteger i = 1; i < informationArray.count; i++) {
        
//        GJGCInformationCellContentModel *item = [informationArray objectAtIndex:i];
        
        
    }
}

+ (void)resetSubSectionForGroupInformationArray:(NSArray *)informationArray
{
    /* 忽略相册块 */
    for (NSInteger i = 1; i < informationArray.count; i++) {
        
    }
}

@end
