//
//  GJGCGroupShowItem.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCCommonHeadView.h"
@interface GJGCInformationGroupShowItemModel : NSObject

@property (nonatomic,strong)NSAttributedString *name;

@property (nonatomic,strong)NSString *headUrl;

@property (nonatomic,assign)long long groupId;

@end

@interface GJGCInformationGroupShowItem : UIButton

@property (nonatomic,strong)GJGCCommonHeadView *headView;

@property (nonatomic,strong)GJCFCoreTextContentView *nameLabel;

@property (nonatomic,strong)UIImageView *seprateLine;

@property (nonatomic,assign)BOOL showBottomSeprateLine;

- (void)setGroupItem:(GJGCInformationGroupShowItemModel *)contentModel;

@end
