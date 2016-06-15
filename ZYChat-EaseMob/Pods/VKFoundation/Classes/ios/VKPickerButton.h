//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

@interface VKPickerButton : UIButton <
  UITableViewDataSource,
  UITableViewDelegate
>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* items;

@property (nonatomic, strong) UIView* pickerView;
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) UIView* overlay;

@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, copy) void (^formatCellBlock)(UITableViewCell* cell, id item);
@property (nonatomic, copy) void (^didSelectItemBlock)(id item);
@property (nonatomic, copy) void (^didDismissBlock)(void);
@property (nonatomic, copy) BOOL (^isSelectedBlock)(id item);

- (void)presentFromViewController:(UIViewController*)viewController title:(NSString*)title items:(NSArray*)items formatCellBlock:(void(^)(UITableViewCell* cell, id item))formatCellBlock isSelectedBlock:(BOOL (^)(id item))isSelectedBlock didSelectItemBlock:(void(^)(id item))didSelectItemBlock didDismissBlock:(void(^)(void))didDissmissBlock;
- (void)dismiss;

@end
