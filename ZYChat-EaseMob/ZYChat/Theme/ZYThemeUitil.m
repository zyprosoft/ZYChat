//
//  ZYThemeUitil.m
//  ZYChat
//
//  Created by ZYVincent on 16/12/18.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "ZYThemeUitil.h"

static NSString *_themeFolderName = @"default";

@implementation ZYThemeUitil

+ (void)setThemeFolder:(NSString *)folderName
{
    if (folderName.length == 0) {
        return;
    }
    _themeFolderName = folderName;
}
+ (UIImage *)themeImage:(NSString *)imageName
{
    NSString *themePath = [[GJCFMainBundle bundlePath]stringByAppendingPathComponent:_themeFolderName];
    NSString *imgName = nil;
    if ([GJCFSystemUitil screenBounds].size.height > 667) {
        imgName = [NSString stringWithFormat:@"%@@2x",imageName];
    }else{
        imgName = [NSString stringWithFormat:@"%@@2x",imageName];
    }
    NSString  *imgPath = [[themePath stringByAppendingPathComponent:imgName] stringByAppendingPathExtension:@"png"];

    UIImage *theImage = [UIImage imageWithContentsOfFile:imgPath];
    return  theImage;
}

@end
