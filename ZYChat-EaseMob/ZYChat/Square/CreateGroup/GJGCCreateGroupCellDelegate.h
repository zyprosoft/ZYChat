//
//  BTUploadMemberCellDelegate.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <Foundation/Foundation.h>

@class GJGCCreateGroupBaseCell;
@protocol GJGCCreateGroupCellDelegate <NSObject>

- (void)inputTextCellDidTriggleMaxLengthInputLimit:(GJGCCreateGroupBaseCell *)inputTextCell maxLength:(NSInteger)maxLength;

- (void)inputTextCellDidBeginEdit:(GJGCCreateGroupBaseCell *)inputTextCell;

- (void)inputTextCell:(GJGCCreateGroupBaseCell *)inputTextCell didUpdateContent:(NSString *)content;

- (void)inputTextCellDidTapOnReturnButton:(GJGCCreateGroupBaseCell *)inputTextCell didUpdateContent:(NSString *)content;


@end
