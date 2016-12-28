//
//  GJGCRecentChatCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCRecentChatCell.h"
#import "GJGCChatContentEmojiParser.h"
#import "GJGCChatFriendCellStyle.h"

@interface GJGCRecentChatCell ()

@property (nonatomic,strong)GJGCCommonHeadView *headView;

@property (nonatomic,strong)GJCFCoreTextContentView *nameLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *timeLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *contentLabel;

@property (nonatomic,strong)UIImageView *bottomLine;

@property (nonatomic,strong)UILabel *unReadCountLabel;

@end

@implementation GJGCRecentChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];

        self.headView = [[GJGCCommonHeadView alloc]init];
        self.headView.gjcf_size = CGSizeMake(55, 55);
        self.headView.gjcf_left = 13.f;
        self.headView.gjcf_top = 10.f;
        self.headView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.headView];
        
        self.nameLabel = [[GJCFCoreTextContentView alloc]init];
        self.nameLabel.contentBaseWidth = GJCFSystemScreenWidth - self.headView.gjcf_width - 3*13.f - 40.f;
        self.nameLabel.contentBaseHeight = 10.f;
        [self.contentView addSubview:self.nameLabel];
        
        
        self.timeLabel = [[GJCFCoreTextContentView alloc]init];
        self.timeLabel.contentBaseWidth = 100.f;
        self.timeLabel.contentBaseHeight = 10.f;
        [self.contentView addSubview:self.timeLabel];
        
        self.contentLabel = [[GJCFCoreTextContentView alloc]init];
        self.contentLabel.contentBaseWidth = self.nameLabel.contentBaseWidth + 40.f;
        self.contentLabel.contentBaseHeight = 10.f;
        [self.contentLabel appendImageTag:[GJGCChatFriendCellStyle imageTag]];
        [self.contentView addSubview:self.contentLabel];
        
        self.unReadCountLabel = [[UILabel alloc]init];
        self.unReadCountLabel.gjcf_size = (CGSize){26,26};
        self.unReadCountLabel.backgroundColor = [UIColor redColor];
        self.unReadCountLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.unReadCountLabel.textColor = [UIColor whiteColor];
        self.unReadCountLabel.textAlignment = NSTextAlignmentCenter;
        self.unReadCountLabel.layer.cornerRadius = self.unReadCountLabel.gjcf_width/2;
        self.unReadCountLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.unReadCountLabel];
        
        self.bottomLine = [[UIImageView alloc]init];
        self.bottomLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        self.bottomLine.gjcf_width = GJCFSystemScreenWidth;
        self.bottomLine.gjcf_height = 0.5f;
        [self.contentView addSubview:self.bottomLine];
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    UIColor *contentStateColor = nil;
    if (highlighted) {
        contentStateColor = [UIColor colorWithRed:97/255.f green:60/255.f blue:140/255.f alpha:0.6];
    }else{
        contentStateColor = [UIColor clearColor];
    }
    self.contentView.backgroundColor = contentStateColor;
}

- (void)setContentModel:(GJGCRecentChatModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    [self.headView setHeadUrl:contentModel.headUrl];
    
    CGSize nameSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:contentModel.name forBaseContentSize:self.nameLabel.contentBaseSize];
    self.nameLabel.gjcf_size = nameSize;
    self.nameLabel.gjcf_left = self.headView.gjcf_right + 13.f;
    self.nameLabel.gjcf_top = self.headView.gjcf_top + 6.f;
    self.nameLabel.contentAttributedString = contentModel.name;
    
    CGSize timeSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:contentModel.time forBaseContentSize:self.timeLabel.contentBaseSize];
    self.timeLabel.gjcf_size = timeSize;
    self.timeLabel.gjcf_right = GJCFSystemScreenWidth - 13.f;
    self.timeLabel.gjcf_top = self.nameLabel.gjcf_top;
    self.timeLabel.contentAttributedString = contentModel.time;
    self.timeLabel.gjcf_centerY = self.nameLabel.gjcf_centerY;

    self.unReadCountLabel.text = [NSString stringWithFormat:@"%ld",(long)contentModel.unReadCount];
    self.unReadCountLabel.gjcf_right = GJCFSystemScreenWidth - 13.f;
    self.unReadCountLabel.hidden = contentModel.unReadCount == 0? YES:NO;
    
    self.contentLabel.gjcf_width = self.unReadCountLabel.gjcf_left - 5.f - self.headView.gjcf_right - 6.f;
    self.contentLabel.gjcf_height = 28.f;
    self.contentLabel.gjcf_left = self.nameLabel.gjcf_left;
    self.contentLabel.gjcf_bottom = self.headView.gjcf_bottom;
    self.unReadCountLabel.gjcf_centerY = self.contentLabel.gjcf_centerY;

    NSDictionary *parseDict = GJCFNSCacheGetValue(contentModel.content);
    if (!parseDict) {
        parseDict = [GJGCChatContentEmojiParser parseRecentContent:contentModel.content];
    }
    NSAttributedString *attributedString = [parseDict objectForKey:@"contentString"];
    self.contentLabel.contentAttributedString = attributedString;
    
    self.bottomLine.gjcf_bottom = self.contentLabel.gjcf_bottom + self.headView.gjcf_top;
    self.bottomLine.gjcf_left = self.headView.gjcf_right + self.headView.gjcf_left;
    NSLog(@"self.bottomLine.bottom:%lf",self.bottomLine.gjcf_bottom);
}

@end
