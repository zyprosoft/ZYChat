//
//  GJGCContactsSectionModel.h
//  ZYChat
//
//  Created by ZYVincent on 16/8/9.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJGCContactsSectionModel : NSObject

@property (nonatomic,strong)NSMutableArray *rowData;

@property (nonatomic,assign)BOOL isExpand;

@property (nonatomic,readonly)NSInteger showCount;

@property (nonatomic,strong)NSString *sectionTitle;

@property (nonatomic,readonly)NSString *countString;

@end
