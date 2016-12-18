//
//  GJGCRecentChatStyle.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/18.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCRecentChatStyle.h"
#import "GJGCChatSystemNotiCellStyle.h"
#import "GJGCChatContentEmojiParser.h"

@implementation GJGCRecentChatStyle

+ (NSAttributedString *)formateName:(NSString *)name
{
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColorWhite];
    stringStyle.font = [UIFont boldSystemFontOfSize:16];
    
    return [[NSAttributedString alloc]initWithString:name attributes:[stringStyle attributedDictionary]];
}

+ (NSAttributedString*)formateTime:(long long)time
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
        
        string = [NSString stringWithFormat:@"%@",GJCFDateToStringByFormat(date,@"HH:mm")];
        
    }
    else if (day == t_day - 1 && t_month == month && t_year == year){
        
        string = [NSString stringWithFormat:@"昨天"];
        
    }else if (day == t_day - 2 && t_month == month && t_year == year){
        
        string = [NSString stringWithFormat:@"前天"];
        
    }else if(year==t_year){
        
        string=[NSString stringWithFormat:@"%ld-%ld",(long)month,(long)day];
        
    }else{
        
        string=[NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    }
    
    return [GJGCChatSystemNotiCellStyle formateTime:string];
}

+ (void)formateContent:(NSString *)messageText
{
    if (GJCFStringIsNull(messageText)) {
    }
    
    [GJGCChatContentEmojiParser parseRecentContent:messageText];
}


@end
