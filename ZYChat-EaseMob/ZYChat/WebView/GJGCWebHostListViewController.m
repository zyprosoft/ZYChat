//
//  GJGCWebHostListViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/24.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCWebHostListViewController.h"
#import "GJGCWebViewController.h"

#define GJGCWebHostListFile @"GJGCWebHostListFile"
#define GJGCWebHostCacheName @"GJGCWebHostCacheName"
#define GJGCWebHostCacheUrl @"GJGCWebHostCacheUrl"

@interface GJGCWebHostListViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *hostList;

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation GJGCWebHostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"经常访问的网站"];
    
    [self setRightButtonWithTitle:@"添加"];
    
    [self setupHostList];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GJCFSystemScreenWidth, GJCFSystemScreenHeight - self.contentOriginY) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - tableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.hostList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *item = [self.hostList objectAtIndex:indexPath.row];
    cell.textLabel.text = item[GJGCWebHostCacheName];
    cell.detailTextLabel.text = item[GJGCWebHostCacheUrl];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.hostList objectAtIndex:indexPath.row];

    GJGCWebViewController *webVC = [[GJGCWebViewController alloc]initWithUrl:item[GJGCWebHostCacheUrl]];
    [self.navigationController pushViewController:webVC animated:YES];    
}

- (void)rightButtonPressed:(UIButton *)sender
{
    UIAlertView *inputAlert = [[UIAlertView alloc]initWithTitle:@"添加网址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    inputAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [inputAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        [self addHost:textField.text];
    }
}

- (void)addHost:(NSString *)host
{
    if (GJCFStringIsNull(host)) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        @autoreleasepool {
            
            NSURL *hostUrl = [NSURL URLWithString:host];
            
            UIWebView *webView = [[UIWebView alloc]init];
            [webView loadRequest:[NSURLRequest requestWithURL:hostUrl]];
            
            NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            
            NSDictionary *item = @{
                                   GJGCWebHostCacheName:title,
                                   GJGCWebHostCacheUrl:host,
                                   };
            
            NSString *cachePath = GJCFAppCachePath(GJGCWebHostListFile);
            
            NSMutableArray *cacheArray = nil;
            if (!GJCFFileIsExist(cachePath)) {
                
                cacheArray = [NSMutableArray array];
                
            }else{
                
                NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
                
                cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
            }
            
            [cacheArray addObject:item];
            
            NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:cacheArray];
            
            [cacheData writeToFile:cachePath atomically:YES];

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self setupHostList];
            
            [self.tableView reloadData];
            
        });
    });
    
}

- (NSArray *)cacheHostList
{
    NSString *cachePath = GJCFAppCachePath(GJGCWebHostListFile);

    NSMutableArray *cacheArray = nil;
    if (!GJCFFileIsExist(cachePath)) {
        
        cacheArray = [NSMutableArray array];
        
    }else{
        
        NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
        
        cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
    }

    return cacheArray;
}

- (void)setupHostList
{
    if (self.hostList.count > 0) {
        [self.hostList removeAllObjects];
    }
    self.hostList = [[NSMutableArray alloc]initWithArray:[self cacheHostList]];
}


@end
