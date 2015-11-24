//
//  GJGCWebHostListViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/24.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCWebHostListViewController.h"
#import "GDataXMLNode.h"

#define GJGCWebHostListFile @"GJGCWebHostListFile"


@interface GJGCWebHostListViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *hostList;

@end

@implementation GJGCWebHostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setStrNavTitle:@"经常访问的网站"];
    
    [self setRightButtonWithTitle:@"添加"];
    
    [self setupHostList];
    
    
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
        
    }
    
    return cell;
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
    
    NSURL *hostUrl = [NSURL URLWithString:host];
    
    NSData *hostData = [NSData dataWithContentsOfURL:hostUrl];
    
    NSString *htmlString = [[NSString alloc]initWithData:hostData encoding:NSUTF8StringEncoding];
    
    GDataXMLDocument *html = [[GDataXMLDocument alloc]initWithHTMLString:htmlString encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"html :%@",html);
    
    NSString *cachePath = GJCFAppCachePath(GJGCWebHostListFile);
    
    NSMutableArray *cacheArray = nil;
    if (!GJCFFileIsExist(cachePath)) {
        
        cacheArray = [NSMutableArray array];
        
    }else{
        
        NSData *cacheData = [NSData dataWithContentsOfFile:cachePath];
        
        cacheArray = [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
    }
    
    [cacheArray addObject:host];
    
    NSData *cacheData = [NSKeyedArchiver archivedDataWithRootObject:cacheArray];
    
    [cacheData writeToFile:cachePath atomically:YES];
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
    self.hostList = [[NSMutableArray alloc]initWithArray:[self cacheHostList]];
}


@end
