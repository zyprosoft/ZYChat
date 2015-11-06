//
//  GJAssetsPickerStyle.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-8.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import "GJCFAssetsPickerStyle.h"


@implementation GJCFAssetsPickerStyle

#pragma mark - 系统用到的一些配置
+ (UIColor *)sysButtonTitleNormalColor
{
    return [UIColor colorWithRed:81/255.0 green:189/255.0 blue:3/255.0 alpha:1.0];
}
+ (UIColor *)sysButtonTitleHighlightColor
{
    return [UIColor colorWithRed:81/255.0 green:189/255.0 blue:3/255.0 alpha:1.0];
}

+ (UIFont *)sysButtonFont
{
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)sysNavigationTitleFont
{
    return [UIFont boldSystemFontOfSize:16];
}

+ (UIImage *)sysNavigationBarBack
{
    return [[GJCFAssetsPickerStyle bundleImage:@"GjAssetsPicker_Navigation_bar_back.png"]stretchableImageWithLeftCapWidth:1 topCapHeight:1];
}

+ (GJCFAssetsPickerStyle*)defaultStyle
{
    GJCFAssetsPickerStyle *defaultStyle = [[GJCFAssetsPickerStyle alloc]init];
    
    return defaultStyle;
}

+ (UIImage *)bundleImage:(NSString*)imageName
{
    NSString *bunldPath = [[NSBundle mainBundle]pathForResource:@"GJCFAssetsPickerResourceBundle" ofType:@"bundle"];
    NSString *imagePath = [bunldPath stringByAppendingPathComponent:imageName];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}

#pragma mark - 可以重写自定义属性的getter方法

- (NSInteger)numberOfColums
{
    return 4;
}

- (CGFloat)columSpace
{
    return 3.f;
}

- (BOOL)enableBigImageShowAction
{
    return YES;
}

- (BOOL)enableAutoChooseInDetail
{
    return YES;
}

- (GJCFAssetsPickerCommonStyleDescription*)sysAlbumsNavigationBarDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.title = @"选择相册";
    aStyleDes.backgroundImage = [GJCFAssetsPickerStyle sysNavigationBarBack];
    aStyleDes.font = [GJCFAssetsPickerStyle sysNavigationTitleFont];
    aStyleDes.titleColor = [UIColor whiteColor];
    aStyleDes.frameSize = CGSizeMake(80, 20);

    return aStyleDes;
}

- (GJCFAssetsPickerCommonStyleDescription*)sysPhotoNavigationBarDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.title = @"选择照片";
    aStyleDes.backgroundImage = [GJCFAssetsPickerStyle sysNavigationBarBack];
    aStyleDes.font = [GJCFAssetsPickerStyle sysNavigationTitleFont];
    aStyleDes.titleColor = [UIColor whiteColor];
    aStyleDes.frameSize = CGSizeMake(80, 20);
    
    return aStyleDes;
}

- (GJCFAssetsPickerCommonStyleDescription*)sysPreviewNavigationBarDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.backgroundImage = [GJCFAssetsPickerStyle sysNavigationBarBack];
    aStyleDes.font = [GJCFAssetsPickerStyle sysNavigationTitleFont];
    aStyleDes.titleColor = [UIColor whiteColor];
    
    return aStyleDes;
}

- (GJCFAssetsPickerCommonStyleDescription*)sysCancelBtnDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.normalStateTitle = @"取消";
    aStyleDes.font = [GJCFAssetsPickerStyle sysNavigationTitleFont];
    aStyleDes.normalStateTextColor = [UIColor whiteColor];
    
    return aStyleDes;

}

- (GJCFAssetsPickerCommonStyleDescription*)sysBackBtnDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.font = [GJCFAssetsPickerStyle sysNavigationTitleFont];
    aStyleDes.normalStateTextColor = [UIColor whiteColor];
    aStyleDes.frameSize = CGSizeMake(80, 20);
    
    return aStyleDes;
}

- (GJCFAssetsPickerCommonStyleDescription*)sysFinishDoneBtDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.normalStateTitle = @"发送";
    aStyleDes.highlightStateTextColor = [GJCFAssetsPickerStyle sysButtonTitleHighlightColor];
    aStyleDes.normalStateTextColor = [GJCFAssetsPickerStyle sysButtonTitleNormalColor];
    aStyleDes.font = [GJCFAssetsPickerStyle sysButtonFont];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    aStyleDes.originPoint = CGPointMake(screenWidth-2.5-82.5, 12);
    aStyleDes.frameSize = CGSizeMake(100, 22);

    return aStyleDes;
}

