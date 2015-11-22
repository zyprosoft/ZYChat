//
//  BTActionSheetViewController.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/9/2.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCBaseViewController.h"
#import "BTActionSheetDataManager.h"

typedef void (^BTActionSheetViewControllerDidFinishChooseResultBlock) (BTActionSheetBaseContentModel *resultModel);

typedef void (^BTActionSheetViewControllerDidFinishMutilChooseResultBlock) (NSArray *mutilSelectedResults);

typedef void (^BTActionSheetViewControllerDidFinishEmptyDataListCancelBlock) (void);

@interface BTActionSheetViewController : GJGCBaseViewController<BTActionSheetDataManagerDelegate>

@property (nonatomic,copy)BTActionSheetViewControllerDidFinishChooseResultBlock resultBlock;

@property (nonatomic,copy)BTActionSheetViewControllerDidFinishMutilChooseResultBlock mutilChooseResultBlock;

@property (nonatomic,copy)BTActionSheetViewControllerDidFinishEmptyDataListCancelBlock cancelBlock;

@property (nonatomic,strong)BTActionSheetDataManager *dataManager;

@property (nonatomic,strong)UIView *backMaskView;

@property (nonatomic,strong)UITableView *listTable;

@property (nonatomic,strong)UIView *contentView;

@property (nonatomic,strong)UIView *toolBar;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UIButton *cancelButton;

@property (nonatomic,strong)UIButton *doneButton;

@property (nonatomic,assign)CGFloat contentHeight;

@property (nonatomic,assign)BOOL isMutilSelect;

@property (nonatomic,strong)NSArray *selectedItems;

- (void)showFromViewController:(UIViewController *)aViewController;

- (void)initDataManager;

- (void)doneAction;

- (void)cancelAction;

@end
