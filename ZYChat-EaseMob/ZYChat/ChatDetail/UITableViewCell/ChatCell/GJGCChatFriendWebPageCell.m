//
//  GJGCChatFriendWebPageCell.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/24.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendWebPageCell.h"

@interface GJGCChatFriendWebPageCell ()

@property (nonatomic,strong)UIImageView *thumbImageView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *sumaryLabel;

@property (nonatomic,assign)CGFloat contentInnerMargin;

@end

@implementation GJGCChatFriendWebPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentInnerMargin = 11.f;
        
        self.thumbImageView = [[UIImageView alloc]init];
        self.thumbImageView.gjcf_size = (CGSize){55,55};
        [self.bubbleBackImageView addSubview:self.thumbImageView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.titleLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        [self.bubbleBackImageView addSubview:self.titleLabel];
        
        self.sumaryLabel = [[UILabel alloc]init];
        self.sumaryLabel.font = [GJGCCommonFontColorStyle baseAndTitleAssociateTextFont];
        self.sumaryLabel.textColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
        [self.bubbleBackImageView addSubview:self.sumaryLabel];
    }
    return self;
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    GJGCChatFriendContentModel *chatModel = (GJGCChatFriendContentModel *)contentModel;
    
    [super setContentModel:chatModel];
    
    CGFloat bubbleToBordMargin = 56;

    CGFloat maxTextContentWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 5.5 - 13 - 2*self.contentInnerMargin;

    self.titleLabel.gjcf_width = maxTextContentWidth;
    self.titleLabel.text = chatModel.webPageTitle;
    [self.titleLabel sizeToFit];
    
    
    self.thumbImageView.image = [UIImage imageWithData:chatModel.webPageThumbImageData];
    self.thumbImageView.gjcf_left = self.contentBordMargin;
    self.thumbImageView.gjcf_top = self.contentBordMargin;
    
    self.titleLabel.gjcf_left = self.thumbImageView.gjcf_right + self.contentBordMargin;
    self.titleLabel.gjcf_top = self.contentBordMargin;
    
    self.sumaryLabel.gjcf_width = self.titleLabel.gjcf_width;
    self.sumaryLabel.text = chatModel.webPageSumary;
    [self.sumaryLabel sizeToFit];
    self.sumaryLabel.gjcf_left = self.titleLabel.gjcf_left;
    self.sumaryLabel.gjcf_top = self.titleLabel.gjcf_bottom + 8.f;

    self.bubbleBackImageView.gjcf_height = self.thumbImageView.gjcf_bottom + self.contentBordMargin;
    self.bubbleBackImageView.gjcf_width = self.titleLabel.gjcf_right + self.contentInnerMargin;
    
    [self adjustContent];
}

#pragma mark - 长按事件继承

- (void)goToShowLongPressMenu:(UILongPressGestureRecognizer *)sender
{
    [super goToShowLongPressMenu:sender];
    
    UIMenuController *popMenu = [UIMenuController sharedMenuController];
    if (popMenu.isMenuVisible) {
        return;
    }
    
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    NSArray *menuItems = @[item2];
    [popMenu setMenuItems:menuItems];
    [popMenu setArrowDirection:UIMenuControllerArrowDown];
    
    [popMenu setTargetRect:self.bubbleBackImageView.frame inView:self];
    [popMenu setMenuVisible:YES animated:YES];
}

@end
