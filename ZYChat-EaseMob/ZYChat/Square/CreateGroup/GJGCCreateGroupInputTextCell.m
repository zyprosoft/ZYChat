//
//  GJGCCreateGroupInputTextCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/21.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCCreateGroupInputTextCell.h"
#import "GJCFStringUitil.h"

@interface GJGCCreateGroupInputTextCell ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *textField;

@property (nonatomic,assign)BOOL phoneNumberInputLimit;

@property (nonatomic,assign)BOOL numberInputLimit;

@end

@implementation GJGCCreateGroupInputTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textField = [[UITextField alloc]init];
        self.textField.gjcf_size = (CGSize){GJCFSystemScreenWidth - 60 - 13,25};
        self.textField.delegate = self;
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.font = [GJGCCommonFontColorStyle listTitleAndDetailTextFont];
        self.textField.textColor = [GJGCCommonFontColorStyle listTitleAndDetailTextColor];
        self.textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:self.textField];
        
    }
    return self;
}

#pragma mark - textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextCellDidBeginEdit:)]) {
        
        [self.delegate inputTextCellDidBeginEdit:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextCell:didUpdateContent:)]) {
        
        [self.delegate inputTextCell:self didUpdateContent:self.textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextCellDidTapOnReturnButton:didUpdateContent:)]) {
        
        [self.delegate inputTextCellDidTapOnReturnButton:self didUpdateContent:self.textField.text];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""]){
        
        return YES;
    }
    
    //判定输入长度
    if (textField.text.length >= self.maxInputLength && self.maxInputLength > 0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextCellDidTriggleMaxLengthInputLimit:maxLength:)]) {
            
            [self.delegate inputTextCellDidTriggleMaxLengthInputLimit:self maxLength:self.maxInputLength];
            
        }
        
        return NO;
    }
    
    if (self.phoneNumberInputLimit) {
        
        NSString *checkRegex = @"^[0-9]-*$";
        
        BOOL isPhoneNumber = [GJCFStringUitil sourceString:string regexMatch:checkRegex];
        
        return isPhoneNumber;
        
    }else if(self.numberInputLimit){
        
        return GJCFStringNumOnly(string);
        
    }else{
        
        return YES;
    }
}

- (NSString *)contentValue
{
    return self.textField.text;
}

- (void)setContentModel:(GJGCCreateGroupContentModel *)contentModel
{
    [super setContentModel:contentModel];
    
    self.phoneNumberInputLimit = contentModel.isPhoneNumberInputLimit;
    self.numberInputLimit = contentModel.isNumberInputLimit;
    self.maxInputLength = contentModel.maxInputLength;
    self.textField.placeholder = contentModel.placeHolder;
    self.textField.gjcf_width = GJCFSystemScreenWidth - self.seprateLine.gjcf_right - 8.f - 13.f;
    self.textField.gjcf_left = self.seprateLine.gjcf_right + 8.f;
    self.textField.gjcf_centerY = self.tagLabel.gjcf_centerY;
    self.textField.text = contentModel.content;
}

- (void)resignInputFirstResponse
{
    [self.textField resignFirstResponder];
}


@end
