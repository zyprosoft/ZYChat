//
//  GJGCChatOtherApplyMyAuthorizWithStateCell.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatOtherApplyMyAuthorizWithStateCell.h"

@implementation GJGCChatOtherApplyMyAuthorizWithStateCell

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    [super setContentModel:contentModel];
        
    /* 隐藏同意，拒绝，附加信息按钮 */
    self.applyButton.hidden = YES;
    self.rejectButton.hidden = YES;
    self.sepreteLine.hidden = YES;
    
    /* 重新计算内容高度 */
    self.stateContentView.gjcf_height = self.applyAuthorizReasonLabel.gjcf_bottom + self.contentBordMargin;
    
}

@end
