//
//  GJGCRecentChatViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCRecentChatViewController.h"
#import "GJGCRecentChatCell.h"
#import "GJGCChatFriendViewController.h"
#import "GJGCChatGroupViewController.h"

@interface GJGCRecentChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *sourceArray;

@property (nonatomic,strong)UITableView *listTable;

@end

@implementation GJGCRecentChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStrNavTitle:@"最近会话"];
    
    self.sourceArray = [[NSMutableArray alloc]init];
    
    self.listTable = [[UITableView alloc]init];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    self.listTable.frame = self.view.bounds;
    [self.view addSubview:self.listTable];
    
    [self initData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    GJGCRecentChatCell *recentCell = (GJGCRecentChatCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!recentCell) {
        
        recentCell = [[GJGCRecentChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [recentCell setContentModel:self.sourceArray[indexPath.row]];
    
    return recentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GJGCRecentChatModel *contenModel = [self.sourceArray objectAtIndex:indexPath.row];
    
    if (contenModel.isGroupChat) {
        
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypeGroup;
        talk.toId = contenModel.toId;
        talk.toUserName = contenModel.name.string;
        
        GJGCChatGroupViewController *groupChat = [[GJGCChatGroupViewController alloc]initWithTalkInfo:talk];
        
        [self.navigationController pushViewController:groupChat animated:YES];
        
        return;
    }
    
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    talk.toId = contenModel.toId;
    talk.toUserName = contenModel.name.string;

    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];

    [self.navigationController pushViewController:privateChat animated:YES];
    
}

#pragma mark - 数据

- (void)initData
{
    GJGCRecentChatModel *contact0 = [[GJGCRecentChatModel alloc]init];
    contact0.name = [GJGCRecentChatModel formateName:@"范冰冰"];
    contact0.headUrl = @"http://a4.att.hudong.com/86/42/300000876508131216423466864_950.jpg";
    contact0.content = [GJGCRecentChatModel formateContent:@"我想和你吃个饭，一起看星星"];
    contact0.time = [GJGCRecentChatModel formateTime:@"10分钟前"];
    contact0.toId = @"10";
    
    GJGCRecentChatModel *contact1 = [[GJGCRecentChatModel alloc]init];
    contact1.name = [GJGCRecentChatModel formateName:@"刘德华"];
    contact1.headUrl = @"http://images.china.cn/attachement/jpg/site1000/20090613/0019b91ec7fd0b9d4eb80a.jpg";
    contact1.content = [GJGCRecentChatModel formateContent:@"和我合作拍部电影怎么样?"];
    contact1.time = [GJGCRecentChatModel formateTime:@"20分钟前"];
    contact1.toId = @"11";

    GJGCRecentChatModel *contact2 = [[GJGCRecentChatModel alloc]init];
    contact2.name = [GJGCRecentChatModel formateName:@"汤姆克鲁斯"];
    contact2.headUrl = @"http://enjoy.eastday.com/images/thumbnailimg/month_1503/201503120329207667.jpg";
    contact2.content = [GJGCRecentChatModel formateContent:@"邀请你和我一起走红毯"];
    contact2.time = [GJGCRecentChatModel formateTime:@"34分钟前"];
    contact2.toId = @"12";

    GJGCRecentChatModel *contact3 = [[GJGCRecentChatModel alloc]init];
    contact3.name = [GJGCRecentChatModel formateName:@"布拉德皮特"];
    contact3.headUrl = @"http://images.china.cn/attachement/jpg/site1000/20120510/001ec949ffcb1115977c54.jpg";
    contact3.content = [GJGCRecentChatModel formateContent:@"我有很多慈善梦想"];
    contact3.time = [GJGCRecentChatModel formateTime:@"40分钟前"];
    contact3.toId = @"13";

    GJGCRecentChatModel *contact4 = [[GJGCRecentChatModel alloc]init];
    contact4.name = [GJGCRecentChatModel formateName:@"卡蕾.措科"];
    contact4.headUrl = @"http://img5.duitang.com/uploads/item/201402/28/20140228164953_nZRUG.thumb.700_0.jpeg";
    contact4.content = [GJGCRecentChatModel formateContent:@"你是我的粉丝吗，太高兴了"];
    contact4.time = [GJGCRecentChatModel formateTime:@"55分钟前"];
    contact4.toId = @"14";

    GJGCRecentChatModel *contact5 = [[GJGCRecentChatModel alloc]init];
    contact5.name = [GJGCRecentChatModel formateName:@"生活大爆炸粉丝群"];
    contact5.headUrl = @"http://a1.att.hudong.com/62/00/300001377839131692008048933_950.jpg";
    contact5.content = [GJGCRecentChatModel formateContent:@"莱纳德:我不是科学界的呆子!"];
    contact5.time = [GJGCRecentChatModel formateTime:@"60分钟前"];
    contact5.toId = @"15";
    contact5.isGroupChat = YES;
    
    [self.sourceArray addObject:contact0];
    [self.sourceArray addObject:contact1];
    [self.sourceArray addObject:contact2];
    [self.sourceArray addObject:contact3];
    [self.sourceArray addObject:contact4];
    [self.sourceArray addObject:contact5];

    [self.listTable reloadData];
    
}

@end
