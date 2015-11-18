//
//  GJCFDateUitilMacrocDefine.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-22.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

/**
 *  日期相关工具宏
 */

#import "GJCFDateUitil.h"

/**
 *  获取当前日历
 */
#define GJCFDateCurrentCalendar [GJCFDateUitil sharedCalendar]

/**
 *  获取单例格式化器
 */
#define GJCFDateShareFormatter [GJCFDateUitil sharedDateFormatter]

/**
 *  相对现在日期得间隔天数
 */
#define GJCFDateDaysAgo(aDate) [GJCFDateUitil daysAgoFromNow:aDate]

/**
 *  不以午夜为基准计算天数之前
 */
#define GJCFDateDaysAgoAgainstMidNight(aDate) [GJCFDateUitil daysAgoAgainstMidnight:aDate]

/**
 *  获取一个时间与当前时间间隔详情字符串
 */
#define GJCFDateTimeAgoString(aDate) [GJCFDateUitil detailTimeAgoString:aDate]

/**
 *  获取一个时间戳与当前时间的间隔详情字符串
 */
#define GJCFDateTimeAgoStringByTimeInterval(timeInterval) [GJCFDateUitil detailTimeAgoStringByInterval:timeInterval]

/**
 *  天数间隔文本字符串
 */
#define GJCFDateStringDaysAgo(aDate) [GJCFDateUitil stringDaysAgo:aDate]

/**
 *  这个日期是星期几
 */
#define GJCFDateGetWeekDay(aDate) [GJCFDateUitil weekDay:aDate]

/**
 *  返回这个日期是星期几字符串
 */
#define  GJCFDateGetWeekDayString(aDate) [GJCFDateUitil weekDayString:aDate]

/**
 *  返回这个日期在全年中是第多少周字符串
 */
#define  GJCFDateGetWeekNumString(aDate) [GJCFDateUitil weekNumberString:aDate]

/**
 *  在全年中是第多少周
 */
#define GJCFDateGetWeekNum(aDate) [GJCFDateUitil weekNumber:aDate]

/**
 *  获取日期中得年份
 */
#define GJCFDateGetYear(aDate) [GJCFDateUitil year:aDate]

/**
 *  获取日期中得月份
 */
#define GJCFDateGetMonth(aDate) [GJCFDateUitil month:aDate]

/**
 *  获取日期中的日
 */
#define GJCFDateGetDay(aDate) [GJCFDateUitil day:aDate]

/**
 *  获取日期中得小时
 */
#define GJCFDateGetHour(aDate) [GJCFDateUitil hour:aDate]

/**
 *  获取日期中的分钟
 */
#define GJCFDateGetMinute(aDate) [GJCFDateUitil minute:aDate]

/**
 *  日期转字符串
 */
#define GJCFDateToString(aDate) [GJCFDateUitil stringFromDate:aDate]

/**
 *  字符串转日期
 */
#define GJCFDateFromString(aString) [GJCFDateUitil dateFromString:aString]

/**
 *  字符串转日期详细时间
 */
#define GJCFDateTimeFromString(aString) [GJCFDateUitil dateTimeFromString:aString]

/**
 *  将时间戳转成日期
 */
#define GJCFDateFromTimeInterval(timeInterval) [GJCFDateUitil dateFromTimeInterval:timeInterval]

/**
 *  按照某个格式将日期转成字符串
 */
#define GJCFDateToStringByFormat(aDate,format) [GJCFDateUitil stringFromDate:aDate withFormat:format]

/**
 *  按照某个格式将字符串转成日期
 */
#define GJCFDateFromStringByFormat(aString,format) [GJCFDateUitil dateFromString:aString withFormat:format]

/**
 *  这个日期所在周的起始日期
 */
#define GJCFDateBeginningOfWeek(aDate) [GJCFDateUitil beginningOfWeek:aDate]

/**
 *  这个日期的起始时间
 */
#define GJCFDateBeginningOfDay(aDate) [GJCFDateUitil beginningOfDay:aDate]

/**
 *  这个日期所在周的结束日期
 */
#define GJCFDateEndOfWeek(aDate) [GJCFDateUitil endOfWeek:aDate]

/**
 *  普通日期格式字符串
 */
#define GJCFDateFormatString [GJCFDateUitil dateFormatString]

/**
 *  普通时间格式字符串
 */
#define GJCFDateTimeFormatString [GJCFDateUitil timeFormatString]

/**
 *  时间戳格式字符串
 */
#define GJCFDateTimeStampFormatString [GJCFDateUitil timestampFormatString]

/**
 *  数据库存储格式字符串
 */
#define GJCFDateDataBaseFormatString [GJCFDateUitil dbFormatString]

/**
 *  生日转年龄
 */
#define GJCFDateBirthDayToAge(date) [GJCFDateUitil birthdayToAge:date]

/**
 *  生日转年龄
 */
#define GJCFDateBirthDayToAgeByTimeInterval(timeInterval) [GJCFDateUitil birthdayToAgeByTimeInterval:timeInterval]

/**
 *  日期转星座
 */
#define GJCFDateToConstellation(date) [GJCFDateUitil dateToConstellation:date]

/**
 *  时间戳转星座
 */
#define GJCFDateToConstellationByTimeInterval(timeInterval) [GJCFDateUitil dateToConstellationByTimeInterval:timeInterval]



