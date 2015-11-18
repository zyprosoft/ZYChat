//
//  GJGCChatFriendTextMessageCell.m
//  ZYChat
//
//  Created by ZYVincent on 14-11-5.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendTextMessageCell.h"
#import "GJGCChatFriendCellStyle.h"
#import "GJGCChatContentEmojiParser.h"

@interface GJGCChatFriendTextMessageCell ()

@property (nonatomic,copy)NSString *contentCopyString;

@property (nonatomic,strong)UIImageView *textRenderCacheImageView;

@end

@implementation GJGCChatFriendTextMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentInnerMargin = 11.f;
        CGFloat bubbleToBordMargin = 56;
        CGFloat maxTextContentWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 5.5 - 13 - 2*self.contentInnerMargin;
        
        self.contentLabel = [[GJCFCoreTextContentView alloc]init];
        [self.contentLabel appendImageTag:[GJGCChatFriendCellStyle imageTag]];
        self.contentLabel.gjcf_left = self.contentInnerMargin;
        self.contentLabel.gjcf_width = maxTextContentWidth;
        self.contentLabel.gjcf_height = 23;
        self.contentLabel.gjcf_top = self.contentInnerMargin;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.contentBaseWidth = self.contentLabel.gjcf_width;
        self.contentLabel.contentBaseHeight = self.contentLabel.gjcf_height;
        self.contentLabel.userInteractionEnabled = YES;
        [self.bubbleBackImageView addSubview:self.contentLabel];
        
        self.textRenderCacheImageView = [[UIImageView alloc]initWithFrame:self.contentLabel.frame];
        [self.bubbleBackImageView addSubview:self.textRenderCacheImageView];
        self.textRenderCacheImageView.hidden = YES;
    }
    return self;
}

#pragma mark - 点击电话响应

- (void)setupTouchEnventWithPhoneNumberArray:(NSArray *)phoneNumberArray
{
    if (!phoneNumberArray) {
        return;
    }
    
    //点击事件处理
    if (phoneNumberArray.count > 0) {
        
        for (NSString *phoneNumber in phoneNumberArray) {
            
            __weak typeof(self)weakSelf = self;
            
            //点击事件响应
            [self.contentLabel appenTouchObserverForKeyword:phoneNumber withHanlder:^(NSString *keyword, NSRange keywordRange) {
                [weakSelf tapOnPhoneNumber:keyword withRange:keywordRange];
            }];
            
        }
        
    }
}


//响应点击事件
- (void)tapOnPhoneNumber:(NSString *)phoneNumber withRange:(NSRange)phoneNumberRange
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textMessageCellDidTapOnPhoneNumber:withPhoneNumber:)]) {
        [self.delegate textMessageCellDidTapOnPhoneNumber:self withPhoneNumber:phoneNumber];
    }
}

#pragma mark - 点击超链接响应

- (void)setupTouchEventWithUrlLinkArray:(NSArray *)linkArray
{
    if (!linkArray) {
        return;
    }
    
    //点击事件处理
    if (linkArray.count > 0) {
        
        for (NSString *link in linkArray) {
            
            __weak typeof(self)weakSelf = self;
            
            //点击事件响应
            [self.contentLabel appenTouchObserverForKeyword:link withHanlder:^(NSString *keyword, NSRange keywordRange) {
                [weakSelf tapOnUrl:keyword withRange:keywordRange];
            }];
            
        }
        
    }
}

//响应url点击事件
- (void)tapOnUrl:(NSString *)url withRange:(NSRange)linkRange
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textMessageCellDidTapOnUrl:withUrl:)]) {
        [self.delegate textMessageCellDidTapOnUrl:self withUrl:url];
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
    
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyContent:)];
    UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    NSArray *menuItems = @[item1,item2];
    [popMenu setMenuItems:menuItems];
    [popMenu setArrowDirection:UIMenuControllerArrowDown];
    
    [popMenu setTargetRect:self.bubbleBackImageView.frame inView:self];
    [popMenu setMenuVisible:YES animated:YES];
}

- (void)copyContent:(UIMenuItem *)item
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.contentCopyString];
}


