//
//  GJGCMusicSearchResultListDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/25.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCMusicSearchResultListDataManager.h"
#import "ZYDataCenter.h"

@implementation GJGCMusicSearchResultListDataManager

- (void)requestContentList
{
    
    ZYDataCenterRequestCondition *condition = [[ZYDataCenterRequestCondition alloc]init];
    condition.thirdServerHost = @"http://music.163.com";
    condition.thirdServerInterface = @"/api/search/get";
    condition.requestMethod = ZYNetworkRequestMethodPOST;
    condition.postParams = @{
                             @"s":self.keyword,
                             @"offset":@"0",
                             @"limit":@"30",
                             @"sub":@"false",
                             @"type":@"1",
                             };
    condition.headerValues = @{
                               @"Referer":@"http://music.163.com",
                               };
    condition.isThirdPartRequest = YES;
    
    [[ZYDataCenter shareCenter]thirdServerRequestWithCondition:condition withSuccessBlock:^(ZYNetWorkTask *task, NSDictionary *response) {
       
        NSArray *songs = [response[@"result"] objectForKey:@"songs"];
        
        NSMutableArray *songList = [NSMutableArray array];
        
        for (NSInteger index = 0; index < songs.count; index++) {
            
            NSDictionary *song = [songs objectAtIndex:index];
            
            NSDictionary *artist = [song[@"artists"]firstObject];
            
            NSString *authorName = artist[@"name"];
            NSString *songName = song[@"name"];
            NSInteger timeDuration = [song[@"duration"] longLongValue]/1000/60;
            
            NSString *duration = [NSString stringWithFormat:@"%ld",(long)timeDuration];
            
            NSString *simpleTitle = [NSString stringWithFormat:@"歌曲:%@    歌手:%@   时长: %@ 分钟",songName,authorName,duration];
            
            [songList addObject:song[@"id"]];
            
            BTActionSheetBaseContentModel *itemModel = [[BTActionSheetBaseContentModel alloc]init];
            itemModel.simpleText = simpleTitle;
            itemModel.userInfo = @{
                                   @"data":song[@"id"],
                                   @"name":songName,
                                   @"list":songList,
                                   @"index":@(index),
                                   };
            
            [self addContentModel:itemModel];
            
        }
        
        [self.delegate dataManagerRequireRefresh:self];
        
    } withFaildBlock:^(ZYNetWorkTask *task, NSError *error) {
        
        BTToast(@"未搜索到歌曲");
        
    }];
}

@end
