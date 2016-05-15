//
//  GJGCChatFriendSendFlowerCell.m
//  ZYChat
//
//  Created by ZYVincent on 16/5/15.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendSendFlowerCell.h"

@interface GJGCChatFriendSendFlowerCell ()

@property (nonatomic,strong)UIImageView *thumbImageView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,assign)CGFloat contentInnerMargin;

@end

@implementation GJGCChatFriendSendFlowerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentInnerMargin = 11.f;
        
        self.thumbImageView = [[UIImageView alloc]init];
        self.thumbImageView.gjcf_size = (CGSize){55,55};
        self.thumbImageView.userInteractionEnabled = YES;
        [self.bubbleBackImageView addSubview:self.thumbImageView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.titleLabel.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        [self.bubbleBackImageView addSubview:self.titleLabel];
        
    }
    return self;
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    GJGCChatFriendContentModel *chatModel = (GJGCChatFriendContentModel *)contentModel;
    
    [super setContentModel:chatModel];
    
    CGFloat bubbleToBordMargin = 56;
    
    CGFloat maxTextContentWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 5.5 - 13 - 2*self.contentInnerMargin+5;
    
    self.titleLabel.gjcf_width = maxTextContentWidth - 2*self.contentInnerMargin - self.thumbImageView.gjcf_width;
    self.titleLabel.text = chatModel.flowerTitle;
    self.titleLabel.gjcf_height = 13.f;
    
    
    //是否正在播放音乐
    UIImage *iconImage = [UIImage imageNamed:@"flower"];
    self.thumbImageView.image = iconImage;
    self.thumbImageView.gjcf_left = self.contentBordMargin;
    self.thumbImageView.gjcf_top = self.contentBordMargin;
    
    self.titleLabel.gjcf_left = self.thumbImageView.gjcf_right + self.contentBordMargin-5;
    self.titleLabel.gjcf_top = self.thumbImageView.gjcf_top + 7.f;
    
    self.bubbleBackImageView.gjcf_height = self.thumbImageView.gjcf_bottom + self.contentBordMargin;
    self.bubbleBackImageView.gjcf_width = self.titleLabel.gjcf_right + self.contentInnerMargin;
 
    [self adjustContent];
    
    if (self.isFromSelf) {
        self.titleLabel.textColor = [UIColor whiteColor];
    }else{
        self.titleLabel.textColor = [GJGCCommonFontColorStyle baseAndTitleAssociateTextColor];
    }    
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

- (void)tapOnSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidTapOnWebPage:)]) {
        
        [self.delegate chatCellDidTapOnWebPage:self];
    }
}

@end
