//
//  HARegistViewController.m
//  HelloAsk
//
//  Created by ZYVincent on 15-9-4.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "HARegistViewController.h"
#import "HARegistInputTextCell.h"

@interface HARegistViewController ()<UITableViewDataSource,UITableViewDelegate,HARegistInputTextCellDelegate>

@property (nonatomic,strong)UITableView *listTable;

@property (nonatomic,strong)NSMutableArray *sourceArray;

@end

@implementation HARegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setHidden:NO];
    [self setStrNavTitle:@"注册新用户"];
    [self setRightButtonWithTitle:@"发送"];
    
    self.view.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    
    self.sourceArray = [[NSMutableArray alloc]init];
    
    HARegistContentModel *nameItem = [[HARegistContentModel alloc]init];
    nameItem.tagName = @"账   号";
    nameItem.placeHolder = @"请输入用于登录的唯一用户名，可以是汉字";
    nameItem.contentType = HARegistContentTypeUserName;
    nameItem.contentHeight = 64.f;
    
    [self.sourceArray addObject:nameItem];
    
    HARegistContentModel *passwordItem = [[HARegistContentModel alloc]init];
    passwordItem.tagName = @"密   码";
    passwordItem.placeHolder = @"请输入用于登录的密码";
    passwordItem.contentType = HARegistContentTypePassword;
    passwordItem.contentHeight = 64.f;
    
    [self.sourceArray addObject:passwordItem];
    
    self.listTable = [[UITableView alloc]init];
    self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTable.gjcf_height = GJCFSystemScreenHeight - 20;
    self.listTable.gjcf_top = 20;
    self.listTable.gjcf_width = GJCFSystemScreenWidth;
    self.listTable.backgroundColor = [GJGCCommonFontColorStyle mainBackgroundColor];
    self.listTable.dataSource = self;
    self.listTable.delegate = self;
    [self.view addSubview:self.listTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    HARegistInputTextCell *cell = (HARegistInputTextCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[HARegistInputTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    [cell setContentModel:[self.sourceArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HARegistContentModel *contentModel = [self.sourceArray objectAtIndex:indexPath.row];
    
    return contentModel.contentHeight;
}

- (void)inputCell:(HARegistInputTextCell *)inputCell didUpdateContent:(NSString *)content
{
    NSIndexPath *indexPath = [self.listTable indexPathForCell:inputCell];
    
    HARegistContentModel *contentModel = [self.sourceArray objectAtIndex:indexPath.row];
    contentModel.content = content;
    
    [self.sourceArray replaceObjectAtIndex:indexPath.row withObject:contentModel];
    
}

- (void)rightButtonPressed:(UIButton *)sender
{
    HARegistContentModel *userNameItem = [self.sourceArray firstObject];
    
    if (GJCFStringIsNull(userNameItem.content)) {
        [self showErrorMessage:@"登陆手机号不为空"];
        return;
    }
    
    HARegistContentModel *passwordItem = [self.sourceArray objectAtIndex:1];
    
    if (GJCFStringIsNull(passwordItem.content)) {
        [self showErrorMessage:@"密码不为空"];
        return;
    }
    
    [self.statusHUD showWithStatusText:@"正在注册..."];
    
    GJCFWeakSelf weakSelf = self;
    [[EMClient sharedClient] asyncRegisterWithUsername:userNameItem.content password:passwordItem.content success:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.statusHUD dismiss];

            [weakSelf.navigationController popViewControllerAnimated:YES];

        });
        
        BTToast(@"注册成功");

        
    } failure:^(EMError *aError) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.statusHUD dismiss];
            
            [weakSelf showErrorMessage:aError.errorDescription];

        });
        
    }];
}

@end
