//
//  GJGCChatContentEmojiParser.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-26.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatContentEmojiParser.h"
#import "GJGCChatFriendCellStyle.h"

@implementation GJGCChatContentEmojiParser

+ (NSDictionary *)parseContent:(NSString *)string
{
    if (GJCFStringIsNull(string)) {
        return nil;
    }
    
    /* 表情 */
    NSMutableArray *emojiArray = [NSMutableArray array];
    [GJGCChatContentEmojiParser parseEmoji:[NSMutableString stringWithString:string] withEmojiTempString:nil withResultArray:emojiArray];
    
    /* 电话 */
    NSArray *phoneNumberArray = [self searchPhoneNumberFromString:string];
    
    /* 超链接 */
    NSArray *linkArray = [self searchUrlLinkFromString:string];
    
    NSDictionary *parseContentDict = [GJGCChatContentEmojiParser setupWithString:string withPhoneNumbers:phoneNumberArray withLinkArray:linkArray andEmojis:emojiArray];
    
    GJCFNSCacheSet(string, parseContentDict);
    
    return parseContentDict;
}


+ (NSString *)replaceNumberString:(NSInteger)numberStringLength
{
    if (numberStringLength == 0) {
        return @"";
    }
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < numberStringLength; i++) {
        [resultString appendString:@"x"];
    }
    return resultString;
}

/* 提取出字符串中的url链接  */
+ (NSArray *)searchUrlLinkFromString:(NSString *)sourceString
{
    if (GJCFStringIsNull(sourceString)) {
        return [NSArray array];
    }
    
    NSMutableString *mutableSourceString = [NSMutableString stringWithString:sourceString];

    /* 找到任意url */
    NSString *anyUrlRegex = @"(https?://|www)[^ \\u4E00-\\u9FA5\\uF900-\\uFA2D]*";
    
    NSError *AnyError = NULL;
    
    //任意url匹配
    NSRegularExpression *regexAnyLink = [NSRegularExpression regularExpressionWithPattern:anyUrlRegex options:NSRegularExpressionCaseInsensitive error:&AnyError];
    NSArray *regexAnyLinkArray = [regexAnyLink matchesInString:sourceString options:NSMatchingReportCompletion range:NSMakeRange(0, mutableSourceString.length)];
    
    NSMutableArray *keyStringArray = [NSMutableArray array];

    //记录每条链接信息
    for (NSTextCheckingResult *result in regexAnyLinkArray){
        
        NSString *resultString = [sourceString substringWithRange:result.range];
        [keyStringArray addObject:resultString];
    }
    
    return keyStringArray;
}

/* 提取出字符串中可能是电话号码的字符串组 */
+ (NSArray *)searchPhoneNumberFromString:(NSString *)sourceString
{
    if (GJCFStringIsNull(sourceString)) {
        return [NSArray array];
    }
    
    NSMutableString *mutableSourceString = [NSMutableString stringWithString:sourceString];
    
    /* 找到任意个数字 */
    NSString *anyNumberRegex = @"\\d{5,999}";
    
    NSError *AnyError = NULL;
    
    //任意位数字验证
    NSRegularExpression *regexAnyNumber = [NSRegularExpression regularExpressionWithPattern:anyNumberRegex options:NSRegularExpressionCaseInsensitive error:&AnyError];
    NSArray *regexAnyNumberArray = [regexAnyNumber matchesInString:sourceString options:NSMatchingReportCompletion range:NSMakeRange(0, mutableSourceString.length)];
    
    //将不符合位数的纯数字字符串替换成字符x
    for (NSTextCheckingResult *phoneNumberResult in regexAnyNumberArray) {
        
        NSString *phoneNumber = [mutableSourceString substringWithRange:phoneNumberResult.range];
        
        /* 小于7位的时候 */
        if (phoneNumber.length < 7) {
            
            /* 是否100开头打头的5位数字 */
            BOOL isFivePhoneNumber = [phoneNumber hasPrefix:@"100"] && (phoneNumber.length == 5);
            if (!isFivePhoneNumber) {
                [mutableSourceString replaceCharactersInRange:phoneNumberResult.range withString:[GJGCChatContentEmojiParser replaceNumberString:phoneNumber.length]];
            }
            continue;
        }
        
        /* 大于23位的时候 */
        if (phoneNumber.length > 23) {
            [mutableSourceString replaceCharactersInRange:phoneNumberResult.range withString:[GJGCChatContentEmojiParser replaceNumberString:phoneNumber.length]];
        }
    }
    
    /* 再来找合法的数字字符串 */
    NSString *sevenToTweentyThreeRegex = @"\\d{7,23}";
    
    //排除100开头的5位电话在一串合法数字中间的情况
    NSString *fiveNumberRegex = nil;
    if (mutableSourceString.length > 6) {
        fiveNumberRegex = @"\\D100\\d{2}";
    }else{
        fiveNumberRegex = @"100\\d{2}";
    }
    
    NSError *error = NULL;
    
    NSMutableArray *keyStringArray = [NSMutableArray array];
    
    //100开头的五位数字验证
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:fiveNumberRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *resultArray = [regex matchesInString:mutableSourceString options:NSMatchingReportCompletion range:NSMakeRange(0, mutableSourceString.length)];
    
    for (NSTextCheckingResult *result in resultArray) {
        
        NSString *resultString = [sourceString substringWithRange:result.range];
        //正则不知道怎么写，在这里处理，如果匹配了第一位是非数字，把第一位去掉
        if (!GJCFStringNumOnly(resultString)) {
            resultString = [resultString substringFromIndex:1];
        }
        [keyStringArray addObject:resultString];
    }
    
    //7-23位数字验证
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:sevenToTweentyThreeRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *resultArray1 = [regex1 matchesInString:mutableSourceString options:NSMatchingReportCompletion range:NSMakeRange(0, mutableSourceString.length)];
    
    for (NSTextCheckingResult *result in resultArray1) {
        
        NSString *resultString = [sourceString substringWithRange:result.range];
        [keyStringArray addObject:resultString];
    }
    
    return keyStringArray;
}

