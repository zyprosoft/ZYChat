//
//  GJGCChatFirendBaseCell.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendBaseCell.h"

@interface GJGCChatFriendBaseCell ()<UIAlertViewDelegate>

@end

@implementation GJGCChatFriendBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cellMargin = 20.f;
        self.contentBordMargin = 13.f;
                
        self.timeLabel = [[GJCFCoreTextContentView alloc]init];
        self.timeLabel.gjcf_centerX = GJCFSystemScreenWidth/2;
        self.timeLabel.gjcf_top = 15.f;
        self.timeLabel.gjcf_width = GJCFSystemScreenWidth;
        self.timeLabel.gjcf_height = 40.f;
        self.timeLabel.contentBaseWidth = self.timeLabel.gjcf_width;
        self.timeLabel.contentBaseHeight = self.timeLabel.gjcf_height;
        self.timeLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:self.timeLabel];
        
        self.headView = [[GJGCCommonHeadView alloc]init];
        self.headView.gjcf_width = 40;
        self.headView.gjcf_height = 40;
        
        /* 点击头像 */
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnHeadView:)];
        [self.headView addGestureRecognizer:tapR];
        
        /* 长按头像事件 */
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnHeadView:)];
        longTap.numberOfTouchesRequired = 1;
        longTap.minimumPressDuration = 0.5;
        [self.headView addGestureRecognizer:longTap];
        
        [self.contentView addSubview:self.headView];
        
        self.nameLabel = [[GJCFCoreTextContentView alloc]init];
        self.nameLabel.gjcf_top = 0.f;
        self.nameLabel.gjcf_width = GJCFSystemScreenWidth - self.headView.gjcf_width - 3*self.contentBordMargin;
        self.nameLabel.gjcf_height = 20.f;
        self.nameLabel.contentBaseWidth = self.timeLabel.gjcf_width;
        self.nameLabel.contentBaseHeight = self.timeLabel.gjcf_height;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.hidden = YES;
        [self.contentView addSubview:self.nameLabel];
        
        self.sexIconView = [[UIImageView alloc]init];
        self.sexIconView.frame = (CGRect){0,0,15,15};
        self.sexIconView.hidden = YES;
        [self.contentView addSubview:self.sexIconView];
        
        self.bubbleBackImageView = [[UIImageView alloc]init];
        self.bubbleBackImageView.gjcf_left = self.contentBordMargin;
        self.bubbleBackImageView.gjcf_width = 5;
        self.bubbleBackImageView.gjcf_height = 40;
        self.bubbleBackImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bubbleBackImageView];
        
        self.statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.statusButton.gjcf_width = 13.5;
        self.statusButton.gjcf_height = 13.5;
        self.statusButton.userInteractionEnabled = NO;
        [self.statusButton addTarget:self action:@selector(reSendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.statusButton];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(goToShowLongPressMenu:)];
        longPress.minimumPressDuration = 0.25;
        [self.bubbleBackImageView addGestureRecognizer:longPress];

        [GJCFNotificationCenter addObserver:self selector:@selector(popMenuDidHidden:) name:UIMenuControllerWillHideMenuNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [GJCFNotificationCenter removeObserver:self];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self.bubbleBackImageView setHighlighted:highlighted];
}

- (UIImage *)bubbleImageByRole:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    if (self.isFromSelf) {
        return GJCFImageResize(image, 23.5, 6, 6, 11);
    }else{
        return GJCFImageResize(image, 23.5, 6, 11, 6);
    }
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    GJGCChatFriendContentModel *chatContentModel = (GJGCChatFriendContentModel *)contentModel;
    self.isFromSelf = chatContentModel.isFromSelf;
    self.sendStatus = chatContentModel.sendStatus;
    self.isGroupChat = chatContentModel.isGroupChat;
    self.faildType = chatContentModel.faildType;
    self.faildReason = chatContentModel.faildReason;
    self.talkType = chatContentModel.talkType;
    self.contentType = chatContentModel.contentType;
    
    [self.headView setHeadUrl:chatContentModel.headUrl];
    
    if (self.isGroupChat && !self.isFromSelf) {
        self.nameLabel.hidden = NO;
        self.nameLabel.contentAttributedString = chatContentModel.senderName;
        self.nameLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:chatContentModel.senderName forBaseContentSize:self.nameLabel.contentBaseSize];
    }else{
        self.nameLabel.hidden = YES;
    }
}

