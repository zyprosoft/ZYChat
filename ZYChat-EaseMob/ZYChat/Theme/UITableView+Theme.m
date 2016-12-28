//
//  UITableView+Theme.m
//  ZYChat
//
//  Created by ZYVincent on 16/12/18.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "UITableView+Theme.h"

@implementation UITableView (Theme)
- (void)setResourceType:(ZYResourceType)type
{
    NSString *imgName = nil;
    switch (type) {
        case ZYResourceTypeRecent:
            imgName = kThemeRecentListBg;
            break;
        case ZYResourceTypeSquare:
            imgName = kThemeSquareListBg;
            break;
        case ZYResourceTypeHome:
            imgName = kThemeHomeListBg;
            break;
        case ZYResourceTypeChat:
            imgName = kThemeChatLisgBg;
            break;
        default:
            break;
    }
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    backImageView.image = ZYThemeImage(imgName);
    UIImageView *maskView = [[UIImageView alloc]initWithFrame:backImageView.bounds];
    maskView.backgroundColor = [UIColor colorWithRed:97/255.f green:60/255.f blue:140/255.f alpha:0.6];
    [backImageView addSubview:maskView];
    self.backgroundView = backImageView;
}
@end