+ (NSDictionary *)setupWithString:(NSString *)string withPhoneNumbers:(NSArray *)phoneNumberArray withLinkArray:(NSArray *)linkArray andEmojis:(NSArray *)emojiArray
{
    NSArray *emojiNameArray = [NSArray  arrayWithContentsOfFile:GJCFMainBundlePath(@"emoji.plist")];
    NSMutableDictionary *emojiDict = [NSMutableDictionary dictionary];
    for (NSDictionary *item in emojiNameArray) {
        [emojiDict addEntriesFromDictionary:item];
    }
    
    NSMutableString *mString = [NSMutableString stringWithString:string];
    /* 将表情替换成空格 */
    for (NSDictionary *emojiItem in emojiArray) {
        
        NSString *emoji = [emojiItem objectForKey:@"emoji"];
    
        [mString replaceOccurrencesOfString:emoji withString:@"\uFFFC" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mString.length)];
    }
    
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle detailBigTitleColor];
    stringStyle.font = [UIFont systemFontOfSize:16];
    
    GJCFCoreTextParagraphStyle *paragrpahStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragrpahStyle.lineBreakMode = kCTLineBreakByCharWrapping;
    paragrpahStyle.maxLineSpace = 5.f;
    paragrpahStyle.minLineSpace = 5.f;
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc]initWithString:mString attributes:[stringStyle attributedDictionary]];
    [contentAttributedString addAttributes:[paragrpahStyle paragraphAttributedDictionary] range:NSMakeRange(0, contentAttributedString.string.length)];
    
    NSMutableArray *imageInfos = [NSMutableArray array];
    for (NSDictionary *emojiItem in emojiArray) {
        
        NSString *emoji = [emojiItem objectForKey:@"emoji"];
        NSRange   tempRange = [[emojiItem objectForKey:@"temp"] rangeValue];
        
        /* 插入图片 */
        GJCFCoreTextImageAttributedStringStyle *imageStyle = [[GJCFCoreTextImageAttributedStringStyle alloc]init];
        imageStyle.imageTag = @"imageTag";
        NSString *emojiIcon = [emojiDict objectForKey:emoji];
        imageStyle.imageName = [NSString stringWithFormat:@"%@.png",emojiIcon];
        imageStyle.imageSourceString = emoji;
        imageStyle.endGap = 2.f;
        
        /* 给表情创造一点间隔 */
        NSDictionary *imageInfo = @{kGJCFCoreTextImageInfoRangeKey:[NSValue valueWithRange:tempRange],kGJCFCoreTextImageInfoStringKey:emoji};
        [imageInfos addObject:imageInfo];

        /* 替换表情 */
        NSAttributedString *imageString = [imageStyle imageAttributedString];
        [contentAttributedString replaceCharactersInRange:tempRange withAttributedString:imageString];
    }
    
    /* 电话号码渲染 */
    for (NSString *phoneNumber in phoneNumberArray) {
        
        GJCFCoreTextKeywordAttributedStringStyle *keywordAttributedStyle = [[GJCFCoreTextKeywordAttributedStringStyle alloc]init];
        keywordAttributedStyle.keyword = phoneNumber;
        keywordAttributedStyle.preGap = 3.0;
        keywordAttributedStyle.endGap = 8.0;
        keywordAttributedStyle.innerGap = 1.f;
        keywordAttributedStyle.font = [UIFont systemFontOfSize:16];
        keywordAttributedStyle.keywordColor = [UIColor blueColor];
        [contentAttributedString setKeywordEffectByStyle:keywordAttributedStyle];
        
    }
    
    /* url超链接渲染  */
    for (NSString *link in linkArray) {
        
        GJCFCoreTextKeywordAttributedStringStyle *keywordAttributedStyle = [[GJCFCoreTextKeywordAttributedStringStyle alloc]init];
        keywordAttributedStyle.keyword = link;
        keywordAttributedStyle.preGap = 3.0;
        keywordAttributedStyle.endGap = 3.0;
        keywordAttributedStyle.font = [UIFont systemFontOfSize:16];
        keywordAttributedStyle.keywordColor = [UIColor blueColor];
        [contentAttributedString setKeywordEffectByStyle:keywordAttributedStyle];
        
    }
    
    BOOL needRenderCache = YES;
    if (phoneNumberArray.count > 0 || linkArray.count > 0) {
        needRenderCache = NO;
    }else{
        if (imageInfos.count > 7) {
            needRenderCache = YES;
        }
    }
    NSDictionary *resultDict = @{@"contentString":contentAttributedString,@"imageInfo":imageInfos,@"phone":phoneNumberArray,@"url":linkArray,@"needRenderCache":@(needRenderCache)};
    
    return resultDict;
}

