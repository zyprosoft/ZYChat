//
//  GJGCMutilTextInputViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCMutilTextInputViewController.h"

@interface GJGCMutilTextInputViewController ()

@property (nonatomic,strong)UITextView *textView;

@end

@implementation GJGCMutilTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:self.title];
    
    [self setRightButtonWithTitle:@"完成"];
    
    self.textView = [[UITextView alloc]init];
    self.textView.gjcf_width = GJCFSystemScreenWidth;
    self.textView.gjcf_height = GJCFSystemScreenHeight;
    self.textView.font = [UIFont systemFontOfSize:15.f];
    self.textView.text = self.paramString;
    [self.view addSubview:self.textView];
    
    [self.textView becomeFirstResponder];
    
}

- (void)rightButtonPressed:(UIButton *)sender
{
    [self.textView resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mutilTextInputViewController:didFinishInputText:)]) {
        [self.delegate mutilTextInputViewController:self didFinishInputText:self.textView.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
