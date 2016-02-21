//
//  GJGCInformationCellStyle.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationCellStyle.h"

@implementation GJGCInformationCellStyle

/* 相册里面得标签 */
+ (NSAttributedString *)formatePersonPhotoBoxName:(NSString *)name
{
    if (GJCFStringIsNull(name)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:name attributes:[stringStyle attributedDictionary]];
    
    return attributedString;
}

+ (NSAttributedString *)formatePersonPhotoBoxDistanceOrTime:(NSString *)distanceOrTime
{
    if (GJCFStringIsNull(distanceOrTime)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    
    NSAttributedString *attriubtedString = [[NSAttributedString alloc]initWithString:distanceOrTime attributes:[stringStyle attributedDictionary]];
    
    return attriubtedString;
}

+ (NSAttributedString *)formatePersonPhotoBoxWomenAge:(NSString *)age
{
    if (GJCFStringIsNull(age)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle womenAgeColor];
    stringStyle.font = [UIFont systemFontOfSize:12];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:age attributes:[stringStyle attributedDictionary]];
    
    return attributedString;
}

+ (NSAttributedString *)formatePersonPhotoBoxManAge:(NSString *)age
{
    if (GJCFStringIsNull(age)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle manAgeColor];
    stringStyle.font = [UIFont systemFontOfSize:12];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:age attributes:[stringStyle attributedDictionary]];
    
    return attributedString;
}

+ (NSAttributedString *)formatePersonPhotoBoxStarNameOrHelloCount:(NSString *)starNameOrHelloCount
{
    if (GJCFStringIsNull(starNameOrHelloCount)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:starNameOrHelloCount attributes:[stringStyle attributedDictionary]];
    
    return attributedString;
}

+ (NSAttributedString *)formateGroupPhotoBoxName:(NSString *)name
{
    if (GJCFStringIsNull(name)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle detailBigTitleColor];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:name attributes:[stringStyle attributedDictionary]];
    
    return attributedString;
}

+ (NSAttributedString *)formateGroupPhotoBoxDistance:(NSString *)distance
{
    if (GJCFStringIsNull(distance)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:distance attributes:[stringStyle attributedDictionary]];
    
    return attributedString;
}

/* 基础 text cell */

+ (NSAttributedString *)formateBaseTextTag:(NSString *)tag
{
    if (GJCFStringIsNull(tag)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:tag attributes:[stringStyle attributedDictionary]];
    
    return attributedString;
}

+ (NSAttributedString *)formateBaseTextContent:(NSString *)content
{
    if (GJCFStringIsNull(content)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    if ([content isEqualToString:@"待完善"]) {
        stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    }else{
        stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
    }
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:content attributes:[stringStyle attributedDictionary]];
    
    return attributedString;
}

+ (NSAttributedString *)formateSummaryText:(NSString *)summary
{
    if (GJCFStringIsNull(summary)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    if ([summary isEqualToString:@"待完善"]) {
        stringStyle.foregroundColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    }else{
        stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
    }
    
    /* 段落换行 */
    GJCFCoreTextParagraphStyle *pargraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    pargraphStyle.maxLineSpace = 8.f;
    pargraphStyle.minLineSpace = 8.f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:summary attributes:[stringStyle attributedDictionary]];
    [attributedString addAttributes:[pargraphStyle paragraphAttributedDictionary] range:NSMakeRange(0, summary.length)];
    
    return attributedString;

}

+ (NSAttributedString *)formateFeedContent:(NSString *)content
{
    if (GJCFStringIsNull(content)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
    
    /* 段落换行 */
    GJCFCoreTextParagraphStyle *pargraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    pargraphStyle.maxLineSpace = 6.f;
    pargraphStyle.minLineSpace = 6.f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:content attributes:[stringStyle attributedDictionary]];
    [attributedString addAttributes:[pargraphStyle paragraphAttributedDictionary] range:NSMakeRange(0, content.length)];
    
    return attributedString;
}

+ (NSAttributedString *)formateNameTrailMode:(NSString *)name
{
    if (GJCFStringIsNull(name)) {
        return nil;
    }
    
    /* 风格描述 */
    GJCFCoreTextAttributedStringStyle *stringStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    stringStyle.foregroundColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
    stringStyle.font = [GJGCCommonFontColorStyle detailBigTitleFont];
    
    /* 段落换行 */
    GJCFCoreTextParagraphStyle *pargraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    pargraphStyle.lineBreakMode = kCTLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:name attributes:[stringStyle attributedDictionary]];
    [attributedString addAttributes:[pargraphStyle paragraphAttributedDictionary] range:NSMakeRange(0, name.length)];
    
    return attributedString;

}

@end
