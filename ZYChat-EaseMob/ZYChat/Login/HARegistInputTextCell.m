//
//  HARegistInputTextCell.m
//  HelloAsk
//
//  Created by ZYVincent on 15-9-4.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "HARegistInputTextCell.h"

@interface HARegistInputTextCell ()<UITextFieldDelegate>

@property (nonatomic,strong)UILabel *tagLabel;

@property (nonatomic,strong)UIImageView *tagSeprateLine;

@property (nonatomic,strong)UIImageView *topLine;

@property (nonatomic,strong)UIImageView *bottomLine;

@property (nonatomic,strong)UITextField *inputTextField;

@property (nonatomic,strong)UIView *stateView;

@end
@implementation HARegistInputTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
        
        self.stateView = [[UIView alloc]init];
        self.stateView.backgroundColor = [UIColor whiteColor];
        self.stateView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.stateView];
        
        self.topLine = [[UIImageView alloc]init];
        self.topLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        self.topLine.gjcf_width = GJCFSystemScreenWidth;
        self.topLine.gjcf_height = 0.5f;
        [self.contentView addSubview:self.topLine];
        
        self.tagLabel = [[UILabel alloc]init];
        self.tagLabel.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.tagLabel.textColor = [GJGCCommonFontColorStyle mainThemeColor];
        [self.contentView addSubview:self.tagLabel];
        
        self.tagSeprateLine = [[UIImageView alloc]init];
        self.tagSeprateLine.gjcf_width = 0.5f;
        self.tagSeprateLine.gjcf_height = 30.f;
        self.tagSeprateLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        [self.contentView addSubview:self.tagSeprateLine];
        
        self.inputTextField = [[UITextField alloc]init];
        self.inputTextField.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.inputTextField.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        self.inputTextField.delegate = self;
        [self.contentView addSubview:self.inputTextField];
        
        self.bottomLine = [[UIImageView alloc]init];
        self.bottomLine.backgroundColor = [GJGCCommonFontColorStyle mainSeprateLineColor];
        self.bottomLine.gjcf_width = GJCFSystemScreenWidth;
        self.bottomLine.gjcf_height = 0.5f;
        [self.contentView addSubview:self.bottomLine];
        
        [GJCFNotificationCenter addObserver:self selector:@selector(observeTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [GJCFNotificationCenter removeObserver:self];
}

- (void)setContentModel:(HARegistContentModel *)contentModel
{
    self.tagLabel.text = contentModel.tagName;
    [self.tagLabel sizeToFit];
    
    CGFloat contentHeight = contentModel.contentHeight - 15.f;
    
    self.tagLabel.gjcf_left = 13.f;
    self.tagLabel.gjcf_centerY = contentHeight/2;
    
    self.tagSeprateLine.gjcf_left = self.tagLabel.gjcf_right + 10.f;
    self.tagSeprateLine.gjcf_height = self.tagLabel.gjcf_height;
    self.tagSeprateLine.gjcf_centerY = self.tagLabel.gjcf_centerY;
    
    self.inputTextField.gjcf_width = GJCFSystemScreenWidth - self.tagSeprateLine.gjcf_right - 8.f - 13.f;
    self.inputTextField.gjcf_left = self.tagSeprateLine.gjcf_right + 8.f;
    self.inputTextField.gjcf_height = contentHeight - 2*4.f;
    self.inputTextField.gjcf_centerY = contentHeight/2;
    self.inputTextField.placeholder = contentModel.placeHolder;
    self.inputTextField.text = contentModel.content;
    
    self.stateView.gjcf_width = GJCFSystemScreenWidth;
    self.stateView.gjcf_height = contentHeight;
    self.bottomLine.gjcf_bottom = contentHeight;
    
}

- (void)observeTextChanged:(NSNotification *)noti
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputCell:didUpdateContent:)] && !GJCFStringIsNull(self.inputTextField.text)) {
        
        [self.delegate inputCell:self didUpdateContent:self.inputTextField.text];
    }
}


@end
