//
//  BTDateActionSheetViewController.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/9.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "BTActionSheetViewController.h"

@interface BTDateActionSheetViewController : BTActionSheetViewController

@property (nonatomic,strong)NSDate *startDate;

@property (nonatomic,strong)NSDate *endDate;

@property (nonatomic,strong)NSDate *selectedDate;

@end
