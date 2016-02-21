//
//  GJGCTagView.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14/11/23.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import "GJGCTagView.h"
#import "GJCFCoreTextContentView.h"
#import "GJCFCoreTextAttributedStringStyle.h"

#define GJGC_TAG_ImageName1 @"标签-bg-老乡"     // 老乡
#define GJGC_TAG_ImageName2 @"标签-bg-同行"     // 同行
#define GJGC_TAG_ImageName3 @"标签-bg-热聊"     // 热聊
#define GJGC_TAG_ImageName4 @"标签-bg-预留1"
#define GJGC_TAG_ImageName5 @"标签-bg-同城"    // 同城
#define GJGC_TAG_ImageName6 @"标签-bg-妹子多"    // 妹子多
#define GJGC_TAG_ImageName7 @"标签-bg-美女群主"   // 美女群主
#define GJGC_TAG_ImageName8 @"标签-bg-预留3"
#define GJGC_TAG_ImageName9 @"标签-bg-预留4"
#define GJGC_TAG_ImageName10 @"标签-bg-群主"    // 群主
#define GJGC_TAG_ImageNameDefault @"标签-bg-预留3"  // 默认

@interface GJGCTagView ()

@property (nonatomic,strong)UIImageView *backImagView;

//@property (nonatomic,strong)UILabel *textLabel;

@property (nonatomic,strong)GJCFCoreTextContentView *textLabel;

@end

@implementation GJGCTagView


- (instancetype)init
{
    if (self = [super init]) {
        
        [self setupStyle];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupStyle];
        
    }
    return self;
}

- (void)setupStyle
{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, 35, 20);
    
    self.backImagView = [[UIImageView alloc]init];
    [self addSubview:self.backImagView];
    
    /* textLabel */
    self.textLabel = [[GJCFCoreTextContentView alloc]init];
    self.textLabel.gjcf_left = 2;
    self.textLabel.gjcf_width = 35;
    self.textLabel.gjcf_top = 2;
    self.textLabel.gjcf_height = 20;
    self.textLabel.contentBaseWidth = self.textLabel.gjcf_width;
    self.textLabel.contentBaseHeight = self.textLabel.gjcf_height;
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textLabel];
}




- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_content.string.length > 3) {
        self.textLabel.gjcf_width = 2 + _content.string.length * 11;
        self.textLabel.contentBaseWidth = self.textLabel.gjcf_width;
    }
    self.textLabel.gjcf_size = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:_content forBaseContentSize:self.textLabel.contentBaseSize];
    self.textLabel.contentAttributedString = _content;
    
    self.gjcf_width = self.textLabel.gjcf_width + 4;
    self.gjcf_height = self.textLabel.gjcf_height + 4;
    self.textLabel.gjcf_centerY = self.gjcf_height/2;
    self.backImagView.frame = self.bounds;

    /* 绘制背景 */
    NSString *realImageName = [self getImageNameWithStr:_imageName];
    UIImage *backImage = GJCFQuickImage(realImageName);
    backImage = GJCFImageResize(backImage, 3, 3, 3, 3);
    self.backImagView.image = backImage;
    
}

- (NSDictionary *)typeToImageDict
{
    return @{
             @(1):GJGC_TAG_ImageName1,
             @(2):GJGC_TAG_ImageName2,
             @(3):GJGC_TAG_ImageName3,
             @(4):GJGC_TAG_ImageName4,
             @(5):GJGC_TAG_ImageName5,
             @(6):GJGC_TAG_ImageName8,
             @(7):GJGC_TAG_ImageName9,
             };
}

- (void)setType:(NSInteger)aType
{
    if (_type == aType) {
        return;
    }
    
    _type = aType;
    
    _imageName = [[self typeToImageDict]objectForKey:@(aType)];
    
    if (!_imageName) {
        
        _imageName = GJGC_TAG_ImageNameDefault;
        
    }
    
    [self setNeedsLayout];
}

-(NSString*)getImageNameWithStr:(NSString*)aStr
{
    NSString *realImgName = aStr;
    NSArray *nameArr =[NSArray arrayWithObjects:GJGC_TAG_ImageName1,GJGC_TAG_ImageName2,GJGC_TAG_ImageName3,GJGC_TAG_ImageName4,GJGC_TAG_ImageName5,GJGC_TAG_ImageName6,GJGC_TAG_ImageName7,GJGC_TAG_ImageName8,GJGC_TAG_ImageName9,GJGC_TAG_ImageName10, nil];
    if (![nameArr containsObject:aStr]) {
        realImgName = GJGC_TAG_ImageNameDefault;
    }
    return realImgName;
}





@end