- (void)adjustContent
{
    if (self.isFromSelf) {
        
        self.bubbleBackImageView.image = [self bubbleImageByRole:@"聊天对话框-BG-绿色.png"];
        self.bubbleBackImageView.highlightedImage = [self bubbleImageByRole:@"聊天对话框-BG-绿色-点击.png"];
        
        /* 头像矫正 */
        self.headView.gjcf_right = GJCFSystemScreenWidth - self.contentBordMargin;
        self.bubbleBackImageView.gjcf_height = self.bubbleBackImageView.image.size.height > self.bubbleBackImageView.gjcf_height? self.bubbleBackImageView.image.size.height:self.bubbleBackImageView.gjcf_height;
        self.bubbleBackImageView.gjcf_right = self.headView.gjcf_left - 3;
        
    }else{
        
        self.bubbleBackImageView.image = [self bubbleImageByRole:@"聊天对话框-BG-白色.png"];
        self.bubbleBackImageView.highlightedImage = [self bubbleImageByRole:@"聊天对话框-BG-白色-点击.png"];
        
        /* 头像矫正 */
        self.headView.gjcf_left = self.contentBordMargin;
        self.bubbleBackImageView.gjcf_height = self.bubbleBackImageView.image.size.height > self.bubbleBackImageView.gjcf_height? self.bubbleBackImageView.image.size.height:self.bubbleBackImageView.gjcf_height;
        self.bubbleBackImageView.gjcf_left = self.headView.gjcf_right + 3;
        
    }
    
    if (self.isGroupChat && !self.isFromSelf) {
        
        self.nameLabel.gjcf_top = 0.f;
        self.nameLabel.gjcf_left = self.headView.gjcf_right + self.contentBordMargin;
        self.headView.gjcf_top = 0.f;
        self.bubbleBackImageView.gjcf_top = self.nameLabel.gjcf_bottom + 3;
        
    }else{
        
        self.headView.gjcf_top = 0.f;
        self.bubbleBackImageView.gjcf_top = self.headView.gjcf_top;
        
    }
    
    self.statusButton.hidden = NO;
    self.statusButton.gjcf_top = self.bubbleBackImageView.gjcf_top;
    self.statusButton.userInteractionEnabled = NO;
    
    switch (self.sendStatus) {
        case GJGCChatFriendSendMessageStatusSuccess:
        {
            [self successSendingAnimation];
        }
            break;
        case GJGCChatFriendSendMessageStatusSending:
        {
            [self startSendingAnimation];
        }
            break;
        case GJGCChatFriendSendMessageStatusFaild:
        {
            [self faildSendingAnimation];
        }
            break;
        default:
            break;
    }
    if (!self.isFromSelf) {
        self.statusButton.hidden = YES;
    }
}

- (CGFloat)heightForContentModel:(GJGCChatContentBaseModel *)contentModel
{
    return self.bubbleBackImageView.gjcf_bottom + self.cellMargin;
}

- (NSArray *)myAudioPlayIndicatorImages
{
    return @[
             GJCFQuickImage(@"聊天-icon-语音1-绿.png"),
             GJCFQuickImage(@"聊天-icon-语音2-绿.png"),
             GJCFQuickImage(@"聊天-icon-语音-绿.png"),
             ];
}

