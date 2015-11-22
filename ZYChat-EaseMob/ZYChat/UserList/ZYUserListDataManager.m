//
//  ZYUserListDataManager.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYUserListDataManager.h"
#import "ZYFriendServiceManager.h"

@interface ZYUserListDataManager ()

@property (nonatomic,strong)NSMutableArray *sourceArray;


@end

@implementation ZYUserListDataManager

- (instancetype)init

{
    if (self = [super init]) {
        
        self.sourceArray = [[NSMutableArray alloc]init];
    
        [GJCFNotificationCenter addObserver:self selector:@selector(observeLoginSuccess:) name:ZYUserCenterLoginSuccessNoti object:nil];
    }
    return self;
}

- (void)dealloc
{
    [GJCFNotificationCenter removeObserver:self];
}

- (NSInteger)totalCount
{
    return self.sourceArray.count;
}

- (ZYUserListContentModel *)contentModelAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.sourceArray objectAtIndex:indexPath.row];
}

- (void)observeLoginSuccess:(NSNotification *)noti
{
    [self requestUserList];
}

- (void)requestUserList
{
    ZYFriendServiceManager *friendManager = [[ZYFriendServiceManager alloc]init];
    [friendManager allUsrListWithSuccess:^(NSArray *modelArray) {
        
        for (ZYUserModel *aUser in modelArray) {
            
            ZYUserListContentModel *contentModel = [[ZYUserListContentModel alloc]init];
            contentModel.userId = aUser.userId;
            contentModel.nickname = aUser.nickname;
            contentModel.headThumb = aUser.headThumb;
            contentModel.mobile = aUser.mobile;
            
            [self.sourceArray addObject:contentModel];
        }
        
        //存数据库
        [[ZYChatDatabaseManager shareManager].userDatabase insertUsers:modelArray];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dataManagerRequireRefresh:)]) {
            
            [self.delegate dataManagerRequireRefresh:self];
        }
        
    } withFaild:^(NSError *error) {
        
    }];
}


@end
