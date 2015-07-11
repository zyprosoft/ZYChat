//
//  GJGCChatBaseCell.m
//  ZYChat
//
//  Created by ZYVincent on 14-10-17.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJGCChatSystemNotiBaseCell.h"
#import "GJGCChatSystemNotiModel.h"

@interface GJGCChatSystemNotiBaseCell ()

@property (nonatomic,assign)BOOL canShowHighlightState;

@end

@implementation GJGCChatSystemNotiBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
                
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.timeContentMargin = 13.f;
        self.contentBordMargin = 13.f;
        self.contentInnerMargin = 13.f;
        self.cellMargin = 13.f;
        
        //  时间
        self.timeLabel = [[GJCFCoreTextContentView alloc]init];
        self.timeLabel.frame = CGRectMake(90,self.cellMargin, 140, 10);
        self.timeLabel.gjcf_centerX = self.contentView.gjcf_centerX;
        self.timeLabel.contentBaseWidth = self.timeLabel.gjcf_width;
        self.timeLabel.contentBaseHeight = self.timeLabel.gjcf_height;
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.timeLabel];
        
        // 状态背景
        self.stateContentView = [[UIImageView alloc]init];
        self.stateContentView.backgroundColor = [UIColor clearColor];
        self.stateContentView.gjcf_left = self.contentBordMargin;
        self.stateContentView.gjcf_width = GJCFSystemScreenWidth - 2*self.contentBordMargin;
        self.stateContentView.gjcf_top = self.timeLabel.gjcf_bottom+self.timeContentMargin;
        self.stateContentView.gjcf_height = 144;
        self.stateContentView.userInteractionEnabled = YES;
        //这个图片在系统生活内有使用，独立项目中不再添加
        UIImage *normal = [UIImage imageNamed:@"IM-系统推荐列表BG"];
        UIImage *highlight = [UIImage imageNamed:@"IM-系统推荐列表BG-点击"];
        self.stateContentView.image = GJCFImageResize(normal, 12, 12, 12, 12);
        self.stateContentView.highlightedImage = GJCFImageResize(highlight, 12, 12, 12, 12);
        [self.contentView addSubview:self.stateContentView];
        
        // 指示箭头
        self.accessoryIndicator = [[UIImageView alloc]init];
        self.accessoryIndicator.gjcf_width = 7;
        self.accessoryIndicator.gjcf_height = 12;
        self.accessoryIndicator.image = GJCFQuickImage(@"按钮箭头.png");
        self.accessoryIndicator.gjcf_top = 25.f;
        self.accessoryIndicator.gjcf_right = self.stateContentView.gjcf_width - self.contentInnerMargin;
        [self.stateContentView addSubview:self.accessoryIndicator];
        
        // 文本内容
        self.contentLabel = [[GJCFCoreTextContentView alloc]init];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.gjcf_top = self.contentInnerMargin;
        self.contentLabel.gjcf_left = self.contentInnerMargin;
        self.contentLabel.gjcf_width =  self.stateContentView.gjcf_width - 2*self.contentInnerMargin;
        self.contentLabel.contentBaseWidth = self.contentLabel.gjcf_width;
        self.contentLabel.contentBaseHeight = self.contentLabel.gjcf_height;
        [self.stateContentView addSubview:self.contentLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (self.canShowHighlightState) {
        [self.stateContentView setHighlighted:highlighted];
    }
}

- (void)showOrHiddenIndicatorViewByContentType:(GJGCChatSystemNotiType)notiType
{
    switch (notiType) {
        case GJGCChatSystemNotiTypeOhtherGroupApplyMyAuthoriz:
            
        case GJGCChatSystemNotiTypeOtherApplyMyAuthorizWithMyOperationState:
            
        case GJGCChatSystemNotiTypeOtherPersonApplyMyAuthoriz:
            
        case GJGCChatSystemNotiTypeGroupOperationState:
        {
            self.accessoryIndicator.hidden = NO;
        }
            break;
        case GJGCChatSystemNotiTypeSystemActiveGuide:
            
        case GJGCChatSystemNotiTypeSystemOperationState:
        {
            self.accessoryIndicator.hidden = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark - 初始化子视图

- (void)setShowAccesoryIndicator:(BOOL)showAccesoryIndicator
{
    if (_showAccesoryIndicator == showAccesoryIndicator) {
        return;
    }
    _showAccesoryIndicator = showAccesoryIndicator;
    self.accessoryIndicator.hidden = !_showAccesoryIndicator;
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    if (!contentModel) {
        return;
    }
    
    GJGCChatSystemNotiModel *notiModel = (GJGCChatSystemNotiModel *)contentModel;
    self.canShowHighlightState = notiModel.canShowHighlightState;
    
    self.timeLabel.contentAttributedString = notiModel.timeString;
    self.timeLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:notiModel.timeString forBaseContentSize:self.timeLabel.contentBaseSize];
    self.timeLabel.gjcf_centerX = GJCFSystemScreenWidth/2;
    
    [self showOrHiddenIndicatorViewByContentType:notiModel.notiType];

    self.contentLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:notiModel.systemOperationTip forBaseContentSize:self.contentLabel.contentBaseSize];
    self.contentLabel.contentAttributedString = notiModel.systemOperationTip;
    
    self.stateContentView.gjcf_height = self.contentLabel.gjcf_bottom + self.contentInnerMargin;
}

- (CGFloat)cellHeight
{
    return self.stateContentView.gjcf_bottom + self.cellMargin;
}

- (CGFloat)heightForContentModel:(GJGCChatContentBaseModel *)contentModel
{    
    return [self cellHeight];
}

@end
