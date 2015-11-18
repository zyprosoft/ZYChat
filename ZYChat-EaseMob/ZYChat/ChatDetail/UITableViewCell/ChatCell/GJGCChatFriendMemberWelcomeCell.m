//
//  GJGCChatFriendMemberWelcomeCell.m
//  ZYChat
//
//  Created by ZYVincent on 15-3-18.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCChatFriendMemberWelcomeCell.h"
#import "GJGCChatSystemNotiRolePersonView.h"

@interface GJGCChatFriendMemberWelcomeCell ()

@property (nonatomic,strong)UIImageView *backgroundImageView;

@property (nonatomic,strong)GJCFCoreTextContentView *titleLabel;

@property (nonatomic,strong)GJGCCommonHeadView *innerHeadView;

@property (nonatomic,strong)GJCFCoreTextContentView *innerNameLabel;

@property (nonatomic,strong)GJGCChatSystemNotiRolePersonView *personView;

@property (nonatomic,assign)CGFloat contentInnerMargin;

@end

@implementation GJGCChatFriendMemberWelcomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentInnerMargin = 11.f;
        
        CGFloat bubbleToBordMargin = 59;
        CGFloat maxTextContentWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 5.5 - 13 - 2*self.contentInnerMargin;

        self.backgroundImageView = [[UIImageView alloc]init];
        self.backgroundImageView.gjcf_width = maxTextContentWidth + 13*2;
        self.backgroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.backgroundImageView];
        
        self.titleLabel = [[GJCFCoreTextContentView alloc]init];
        self.titleLabel.gjcf_size = CGSizeMake(maxTextContentWidth,20);
        self.titleLabel.gjcf_left = self.contentInnerMargin;
        self.titleLabel.contentBaseSize = self.titleLabel.gjcf_size;
        self.titleLabel.userInteractionEnabled = NO;
        [self.backgroundImageView addSubview:self.titleLabel];
        
        self.innerHeadView = [[GJGCCommonHeadView alloc]init];
        self.innerHeadView.gjcf_size = CGSizeMake(48, 48);
        self.innerHeadView.gjcf_left = self.contentInnerMargin;
        self.innerHeadView.gjcf_top = 8.f;
        self.innerHeadView.userInteractionEnabled = NO;
        [self.backgroundImageView addSubview:self.innerHeadView];
        
        self.innerNameLabel = [[GJCFCoreTextContentView alloc]init];
        self.innerNameLabel.gjcf_size = CGSizeMake(maxTextContentWidth - 48 - self.contentInnerMargin, 10);
        self.innerNameLabel.contentBaseSize = self.innerNameLabel.gjcf_size;
        self.innerNameLabel.userInteractionEnabled = NO;
        [self.backgroundImageView addSubview:self.innerNameLabel];
        
        self.personView = [[GJGCChatSystemNotiRolePersonView alloc]init];
        self.personView.backgroundColor = [UIColor clearColor];
        self.personView.gjcf_left = self.innerNameLabel.gjcf_left;
        self.personView.gjcf_top = self.innerNameLabel.gjcf_bottom + self.contentInnerMargin;
        self.personView.gjcf_width = self.innerNameLabel.gjcf_width;
        self.personView.gjcf_height = 30;
        self.personView.userInteractionEnabled = NO;
        [self.backgroundImageView addSubview:self.personView];
        
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf)];
        [self.backgroundImageView addGestureRecognizer:tapR];
    }
    return self;
}

- (void)tapOnSelf
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidTapOnWelcomeMemberCard:)]) {
        [self.delegate chatCellDidTapOnWelcomeMemberCard:self];
    }
}

