//
//  GJGCCreateGroupContentModel.h
//  ZYChat
//
//  Created by ZYVincent on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCCreateGroupConst.h"

@interface GJGCCreateGroupContentModel : NSObject

@property (nonatomic,assign)GJGCCreateGroupContentType contentType;

@property (nonatomic,assign)GJGCCreateGroupCellSeprateLineStyle seprateStyle;

@property (nonatomic,strong)NSString *tagName;

@property (nonatomic,assign)BOOL isShowDetailIndicator;

@property (nonatomic,strong)NSString *content;

@property (nonatomic,assign)CGFloat contentHeight;

@property (nonatomic,assign)BOOL isMutilContent;

@property (nonatomic,assign)BOOL isPhoneNumberInputLimit;

@property (nonatomic,assign)BOOL isNumberInputLimit;

@property (nonatomic,assign)NSInteger maxInputLength;

@property (nonatomic,strong)NSString *placeHolder;

#pragma mark - 环信群组相关信息

@property (nonatomic,strong)NSNumber *groupStyle;

@end
