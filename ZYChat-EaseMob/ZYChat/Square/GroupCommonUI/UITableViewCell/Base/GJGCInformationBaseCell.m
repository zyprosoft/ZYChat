//
//  GJGCInformationBaseCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCInformationBaseCell.h"

@interface GJGCInformationBaseCell ()

@property (nonatomic,assign)BOOL canShowHighlightState;

@end

@implementation GJGCInformationBaseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.baseLineToCellBottomMargin = 0.f;
        
        self.topLineToCellTopMargin = 0.f;
        
        self.baseSeprateLineShortMargin = 16;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.baseContentView = [[UIImageView alloc]init];
        self.baseContentView.gjcf_top = self.topSeprateLine.gjcf_bottom;
        self.baseContentView.gjcf_left = 0;
        self.baseContentView.backgroundColor = [UIColor whiteColor];
        self.baseContentView.gjcf_width = GJCFSystemScreenWidth;
        self.baseContentView.gjcf_height = self.contentView.gjcf_height;
        self.baseContentView.userInteractionEnabled = YES;
        [self.baseContentView setHighlightedImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle tapHighlightColor], self.baseContentView.gjcf_size)];
        [self.contentView addSubview:self.baseContentView];
        
        self.topSeprateLine = [[UIImageView alloc]init];
        self.topSeprateLine.frame = CGRectMake(0, 0, GJCFSystemScreenWidth, 0.5);
        self.topSeprateLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self.contentView addSubview:self.topSeprateLine];
        
        self.baseSeprateLine = [[UIImageView alloc]init];
        self.baseSeprateLine.frame = CGRectMake(0, 0, GJCFSystemScreenWidth - self.baseSeprateLineShortMargin, 0.5);
        self.baseSeprateLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self.contentView addSubview:self.baseSeprateLine];
        

        // 指示箭头
        self.accessoryIndicatorView = [[UIImageView alloc]init];
        self.accessoryIndicatorView.gjcf_width = 7;
        self.accessoryIndicatorView.gjcf_height = 12;
        self.accessoryIndicatorView.image = GJCFQuickImage(@"按钮箭头");
        self.accessoryIndicatorView.gjcf_top = 25.f;
        self.accessoryIndicatorView.gjcf_right = GJCFSystemScreenWidth - 13;
        [self.contentView addSubview:self.accessoryIndicatorView];
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.canShowHighlightState) {
        [self.baseContentView setHighlighted:highlighted];
    }
    
}

- (void)showOrHiddenIndicatorByContentType:(GJGCInformationContentType)contentType withContentModelSettingState:(BOOL)shouldShow
{
    switch (contentType) {
        case GJGCInformationContentTypeLevelType:
        case GJGCInformationContentTypeBaseTextAndIcon:
        case GJGCInformationContentTypeMemberShow:
        {
            self.accessoryIndicatorView.hidden = NO;
            self.canShowHighlightState = YES;
        }
            break;
        case GJGCInformationContentTypeFeedList:
        {
            self.accessoryIndicatorView.hidden = YES;
            self.canShowHighlightState = YES;
        }
            break;
            
        default:
        {
            if (!shouldShow) {
                self.accessoryIndicatorView.hidden = YES;
                self.canShowHighlightState = NO;
            }else{
                self.accessoryIndicatorView.hidden = NO;
                self.canShowHighlightState = YES;
            }
        }
            break;
    }
}

- (void)setShouldShowIndicator:(BOOL)showIndicator
{
    self.accessoryIndicatorView.hidden = !showIndicator;
    self.canShowHighlightState = showIndicator;
}

- (void)setupSeprateLineStyle
{    
    switch (self.seprateStyle) {
        case GJGCInformationSeprateLineStyleTopFullBottomFull:
        {
            self.topSeprateLine.hidden = NO;
            self.baseSeprateLine.hidden = NO;
            self.baseSeprateLine.gjcf_width = GJCFSystemScreenWidth;
            self.topSeprateLine.gjcf_width = GJCFSystemScreenWidth;
        }
            break;
        case GJGCInformationSeprateLineStyleTopFullBottomShort:
        {
            self.topSeprateLine.hidden = NO;
            self.baseSeprateLine.hidden = NO;
            self.topSeprateLine.gjcf_width = GJCFSystemScreenWidth;
            self.baseSeprateLine.gjcf_width = GJCFSystemScreenWidth - self.baseSeprateLineShortMargin;
            self.baseSeprateLine.gjcf_left = self.baseSeprateLineShortMargin;
        }
            break;
        case GJGCInformationSeprateLineStyleTopNoneBottomFull:
        {
            self.topSeprateLine.hidden = YES;
            self.baseSeprateLine.hidden = NO;
            self.baseSeprateLine.gjcf_width = GJCFSystemScreenWidth;
        }
            break;
        case GJGCInformationSeprateLineStyleTopNoneBottomShort:
        {
            self.topSeprateLine.hidden = YES;
            self.baseSeprateLine.hidden = NO;
            self.baseSeprateLine.gjcf_width = GJCFSystemScreenWidth - self.baseSeprateLineShortMargin;
            self.baseSeprateLine.gjcf_left = self.baseSeprateLineShortMargin;
        }
            break;
        case GJGCInformationSeprateLineStyleTopFullBottomNone:
        {
            self.topSeprateLine.hidden = NO;
            self.baseSeprateLine.hidden = YES;
            self.topSeprateLine.gjcf_width = GJCFSystemScreenWidth;
        }
            break;
        default:
            break;
    }
}

- (void)setContentInformationModel:(GJGCInformationBaseModel *)contentModel
{
    self.topSeprateLine.gjcf_left = 0.f;
    self.baseSeprateLine.gjcf_left = 0.f;
    self.baseLineToCellBottomMargin = contentModel.baseLineMargin;
    self.topLineToCellTopMargin = contentModel.topLineMargin;
    self.seprateStyle = contentModel.seprateStyle;
    [self setupSeprateLineStyle];
    [self showOrHiddenIndicatorByContentType:contentModel.baseContentType withContentModelSettingState:contentModel.shouldShowIndicator];
}

- (CGFloat)heightForInformationModel:(GJGCInformationBaseModel *)contentModel
{
    /* 分割线两像素 */
    return self.baseContentView.gjcf_bottom + self.baseLineToCellBottomMargin;
}

@end
