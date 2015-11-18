//
//  GJCFImageBrowserItemViewController.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-30.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCUImageBrowserItemViewController.h"
#import "GJCUImageBrowserScrollView.h"
#import "GJCFUitils.h"

@interface GJCUImageBrowserItemViewController ()

@end

@implementation GJCUImageBrowserItemViewController

+ (instancetype)itemViewForPageIndex:(NSInteger)index
{
    return [[self alloc]initWithPageIndex:index];
}

- (id)initWithPageIndex:(NSInteger)index
{
    if (self = [super init]) {
        
        self.pageIndex = index;
    }
    return self;
}

- (void)loadView
{
    GJCUImageBrowserScrollView *scrollView = [[GJCUImageBrowserScrollView alloc]initWithFrame:GJCFSystemScreenBounds];
    scrollView.dataSource = self.dataSource;
    scrollView.index = self.pageIndex;
    
    self.view = scrollView;
}

- (UIImage *)currentDisplayImage
{
    GJCUImageBrowserScrollView *currentScrollView = (GJCUImageBrowserScrollView *)self.view;
    
    return currentScrollView.contentImageView.image;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