#pragma mark - 设置内容
- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    [super setContentModel:contentModel];
    
    GJGCChatFriendContentModel *chatContentModel = (GJGCChatFriendContentModel *)contentModel;
    self.isFromSelf = chatContentModel.isFromSelf;
    self.contentCopyString = chatContentModel.originTextMessage;
    
    NSDictionary *parseDict = GJCFNSCacheGetValue(chatContentModel.originTextMessage);
    if (!parseDict) {
        parseDict = [GJGCChatContentEmojiParser parseContent:chatContentModel.originTextMessage];
    }
    NSAttributedString *attributedString = [parseDict objectForKey:@"contentString"];

    /*是否需要图片渲染缓存*/
    BOOL needRenderCache = [[parseDict objectForKey:@"needRenderCache"] boolValue];
    NSString *renderCacheKey = [NSString stringWithFormat:@"%@_renderCache",chatContentModel.originTextMessage];
    UIImage *renderCacheImage = GJCFNSCacheGetValue(renderCacheKey);
    
    /* 图片渲染缓存 */
    if (renderCacheImage) {
        
        self.contentLabel.hidden = YES;
        self.textRenderCacheImageView.hidden = NO;
        self.textRenderCacheImageView.image = renderCacheImage;
        self.textRenderCacheImageView.gjcf_size = renderCacheImage.size;
        
    }else{
        
        /* 重设置大小 */
        self.contentLabel.contentAttributedString = nil;
        if (contentModel.contentSize.height > 0) {
            
            self.contentSize = contentModel.contentSize;
            self.contentLabel.gjcf_size = contentModel.contentSize;
            
            
        }else{
            
            CGSize theContentSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:attributedString forBaseContentSize:self.contentLabel.contentBaseSize];
            self.contentSize = theContentSize;
            //        self.contentLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:attributedString forBaseContentSize:self.contentLabel.contentBaseSize];
            self.contentLabel.gjcf_size = theContentSize;
            
        }
        
        self.contentLabel.contentAttributedString = attributedString;
        
        NSArray *phoneArray = [parseDict objectForKey:@"phone"];
        NSArray *urlArray = [parseDict objectForKey:@"url"];
        
        if (phoneArray.count > 0) {
            [self setupTouchEnventWithPhoneNumberArray:phoneArray];
        }
        
        if (urlArray.count > 0) {
            [self setupTouchEventWithUrlLinkArray:urlArray];
        }
        
        /* 没有关键词点击事件监测 */
        if (phoneArray.count == 0 && urlArray.count == 0) {
            [self.contentLabel clearKeywordTouchEventHanlder];
        }
        
        self.contentLabel.hidden = self.contentLabel.contentAttributedString == nil? YES:NO;
        self.textRenderCacheImageView.image = nil;
        self.textRenderCacheImageView.hidden = YES;
        
        /* 缓存图片渲染 */
        if (needRenderCache && !renderCacheImage) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                [self.contentLabel setNeedsDisplay];
                
                UIImage *render = GJCFScreenShotFromView(self.contentLabel);
                
                GJCFNSCacheSet(renderCacheKey,render);
                
            });
        }
    }
    
    /* 图片缓存渲染 */
    if (renderCacheImage) {
        
        CGFloat renderHeight = self.textRenderCacheImageView.gjcf_height + 2*self.contentInnerMargin;
        renderHeight = MAX(renderHeight, 40);
        self.bubbleBackImageView.gjcf_height = renderHeight;
        self.bubbleBackImageView.gjcf_width = self.textRenderCacheImageView.gjcf_width + 2*self.contentInnerMargin + 5.5;
        
        if (chatContentModel.isFromSelf) {
            self.textRenderCacheImageView.gjcf_right = self.bubbleBackImageView.gjcf_width - 5.5 - self.contentInnerMargin;
        }else{
            self.textRenderCacheImageView.gjcf_left = self.contentInnerMargin + 5.5;
        }
        
        [self adjustContent];
        self.textRenderCacheImageView.gjcf_centerY = self.bubbleBackImageView.gjcf_height/2;
        
    }else{
        
        CGFloat textHeight = self.contentLabel.gjcf_height + 2*self.contentInnerMargin;
        textHeight = MAX(textHeight, 40);
        self.bubbleBackImageView.gjcf_height = textHeight;
        self.bubbleBackImageView.gjcf_width = self.contentLabel.gjcf_width + 2*self.contentInnerMargin + 5.5;
        
        if (chatContentModel.isFromSelf) {
            self.contentLabel.gjcf_right = self.bubbleBackImageView.gjcf_width - 5.5 - self.contentInnerMargin;
        }else{
            self.contentLabel.gjcf_left = self.contentInnerMargin + 5.5;
        }
        
        [self adjustContent];
        self.contentLabel.gjcf_centerY = self.bubbleBackImageView.gjcf_height/2;
        
    }

}

@end
