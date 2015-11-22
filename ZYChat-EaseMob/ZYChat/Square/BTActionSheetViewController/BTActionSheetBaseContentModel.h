//
//  BTActionSheetBaseContentModel.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTActionSheetConst.h"

@interface BTActionSheetBaseContentModel : NSObject

@property (nonatomic,assign)BTActionSheetContentType contentType;

@property (nonatomic,assign)CGFloat contentHeight;

@property (nonatomic,strong)NSString *simpleText;

@property (nonatomic,strong)NSString *detailText;

@property (nonatomic,strong)NSDictionary *userInfo;

@property (nonatomic,assign)BOOL isMutilSelect;

@property (nonatomic,assign)BOOL selected;

/**
 *  多选状态下禁用此交互，默认不禁用
 */
@property (nonatomic,assign)BOOL disableMutilSelectUserInteract;

- (BOOL)isEqual:(BTActionSheetBaseContentModel *)object;

@end
