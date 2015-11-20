//
//  BTUploadMemberCellDelegate.h
//  ZYChat
//
//  Created by ZYVincent on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GJGCCreateGroupBaseCell;
@protocol GJGCCreateGroupCellDelegate <NSObject>

- (void)inputTextCellDidTriggleMaxLengthInputLimit:(GJGCCreateGroupBaseCell *)inputTextCell maxLength:(NSInteger)maxLength;

- (void)inputTextCellDidBeginEdit:(GJGCCreateGroupBaseCell *)inputTextCell;

- (void)inputTextCell:(GJGCCreateGroupBaseCell *)inputTextCell didUpdateContent:(NSString *)content;

- (void)inputTextCellDidTapOnReturnButton:(GJGCCreateGroupBaseCell *)inputTextCell didUpdateContent:(NSString *)content;


@end
