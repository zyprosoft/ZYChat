//
//  GJGCWebViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCWebViewController.h"

@interface GJGCWebViewController ()

@property (nonatomic,strong)UIWebView *webVeiw;

@end

@implementation GJGCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"网页浏览"];
    
    self.webVeiw = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webVeiw];
}

- (void)setUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webVeiw loadRequest:request];
}

- (void)leftButtonPressed:(UIButton *)sender
{
    [super leftButtonPressed:sender];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