- (UIImage *)backgroundImageBySex:(NSInteger)sex age:(NSInteger)age
{
    if (sex == 0 && age <= 28) {
        
        UIImage *originImage = [UIImage imageNamed:@"妹子新人-bg-card"];
        
        CGFloat centerX = originImage.size.width/2;
        CGFloat centerY = originImage.size.height/2;
        
        CGFloat top = centerY - 2;
        CGFloat bottom = centerY + 2;
        CGFloat left = centerX - 2;
        CGFloat right = centerX + 2;
        
        UIImage *stretchImage = GJCFImageResize(originImage, top, bottom, left, right);
        
        return stretchImage;
        
    }else{
       
        UIImage *originImage = [UIImage imageNamed:@"新人-bg-card"];
        
        CGFloat centerX = originImage.size.width/2;
        CGFloat centerY = originImage.size.height/2;
        
        CGFloat top = centerY - 2;
        CGFloat bottom = centerY + 2;
        CGFloat left = centerX - 2;
        CGFloat right = centerX + 2;
        
        UIImage *stretchImage = GJCFImageResize(originImage, top, bottom, left, right);
        
        return stretchImage;
    }
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }

    GJGCChatFriendContentModel *welcomeModel = (GJGCChatFriendContentModel *)contentModel;
    self.isFromSelf = welcomeModel.isFromSelf;
    self.isGroupChat = welcomeModel.isGroupChat;
    
    self.headView.gjcf_left = self.contentBordMargin;
    self.nameLabel.gjcf_top = 0.f;
    self.nameLabel.hidden = NO;
    self.nameLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:welcomeModel.senderName forBaseContentSize:self.nameLabel.contentBaseSize];
    self.nameLabel.contentAttributedString = welcomeModel.senderName;
    self.nameLabel.gjcf_left = self.headView.gjcf_right + self.contentBordMargin + 3;
    self.headView.gjcf_top = 0.f;
    self.backgroundImageView.gjcf_left = self.headView.gjcf_right + 11.5;
    self.backgroundImageView.gjcf_top = self.nameLabel.gjcf_bottom + 3;
    self.bubbleBackImageView.hidden = YES;

    NSString *headerUrl = @"";
    NSString *innerHeadUrl = @"";

    self.titleLabel.contentAttributedString = welcomeModel.titleString;
    self.titleLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:welcomeModel.titleString forBaseContentSize:self.titleLabel.contentBaseSize];
    self.titleLabel.gjcf_centerY = 18;
    
    self.innerHeadView.gjcf_top = self.titleLabel.gjcf_bottom + 8 + 11.f;
    self.innerNameLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:welcomeModel.nameString forBaseContentSize:self.innerNameLabel.contentBaseSize];
    self.innerNameLabel.contentAttributedString = welcomeModel.nameString;
    self.innerNameLabel.gjcf_left = self.innerHeadView.gjcf_right + 11.f;
    self.innerNameLabel.gjcf_top = self.innerHeadView.gjcf_top;
    
    [self.headView setHeadUrl:headerUrl headViewType:GJGCCommonHeadViewTypeContact];
    
    self.innerHeadView.gjcf_left = self.contentInnerMargin;
    [self.innerHeadView setHeadUrl:innerHeadUrl headViewType:GJGCCommonHeadViewTypeContact];
    
    //布局
    self.personView.gjcf_top = self.innerNameLabel.gjcf_bottom + 11.f;
    self.personView.sex = welcomeModel.sex;
    self.personView.age = welcomeModel.ageString;
    self.personView.starName = welcomeModel.starString;
    self.personView.gjcf_left = self.innerNameLabel.gjcf_left;
    
    self.backgroundImageView.gjcf_height = self.innerHeadView.gjcf_bottom + self.contentInnerMargin;
    self.backgroundImageView.image = [self backgroundImageBySex:welcomeModel.sex age:[welcomeModel.ageString.string integerValue]];
    
    if (self.isFromSelf) {
        
        /* 头像矫正 */
        self.headView.gjcf_right = GJCFSystemScreenWidth - self.contentBordMargin ;
        self.backgroundImageView.gjcf_right = self.headView.gjcf_left - self.contentBordMargin + 5;
        
    }else{
        
        /* 头像矫正 */
        self.headView.gjcf_left = self.contentBordMargin;
    }
    
    if (self.isGroupChat && !self.isFromSelf) {
        
        self.nameLabel.gjcf_top = 0.f;
        self.nameLabel.hidden = NO;
        self.nameLabel.gjcf_left = self.headView.gjcf_right + self.contentBordMargin;
        self.backgroundImageView.gjcf_left = self.nameLabel.gjcf_left - 5;
        self.headView.gjcf_top = 0.f;
        self.backgroundImageView.gjcf_top = self.nameLabel.gjcf_bottom + 3;
        
    }else{
        
        self.headView.gjcf_top = 0.f;
        self.nameLabel.hidden = YES;
        self.backgroundImageView.gjcf_top = self.headView.gjcf_top;
    }
}

- (CGFloat)heightForContentModel:(GJGCChatContentBaseModel *)contentModel
{
    return self.backgroundImageView.gjcf_bottom + self.cellMargin;
}

@end
