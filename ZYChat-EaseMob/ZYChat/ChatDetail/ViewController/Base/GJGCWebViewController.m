//
//  GJGCWebViewController.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCWebViewController.h"
#import "GJGCRecentContactListViewController.h"

@interface GJGCWebViewController ()

@property (nonatomic,strong)UIWebView *webView;

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, copy)NSString *theUrl;

@end

@implementation GJGCWebViewController

- (instancetype)initWithUrl:(NSString *)url
{
    if (self = [super init]) {
        
        self.theUrl = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"网页浏览"];
    [self setRightButtonWithTitle:@"转发"];
    
    self.view.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.gjcf_height = GJCFSystemScreenHeight - self.contentOriginY;
    self.webView.gjcf_width = GJCFSystemScreenWidth;
    [self.webView.scrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
    [self.view addSubview:self.webView];
    
    if (![self.theUrl hasPrefix:@"https://"] && ![self.theUrl hasPrefix:@"http://"]) {
        self.theUrl = [NSString stringWithFormat:@"http://%@",self.theUrl];
    }
    
    if (self.theUrl) {
        
        [self setUrl:self.theUrl];
    }
}

- (void)setUrl:(NSString *)url
{
    self.theUrl = url;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self.webView loadRequest:request];
}

- (void)rightButtonPressed:(UIButton *)sender
{
    GJGCRecentChatForwardContentModel *forwardContent = [[GJGCRecentChatForwardContentModel alloc]init];
    forwardContent.contentType = GJGCChatFriendContentTypeWebPage;
    forwardContent.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    forwardContent.sumary = forwardContent.title;
    forwardContent.thumbImage = GJCFScreenShotFromView(self.webView);
    forwardContent.webUrl = self.webView.request.URL.absoluteString;
    
    GJGCRecentContactListViewController *recentContact = [[GJGCRecentContactListViewController alloc]initWithForwardContent:forwardContent];
    UINavigationController *recentContactNav = [[UINavigationController alloc]initWithRootViewController:recentContact];
    UIImage *navigationBarBack = GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], CGSizeMake(GJCFSystemScreenWidth * GJCFScreenScale, 64.f * GJCFScreenScale));
    [recentContactNav.navigationBar setBackgroundImage:navigationBarBack forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController presentViewController:recentContactNav animated:YES completion:nil];
}

@end
