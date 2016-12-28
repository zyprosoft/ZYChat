//
//  ZYThemeUitil.h
//  ZYChat
//
//  Created by ZYVincent on 16/12/18.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - ThemeIconName

#define kThemeRecentNavBar @"recent_nav"
#define kThemeRecentTabBar @"recent_tab"
#define kThemeRecentListBg @"recent_list"

#define kThemeSquareNavBar @"square_nav"
#define kThemeSquareTabBar @"square_tab"
#define kThemeSquareListBg @"square_list"

#define kThemeHomeNavBar @"home_nav"
#define kThemeHomeTabBar @"home_tab"
#define kThemeHomeListBg @"home_list"

#define kThemeChatLisgBg @"chat_list_bg"

#define ZYThemeImage(imgName) [ZYThemeUitil themeImage:imgName]

typedef NS_ENUM(NSUInteger, ZYResourceType) {
    ZYResourceTypeRecent,
    ZYResourceTypeSquare,
    ZYResourceTypeHome,
    ZYResourceTypeChat,
};

@interface ZYThemeUitil : NSObject

+ (void)setThemeFolder:(NSString *)folderName;
+ (UIImage *)themeImage:(NSString *)imageName;


@end
