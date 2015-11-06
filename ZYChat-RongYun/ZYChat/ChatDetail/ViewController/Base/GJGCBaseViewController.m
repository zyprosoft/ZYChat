//
//  UIViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/7/11.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCBaseViewController.h"

#define BUTTONMarginX    10
#define BUTTONMarginUP   0
#define NAVBUTTON_WIDTH  44
#define NAVBUTTON_HEIGHT 44
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define NAVIGATION_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height

@interface GJGCBaseViewController ()

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation GJGCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hidesBottomBarWhenPushed = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    //非根视图默认添加返回按钮
    if ([self.navigationController.viewControllers count] > 0
        && self != [self.navigationController.viewControllers objectAtIndex:0])
    {
        [self setLeftButtonWithImageName:@"title-icon-向左返回" bgImageName:nil];
    }
    [super viewWillAppear:animated];
}



- (void)leftButtonPressed:(UIButton *)sender
{
    
}

- (void)rightButtonPressed:(UIButton *)sender
{
    
}

- (void)setStrNavTitle:(NSString *)title
{
    UIView* navTitleView = (self.navigationItem.titleView);
    
    
    if([navTitleView isKindOfClass:[UILabel class]])//先要判断是否为label
    {
        self.titleLabel = (UILabel*)navTitleView;
        self.titleLabel.text = title;
    }
    else
    {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.text= title;
        self.navigationItem.titleView = _titleLabel;
    }
    
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
}

- (void)setRightButtonWithTitle:(NSString*)title
{
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:20.0] constrainedToSize:CGSizeMake(MAXFLOAT, 44)];
    if (size.width<60) {
        size.width = 60;
    }
    else
    {
        size.width+=6;
    }
    UIButton *tmpRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpRightButton.frame = CGRectMake(self.view.frame.size.width-NAVBUTTON_WIDTH-BUTTONMarginX, BUTTONMarginUP, size.width, 30);
    
    tmpRightButton.showsTouchWhenHighlighted = NO;
    tmpRightButton.exclusiveTouch = YES;//add by ljj 修改push界面问题
    
    [tmpRightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tmpRightButton setTitleColor:GJCFQuickRGBColor(255.f, 255.f, 255.f) forState:UIControlStateNormal];
    [tmpRightButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [tmpRightButton setTitle:title forState:UIControlStateNormal];
    
    [tmpRightButton setTitleColor:GJCFQuickRGBColor(200, 200, 200) forState:UIControlStateDisabled];
    
    [tmpRightButton setTitleColor:GJCFQuickRGBColor(200, 200, 200) forState:UIControlStateHighlighted];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpRightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    if (GJCFSystemIsOver7)//左边button的偏移量，从左移动13个像素
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        [self.navigationItem setRightBarButtonItems:@[negativeSeperator, rightButtonItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:rightButtonItem];
    }
}

//设置导航左边的button的图片名和背景图片名
- (void)setLeftButtonWithImageName:(NSString*)imageName bgImageName:(NSString*)bgImageName
{
    UIButton *tmpLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    tmpLeftButton.frame = CGRectMake(-5, 0, 30, 32);//CGRectMake(0, BUTTONMarginUP, NAVBUTTON_WIDTH, NAVBUTTON_HEIGHT);
    tmpLeftButton.showsTouchWhenHighlighted = NO;
    tmpLeftButton.exclusiveTouch = YES; //add by ljj 修改push界面问题
    
    if (bgImageName)//设置button的背景
    {
        [tmpLeftButton setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    
    [tmpLeftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [tmpLeftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpLeftButton];
    
    if (GJCFSystemIsOver7)//左边button的偏移量，从左移动13个像素
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        [self.navigationItem setLeftBarButtonItems:@[negativeSeperator, leftButtonItem]];
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    }
}


- (void)setRightButtonWithStateImage:(NSString *)iconName stateHighlightedImage:(NSString *)highlightIconName stateDisabledImage:(NSString *)disableIconName titleName:(NSString *)title
{
    UIButton *tmpRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpRightButton.exclusiveTouch = YES;//add by ljj 修改push界面问题
    
    tmpRightButton.frame = CGRectMake(self.view.frame.size.width-NAVBUTTON_WIDTH-BUTTONMarginX, BUTTONMarginUP, NAVBUTTON_WIDTH, NAVBUTTON_HEIGHT);
    if (title) {
        [tmpRightButton setTitle:title forState:UIControlStateNormal];
        [tmpRightButton setTitle:title forState:UIControlStateDisabled];
    }
    tmpRightButton.showsTouchWhenHighlighted = NO;
    [tmpRightButton setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [tmpRightButton setImage:[UIImage imageNamed:highlightIconName] forState:UIControlStateHighlighted];
    [tmpRightButton setImage:[UIImage imageNamed:disableIconName] forState:UIControlStateDisabled];
    
    [tmpRightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tmpRightButton];
    
    if (GJCFSystemIsOver7)//左边button的偏移量，从左移动13个像素
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        [self.navigationItem setRightBarButtonItems:@[negativeSeperator, rightButtonItem]];
    }
    else
    {
        [self.navigationItem setRightBarButtonItem:rightButtonItem];
    }
}

/**
 *  在右边的项目中添加新的icon
 *
 *  @param button
 *  @param state
 */
- (void)appendRightBarItemWithCustomButton:(UIButton *)button toOldLeft:(BOOL)state
{
    NSMutableArray *oldRightBarItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    
    UIBarButtonItem *rightNewItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    if (state) {
        
        [oldRightBarItems addObject:rightNewItem];
        
        self.navigationItem.rightBarButtonItems = oldRightBarItems;
        
        return;
    }
    
    [oldRightBarItems insertObject:rightNewItem atIndex:0];
    
    self.navigationItem.rightBarButtonItems = oldRightBarItems;
}

@end
