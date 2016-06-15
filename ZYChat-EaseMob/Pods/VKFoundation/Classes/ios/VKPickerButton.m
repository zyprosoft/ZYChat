//
//  Created by Viki.
//  Copyright (c) 2014 Viki Inc. All rights reserved.
//

#import "VKPickerButton.h"
#import <QuartzCore/QuartzCore.h>
#import "VKFoundation.h"

@implementation VKPickerButton

- (void)presentFromViewController:(UIViewController*)viewController title:(NSString*)title items:(NSArray*)items formatCellBlock:(void(^)(UITableViewCell* cell, id item))formatCellBlock isSelectedBlock:(BOOL (^)(id item))isSelectedBlock didSelectItemBlock:(void(^)(id item))didSelectItemBlock didDismissBlock:(void(^)(void))didDissmissBlock {
  
  self.formatCellBlock = formatCellBlock;
  self.didSelectItemBlock = didSelectItemBlock;
  self.didDismissBlock = didDissmissBlock;
  self.isSelectedBlock = isSelectedBlock;
  
  self.items = items;
  
  self.pickerView = [[UIView alloc] initWithFrame:CGRectOffset(viewController.view.bounds, 0, 0)];
  self.pickerView.clipsToBounds = YES;
  self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [viewController.view addSubview:self.pickerView];

  self.overlay = [[UIView alloc] initWithFrame:CGRectSetOrigin(self.pickerView.frame, CGPointZero)];
  self.overlay.backgroundColor = THEMECOLOR(@"colorBackground8");
  self.overlay.alpha = 0.0f;
  self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [self.pickerView addSubview:self.overlay];
  
  CGFloat insetValue = 20.0f;
  
  self.containerView = [[UIView alloc] initWithFrame:CGRectInset(CGRectSetOrigin(self.pickerView.frame, CGPointZero), insetValue, insetValue)];
  self.containerView.layer.cornerRadius = 2.0f;
  self.containerView.clipsToBounds = YES;
  self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  [self.pickerView addSubview:self.containerView];
  
  CGFloat navigationBarHeight = 32.0f;
  UINavigationBar* navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), navigationBarHeight)];
  [navigationBar setTitleTextAttributes:@{
    UITextAttributeTextColor: THEMECOLOR(@"colorSection1"),
    UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
    UITextAttributeTextShadowColor: [UIColor darkGrayColor],
    UITextAttributeFont: THEMEFONT(@"fontLight", 20.0f)
  }];
  navigationBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
  UINavigationItem* navigationItem = [[UINavigationItem alloc] initWithTitle:title];
  UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
  __weak __typeof__(self) weakSelf = self;
  [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  [closeButton setImage:[UIImage imageNamed:@"VKPickerButton_cross"] forState:UIControlStateNormal];
  closeButton.frame = CGRectMake(0, 0, navigationBarHeight, navigationBarHeight);
  UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
  [navigationItem setLeftBarButtonItem:barButtonItem];
  [navigationBar pushNavigationItem:navigationItem animated:NO];
  [self.containerView addSubview:navigationBar];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBar.frame), CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame) - CGRectGetMaxY(navigationBar.frame)) style:UITableViewStylePlain];
  self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  self.tableView.backgroundColor = THEMECOLOR(@"colorBackground3");
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView reloadData];
  [self.containerView addSubview:self.tableView];

  UIImageView* shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VKPickerButton_bg"]];
  shadow.frame = CGRectMake(0, navigationBarHeight, CGRectGetWidth(navigationBar.frame), 8.0f);
  shadow.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
  [self.containerView addSubview:shadow];
  
  [self.containerView setFrameOriginY:CGRectGetHeight(self.pickerView.frame)];
  [UIView animateWithDuration:0.3f animations:^{
    [self.containerView setFrameOriginY:insetValue];
    self.overlay.alpha = 0.6f;
  }];
  
  self.isPresented = YES;
}

- (void)dismiss {
  [UIView animateWithDuration:0.3f animations:^{
    [self.containerView setFrameOriginY:CGRectGetHeight(self.pickerView.frame)];
    self.overlay.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    if (self.didDismissBlock) self.didDismissBlock();
    self.isPresented = NO;
  }];
}

#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  NSString* cellId = @"VKPickerButtonCell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    cell.textLabel.font = THEMEFONT(@"fontRegular", 18.0f);
    cell.textLabel.textColor = THEMECOLOR(@"colorFont1");
    cell.detailTextLabel.font = THEMEFONT(@"fontRegular", 18.0f);
    cell.detailTextLabel.textColor = THEMECOLOR(@"colorFont1");
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
  }
  
  //Setup cell
  if (self.formatCellBlock) {
    self.formatCellBlock(cell, self.items[indexPath.row]);
  }
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 32.0f;
}

#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isSelectedBlock && self.isSelectedBlock(self.items[indexPath.row])) {
    cell.backgroundColor = THEMECOLOR(@"colorSection1");
    cell.textLabel.textColor = THEMECOLOR(@"colorFont4");
    cell.detailTextLabel.textColor = THEMECOLOR(@"colorFont4");
  } else {
    cell.backgroundColor = THEMECOLOR(@"colorBackground4");
    cell.textLabel.textColor = THEMECOLOR(@"colorFont1");
    cell.detailTextLabel.textColor = THEMECOLOR(@"colorFont1");
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.didSelectItemBlock) {
    self.didSelectItemBlock(self.items[indexPath.row]);
  }
}


@end
