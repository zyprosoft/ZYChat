//
//  GJGCChatSystemNotiCellStyle.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-6.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatSystemNotiCellStyle.h"

@implementation GJGCChatSystemNotiCellStyle

/* 头像宽度 */
+ (CGFloat)headViewWidth
{
    return 48;
}

/* 时间转文案 */
+ (NSString *)timeAgoStringByLastMsgTime:(long long)lastDateTime lastMsgTime:(long long)lastTimeStamp
{
    NSDate *date = GJCFDateFromTimeInterval(lastDateTime);
    
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    
    long long timeNow = lastDateTime;
    NSCalendar * calendar=[GJCFDateUitil sharedCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSInteger year=[component year];
    NSInteger month=[component month];
    NSInteger day=[component day];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    NSInteger t_year=[component year];
    NSInteger t_month = [component month];
    NSInteger t_day= [component day];
    
    NSString *string = nil;
    
    long long now = [today timeIntervalSince1970];
    
    long long  distance= now - timeNow;
    long long  lastMsgDistance =  lastDateTime - lastTimeStamp;
    
    if (lastMsgDistance < 60*3) {
        return nil;
    }

    if(distance <= 60*60*24 && day == t_day && t_month == month && t_year == year){
        
        string = [NSString stringWithFormat:@"今天  %@",GJCFDateToStringByFormat(date,@"HH:mm")];
        
    }
    else if (day == t_day - 1 && t_month == month && t_year == year){
        
        string = [NSString stringWithFormat:@"昨天  %@",GJCFDateToStringByFormat(date,@"HH:mm")];
        
    }else if (day == t_day - 2 && t_month == month && t_year == year){
        
        string = [NSString stringWithFormat:@"前天  %@",GJCFDateToStringByFormat(date,@"HH:mm")];
        
    }else if(year == t_year){
        
        NSString *detailTime = GJCFDateToStringByFormat(date,@"HH:mm");
        string=[NSString stringWithFormat:@"%ld-%ld  %@",(long)month,(long)day,detailTime];

    }else{
        
        NSString *detailTime = GJCFDateToStringByFormat(date,@"HH:mm");

        string=[NSString stringWithFormat:@"%ld-%ld-%ld  %@",(long)year,(long)month,(long)day,detailTime];
    }

    return string;
}

+ (NSAttributedString*)formateSystemNotiTime:(long long)time
{
    NSDate *date = GJCFDateFromTimeInterval(time);
    
    if (GJCFCheckObjectNull(date)) {
        return nil;
    }
    
    long long timeNow = [[NSDate date]timeIntervalSince1970];
    NSCalendar * calendar=[GJCFDateUitil sharedCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    NSInteger year=[component year];
    NSInteger month=[component month];
    NSInteger day=[component day];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    NSInteger t_year=[component year];
    NSInteger t_month = [component month];
    NSInteger t_day= [component day];
    
    NSString *string = nil;
    
    long long now = [today timeIntervalSince1970];
    
    long long  distance= now - timeNow;
    
    if(distance <= 60*60*24 && day == t_day && t_month == month && t_year == year){
                
        string = [NSString stringWithFormat:@"今天  %@",GJCFDateToStringByFormat(date,@"HH:mm")];
        
    }
    else if (day == t_day - 1 && t_month == month && t_year == year){
        
        string = [NSString stringWithFormat:@"昨天  %@",GJCFDateToStringByFormat(date,@"HH:mm")];
        
    }else if (day == t_day - 2 && t_month == month && t_year == year){
        
        string = [NSString stringWithFormat:@"前天  %@",GJCFDateToStringByFormat(date,@"HH:mm")];
        
    }else if(year==t_year){
        
        NSString *detailTime = GJCFDateToStringByFormat(date,@"HH:mm");
        string=[NSString stringWithFormat:@"%ld-%ld  %@",(long)month,(long)day,detailTime];
        
    }else{
        
        NSString *detailTime = GJCFDateToStringByFormat(date,@"HH:mm");
        
        string=[NSString stringWithFormat:@"%ld-%ld-%ld  %@",(long)year,(long)month,(long)day,detailTime];
    }
    
    return [GJGCChatSystemNotiCellStyle formateTime:string];
}

/* 时间标签 */
+ (NSAttributedString *)formateTime:(NSString *)timeString
{
    if (GJCFStringIsNull(timeString)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatSystemNotiCellStyle timeLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:timeString attributes:attributedDict];
}

/* 基础内容展示标签 */
+ (NSAttributedString *)formateBaseContent:(NSString *)baseContent
{
    if (GJCFStringIsNull(baseContent)) {
        return nil;
    }
    NSDictionary *stringAttributedDict = [[GJGCChatSystemNotiCellStyle baseContentLabelStyle] attributedDictionary];
    NSDictionary *paragraphDict = [[GJGCChatSystemNotiCellStyle baseContentLabelParagraphStyle] paragraphAttributedDictionary];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:baseContent attributes:stringAttributedDict];
    [attributedString addAttributes:paragraphDict range:NSMakeRange(0, baseContent.length)];
    
    return attributedString;
}

/* 名字标签风格 */
+ (NSAttributedString *)formateNameString:(NSString *)name
{
    if (GJCFStringIsNull(name)) {
        return nil;
    }
    NSDictionary *stringAttributedDict = [[GJGCChatSystemNotiCellStyle nameLabelStyle] attributedDictionary];
    NSDictionary *paragraphDict = [[GJGCChatSystemNotiCellStyle nameLabelParagraphStyle] paragraphAttributedDictionary];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:name attributes:stringAttributedDict];
    [attributedString addAttributes:paragraphDict range:NSMakeRange(0, name.length)];
    
    return attributedString;
}