/* 表情解析方法 */
+ (void)parseEmoji:(NSMutableString *)originString withEmojiTempString:(NSMutableString *)tempString withResultArray:(NSMutableArray *)resultArray
{
    if (!tempString) {
        tempString = [originString mutableCopy];
    }
    
    NSString *regex = @"\\[([\u4E00-\u9FA5OK]{1,3})\\]";
    
    NSRegularExpression *emojiRegexExp = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *originResult = [emojiRegexExp firstMatchInString:originString options:NSMatchingReportCompletion range:NSMakeRange(0, originString.length)];
    NSTextCheckingResult *tempResult = [emojiRegexExp firstMatchInString:tempString options:NSMatchingReportCompletion range:NSMakeRange(0, tempString.length)];
    
    if (!resultArray) {
        resultArray = [NSMutableArray array];
    }
    
    /* 所有合法表情处理 */
    NSDictionary *emojiNameDict = [NSDictionary dictionaryWithContentsOfFile:GJCFMainBundlePath(@"emojiName.plist")];
    
    while (originResult) {
        
        /* 表情名字 */
        NSString *emoji = [originString substringWithRange:originResult.range];
        
        if ([emoji isEqualToString:@"xxxx"] || [emoji isEqualToString:@"xxx"] || [emoji isEqualToString:@"xxxxx"]) {
            break;
        }
        
        /* 真实占位 */
        NSRange emojiRange = originResult.range;
        
        /* 替换真实占位的表情为空格，取得空格占位 */
        NSRange replaceRange = NSMakeRange(tempResult.range.location, 1);
        
        /* 替换占位，寻找下一个 */
        [tempString replaceCharactersInRange:tempResult.range withString:@" "];
        
        if (originResult.range.length == 3) {
            [originString replaceCharactersInRange:originResult.range withString:@"xxx"];
        }
        if (originResult.range.length == 4) {
            [originString replaceCharactersInRange:originResult.range withString:@"xxxx"];
        }
        if (originResult.range.length == 5) {
            [originString replaceCharactersInRange:originResult.range withString:@"xxxxx"];
        }
    
        /* 如果是合法表情 */
        if ([emojiNameDict objectForKey:emoji]) {
            
            NSDictionary *item = @{@"emoji":emoji,@"origin":[NSValue valueWithRange:emojiRange],@"temp":[NSValue valueWithRange:replaceRange]};
            
            [resultArray addObject:item];

        }
        
        [self parseEmoji:originString withEmojiTempString:tempString withResultArray:resultArray];

    }
}

@end
