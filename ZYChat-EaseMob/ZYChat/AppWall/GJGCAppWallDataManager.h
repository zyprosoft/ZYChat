//
//  GJGCAppWallDataManager.h
//  ZYChat
//
//  Created by ZYVincent on 15/11/26.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCInfoBaseListDataManager.h"
#import "GJGCAppWallParamsModel.h"

@interface GJGCAppWallDataManager : GJGCInfoBaseListDataManager

@property (nonatomic,strong)GJGCAppWallParamsModel *paramsModel;
@property (nonatomic,assign)BOOL isFirstLoadingFinish;

- (void)requestAppListNow;

@end
