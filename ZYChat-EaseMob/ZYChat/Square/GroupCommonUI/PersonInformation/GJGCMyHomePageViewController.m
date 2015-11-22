//
//  GJGCMyHomePageViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/22.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCMyHomePageViewController.h"
#import "GJGCGroupInfoExtendModel.h"
#import "Base64.h"
#import "GJGCGroupPersonInformationShowMap.h"
#import "GJGCChatGroupViewController.h"

@interface GJGCMyHomePageViewController ()

@end

@implementation GJGCMyHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupMyInformation];
}

- (void)setupMyInformation
{
    ZYUserModel *currentLoginUser = [[ZYUserCenter shareCenter]currentLoginUser];
    
    //展示群头像信息
    GJGCInformationCellContentModel *contentModel = [[GJGCInformationCellContentModel alloc]init];
    contentModel.baseContentType = GJGCInformationContentTypeGroupHeadInfo;
    contentModel.groupHeadUrl = currentLoginUser.headThumb;
    contentModel.groupName = currentLoginUser.nickname;
    contentModel.contentHeight = 164.f;
    
    [self.dataSourceManager addInformationItem:contentModel];
    
    /* 群账号 */
    if (currentLoginUser.userId) {
        
        GJGCInformationCellContentModel *accountItem = [GJGCGroupPersonInformationShowMap itemWithContentValueBaseText:currentLoginUser.userId tagName:@"账  号"];
        accountItem.topLineMargin = 13.f;
        accountItem.seprateStyle = GJGCInformationSeprateLineStyleTopFullBottomShort;
        
        [self.dataSourceManager addInformationItem:accountItem];
    }
    
    /* 群等级 */
    GJGCInformationCellContentModel *levelItem = nil;
    levelItem = [GJGCGroupPersonInformationShowMap itemWithLevelValue:@"新手小白" tagName:@"等  级"];
    [self.dataSourceManager addInformationItem:levelItem];
    
    /* 群位置 */
    if (!GJCFStringIsNull(currentLoginUser.sex)) {
        
        NSString *sex = currentLoginUser.sex == 0? @"男":@"女";
        
        GJGCInformationCellContentModel *locationItem = [GJGCGroupPersonInformationShowMap itemWithTextAndIcon:sex  icon:@"详细地址icon.png" tagName:@"性  别"];
        locationItem.seprateStyle = GJGCInformationSeprateLineStyleTopNoneBottomFull;
        locationItem.isIconShowMap = YES;
        [self.dataSourceManager addInformationItem:locationItem];
    }
    
    [self.informationListTable reloadData];
    
}

@end