- (NSArray *)otherAudioPlayIndicatorImages
{
    return @[
             GJCFQuickImage(@"聊天-icon-语音及切换键盘1-灰.png"),
             GJCFQuickImage(@"聊天-icon-语音及切换键盘2-灰.png"),
             GJCFQuickImage(@"聊天-icon-语音及切换键盘-灰.png"),
             
             ];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyContent:) || action == @selector(deleteMessage:) || action == @selector(reSendMessage)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

- (void)goToShowLongPressMenu:(UILongPressGestureRecognizer *)sender
{
    [self becomeFirstResponder];
    [self.bubbleBackImageView setHighlighted:YES];
    
}

- (void)copyContent:(UIMenuItem *)item
{
    
}

- (void)popMenuDidHidden:(NSNotification *)noti
{
    if (self.bubbleBackImageView.isHighlighted) {
        
        [self.bubbleBackImageView setHighlighted:NO];

    }
}


- (void)deleteMessage:(UIMenuItem *)item
{
    /* 删除消息会导致正在发送消息的请求结果返回时候更新不了本地库 */
    if (self.sendStatus == GJGCChatFriendSendMessageStatusSending) {
        
        [self.bubbleBackImageView setHighlighted:NO];
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidChooseDeleteMessage:)]) {
        [self.delegate chatCellDidChooseDeleteMessage:self];
    }
    [self.bubbleBackImageView setHighlighted:NO];
}

- (void)reSendMessage
{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重发该消息？" delegate:self cancelButtonTitle:@"重发" otherButtonTitles:@"取消", nil];
    [al show];
}

- (void)setSendStatus:(GJGCChatFriendSendMessageStatus)sendStatus
{
    _sendStatus = sendStatus;
    
    switch (sendStatus) {
        case GJGCChatFriendSendMessageStatusSuccess:
        {
            [self successSendingAnimation];
        }
            break;
        case GJGCChatFriendSendMessageStatusSending:
        {
            [self startSendingAnimation];
        }
            break;
        case GJGCChatFriendSendMessageStatusFaild:
        {
            [self faildSendingAnimation];
        }
            break;
        default:
            break;
    }
}

- (void)startSendingAnimation
{
    self.statusButton.gjcf_right = self.bubbleBackImageView.gjcf_left - 5 - self.statusButtonOffsetAudioDuration - 5;
    [self.statusButton setImage:GJCFQuickImage(@"聊天-icon-发送中.png") forState:UIControlStateNormal];
    self.statusButton.gjcf_width = 13.5;
    self.statusButton.gjcf_height = self.statusButton.gjcf_width;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1000;
    
    [self.statusButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)successSendingAnimation
{
    self.statusButton.hidden = YES;
    [self.statusButton.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)faildSendingAnimation
{
    [self.statusButton.layer removeAnimationForKey:@"rotationAnimation"];
    self.statusButton.gjcf_right = self.bubbleBackImageView.gjcf_left - 10 - self.statusButtonOffsetAudioDuration - 5;
    [self.statusButton setImage:GJCFQuickImage(@"聊天-icon-发送失败.png") forState:UIControlStateNormal];
    self.statusButton.gjcf_width = 20.f;
    self.statusButton.gjcf_height = 20.f;
    self.statusButton.gjcf_top = self.bubbleBackImageView.gjcf_top;
    self.statusButton.userInteractionEnabled = YES;
}

- (void)faildWithType:(NSInteger)faildType andReason:(NSString *)reason
{
    self.faildType = faildType;
    self.faildReason = reason;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"重发"]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidChooseReSendMessage:)]) {
            
            [self startSendingAnimation];
            
            [self.delegate chatCellDidChooseReSendMessage:self];
                        
        }
    }
}

- (void)tapOnHeadView:(UITapGestureRecognizer *)tapR
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidTapOnHeadView:)]) {
        [self.delegate chatCellDidTapOnHeadView:self];
    }
}

- (void)longPressOnHeadView:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        
        /* 不可以@自己 */
        if (!self.isFromSelf) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidLongPressOnHeadView:)]) {
                [self.delegate chatCellDidLongPressOnHeadView:self];
            }
        }
    }
}



@end
