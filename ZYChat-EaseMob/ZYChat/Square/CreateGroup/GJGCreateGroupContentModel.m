//
//  BTUploadMemberContentModel.m
//  ZYChat
//
//  Created by ZYVincent on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCCreateGroupContentModel.h"

@implementation GJGCCreateGroupContentModel

- (instancetype)init
{
    if (self = [super init]) {
        
        self.isMutilContent = NO;
        self.maxInputLength = 0;
        self.seprateStyle = GJGCCreateGroupCellSeprateLineStyleTopNoneBottomShow;
        self.isShowDetailIndicator = NO;
    }
    return self;
}

- (CGFloat)contentHeight
{
    return _contentHeight > 48.f? _contentHeight:48.f;
}

@end
