//
//  RCRichContentMessageCell.h
//  RongIMKit
//
//  Created by xugang on 15/2/2.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCMessageCell.h"

@class RCAttributedLabel;

#define RichContent_Title_Font_Size 16
#define RichContent_Message_Font_Size 12
#define RICH_CONTENT_THUMBNAIL_WIDTH 60
#define RICH_CONTENT_THUMBNAIL_HIGHT 60
/**
 *  富文本消息Cell
 */
@interface RCRichContentMessageCell : RCMessageCell

/**
 *  消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 * 富文本图片
 */
@property(nonatomic, strong) RCloudImageView *richContentImageView;

/**
 *  富文本内容
 */
@property(nonatomic, strong) RCAttributedLabel *digestLabel;

/**
 *  富文本标题
 */
@property(nonatomic, strong) RCAttributedLabel *titleLabel;

@end
