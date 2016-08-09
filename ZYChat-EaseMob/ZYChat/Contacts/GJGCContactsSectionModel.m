//
//  GJGCContactsSectionModel.m
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCContactsSectionModel.h"

@implementation GJGCContactsSectionModel

- (NSString *)countString
{
    return [NSString stringWithFormat:@"%ld",_rowData.count];
}

- (NSInteger)showCount
{
    return _isExpand? _rowData.count:0;
}

- (BOOL)isExpand
{
    if (_rowData.count == 0) {
        return NO;
    }
    return _isExpand;
}

@end
