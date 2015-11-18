//
//  GJAssetsPickerPreviewItemViewController.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAssetsPickerPreviewItemViewController.h"
#import "GJCFAssetsPickerScrollView.h"

@interface GJCFAssetsPickerPreviewItemViewController ()

@end

@implementation GJCFAssetsPickerPreviewItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    GJCFAssetsPickerScrollView *scrollView = [[GJCFAssetsPickerScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.dataSource = self.dataSource;
    scrollView.index = self.pageIndex;
    
    self.view = scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}



@end