/* 男年龄标签 */
+ (NSAttributedString *)formateManAge:(NSString *)manAge
{
    if (GJCFStringIsNull(manAge)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatSystemNotiCellStyle roleManAgeLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:manAge attributes:attributedDict];
}

/* 女年龄标签 */
+ (NSAttributedString *)formateWomenAge:(NSString *)womenAge
{
    if (GJCFStringIsNull(womenAge)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatSystemNotiCellStyle roleWomenAgeLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:womenAge attributes:attributedDict];
}

/* 星座标签 */
+ (NSAttributedString *)formateStarName:(NSString *)starName
{
    if (GJCFStringIsNull(starName)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatSystemNotiCellStyle roleStarNameLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:starName attributes:attributedDict];
}

/* 群组成员标签风格 */
+ (NSAttributedString *)formateGroupMember:(NSString *)memberCount
{
    if (GJCFStringIsNull(memberCount)) {
        return nil;
    }
    memberCount = [NSString stringWithFormat:@"%@",memberCount];
    NSDictionary *attributedDict = [[GJGCChatSystemNotiCellStyle roleGroupMemberLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:memberCount attributes:attributedDict];
}

/* 群组等级标签 */
+ (NSAttributedString *)formateGroupLevel:(NSString *)levelString
{
    levelString = [NSString stringWithFormat:@"%@",levelString];
    NSDictionary *attributedDict = [[GJGCChatSystemNotiCellStyle roleGroupLevelLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:levelString attributes:attributedDict];
}

/* 申请通知信息标签 */
+ (NSAttributedString *)formateApplyTip:(NSString *)applyTip
{
    if (GJCFStringIsNull(applyTip)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatSystemNotiCellStyle applyTipLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:applyTip attributes:attributedDict];
}

/* 申请理由标签 */
+ (NSAttributedString *)formateApplyReason:(NSString *)applyReason
{
    if (GJCFStringIsNull(applyReason)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatSystemNotiCellStyle applyReasonLabelStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:applyReason attributes:attributedDict];
}

/* 按钮 */
+ (NSAttributedString *)formateButtonTitle:(NSString *)buttonTitle
{
    if (GJCFStringIsNull(buttonTitle)) {
        return nil;
    }
    NSDictionary *attributedDict = [[GJGCChatSystemNotiCellStyle applyButtonStyle] attributedDictionary];
    return [[NSAttributedString alloc]initWithString:buttonTitle attributes:attributedDict];
}

+ (NSAttributedString *)formateActiveDescription:(NSString *)description
{
    if (GJCFStringIsNull(description)) {
        return nil;
    }
    
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.maxLineSpace = 5.f;
    paragraphStyle.minLineSpace = 5.f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:description attributes:[stringStyle attributedDictionary]];
    [attributedString addAttributes:[paragraphStyle paragraphAttributedDictionary] range:NSMakeRange(0, description.length)];
    
    return attributedString;
}


////////////////////////////////////////////////////////////////////////////////
 

/* 时间标签 */
+ (GJCFCoreTextAttributedStringStyle *)timeLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
    
    return stringStyle;
}

/* 基础内容展示标签 */
+ (GJCFCoreTextAttributedStringStyle *)baseContentLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

/* 基础内容展示标签段落风格，换行有间距 */
+ (GJCFCoreTextParagraphStyle *)baseContentLabelParagraphStyle
{
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.maxLineSpace = 5.f;
    paragraphStyle.minLineSpace = 5.f;
    
    return paragraphStyle;
}

/* 名字标签风格 */
+ (GJCFCoreTextAttributedStringStyle *)nameLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle detailBigTitleColor];
    
    
    return stringStyle;
}

/* 名字标签换行属性 */
+ (GJCFCoreTextParagraphStyle *)nameLabelParagraphStyle
{
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = kCTLineBreakByTruncatingTail;
    
    return paragraphStyle;
}

/* 男年龄标签 */
+ (GJCFCoreTextAttributedStringStyle *)roleManAgeLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = GJCFQuickHexColor(@"7ecef4");
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

/* 女年龄标签 */
+ (GJCFCoreTextAttributedStringStyle *)roleWomenAgeLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = GJCFQuickHexColor(@"ffa9c5");
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

/* 星座标签 */
+ (GJCFCoreTextAttributedStringStyle *)roleStarNameLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

/* 群组成员标签风格 */
+ (GJCFCoreTextAttributedStringStyle *)roleGroupMemberLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

/* 群组等级标签 */
+ (GJCFCoreTextAttributedStringStyle *)roleGroupLevelLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [UIFont systemFontOfSize:10];
    stringStyle.foregroundColor = [UIColor whiteColor];
    
    return stringStyle;
}

/* 申请通知信息标签 */
+ (GJCFCoreTextAttributedStringStyle *)applyTipLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle detailBigTitleColor];
    
    return stringStyle;
}

/* 申请理由标签 */
+ (GJCFCoreTextAttributedStringStyle *)applyReasonLabelStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    
    return stringStyle;
}

/* 按钮 */
+ (GJCFCoreTextAttributedStringStyle *)applyButtonStyle
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle mainThemeColor];
    stringStyle.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
    
    return stringStyle;
}

@end