- (GJCFAssetsPickerCommonStyleDescription*)sysPreviewBtnDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.normalStateTitle = @"预览";
    aStyleDes.highlightStateTextColor = [GJCFAssetsPickerStyle sysButtonTitleHighlightColor];
    aStyleDes.normalStateTextColor = [GJCFAssetsPickerStyle sysButtonTitleNormalColor];
    aStyleDes.font = [GJCFAssetsPickerStyle sysButtonFont];
    aStyleDes.originPoint = CGPointMake(2.5, 12);
    aStyleDes.frameSize = CGSizeMake(50,22);
    
    return aStyleDes;
}

- (GJCFAssetsPickerCommonStyleDescription*)sysPreviewChangeSelectStateBtnDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.selectedStateImage = [GJCFAssetsPickerStyle bundleImage:@"GjAssetsPicker_image_selected.png"];
    aStyleDes.normalStateImage = [GJCFAssetsPickerStyle bundleImage:@"GjAssetsPicker_image_preview_unselect.png"];
    aStyleDes.originPoint = CGPointMake(30, 5);
    
    return aStyleDes;
}

- (GJCFAssetsPickerCommonStyleDescription*)sysPreviewBottomToolBarDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.frameSize = (CGSize){[UIScreen mainScreen].bounds.size.width,44};
    aStyleDes.backgroundColor = [UIColor whiteColor];
    
    return aStyleDes;
}

- (GJCFAssetsPickerCommonStyleDescription*)sysPhotoBottomToolBarDes
{
    GJCFAssetsPickerCommonStyleDescription *aStyleDes = [[GJCFAssetsPickerCommonStyleDescription alloc]init];
    aStyleDes.frameSize = (CGSize){[UIScreen mainScreen].bounds.size.width,44};
    aStyleDes.backgroundColor = [UIColor whiteColor];
    
    return aStyleDes;
}

- (Class)sysOverlayViewClass
{
    return [GJCFAssetsPickerOverlayView class];
}

/* 处理添加自定义风格 */
+ (NSMutableDictionary *)persistStyleDict
{
    NSData *stylesData = [[NSUserDefaults standardUserDefaults]objectForKey:kGJAssetsPickerStylePersistUDF];
    if (!stylesData) {

        return nil;
    }
    NSMutableDictionary *styleDict = [NSKeyedUnarchiver unarchiveObjectWithData:stylesData];
    
    return styleDict;
}

+ (void)savePersistDict:(NSMutableDictionary*)styleDict
{
    if (!styleDict) {
        return;
    }
    
    NSData *stylesData = [NSKeyedArchiver archivedDataWithRootObject:styleDict];
    [[NSUserDefaults standardUserDefaults]setObject:stylesData forKey:kGJAssetsPickerStylePersistUDF];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)appendCustomStyle:(GJCFAssetsPickerStyle*)aCustomStyle forKey:(NSString *)customStyleKey
{
    if (!customStyleKey || !aCustomStyle || ![aCustomStyle isKindOfClass:[GJCFAssetsPickerStyle class]]) {
        return;
    }
    
    NSMutableDictionary *styles = [GJCFAssetsPickerStyle persistStyleDict];
    if (!styles) {
        styles = [NSMutableDictionary dictionary];
    }
    
    [styles setObject:aCustomStyle forKey:customStyleKey];
    
    [GJCFAssetsPickerStyle savePersistDict:styles];
}


+ (GJCFAssetsPickerStyle*)styleByKey:(NSString *)customStyleKey
{
    if (!customStyleKey) {
        return nil;
    }
    
    NSMutableDictionary *styles = [GJCFAssetsPickerStyle persistStyleDict];
    
    
    return [styles objectForKey:customStyleKey];
}

+ (void)removeCustomStyleByKey:(NSString *)customStyleKey
{
    if (!customStyleKey) {
        return;
    }
    
    NSMutableDictionary *styles = [GJCFAssetsPickerStyle persistStyleDict];

    [styles removeObjectForKey:customStyleKey];
    
    [GJCFAssetsPickerStyle savePersistDict:styles];
}

+ (NSArray *)existCustomStyleKeys
{
    NSMutableDictionary *styles = [GJCFAssetsPickerStyle persistStyleDict];
    
    return [styles allKeys];
}

+ (void)clearAllCustomStyles
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kGJAssetsPickerStylePersistUDF];
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

@end
