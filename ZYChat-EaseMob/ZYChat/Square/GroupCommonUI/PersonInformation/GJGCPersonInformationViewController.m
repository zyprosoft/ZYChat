//
//  GJGCPersonInformationViewController.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/22.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCPersonInformationViewController.h"

@interface GJGCPersonInformationViewController ()

@property (nonatomic,strong)GJGCMessageExtendUserModel *theUser;

@end

@implementation GJGCPersonInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithExtendUser:(GJGCMessageExtendUserModel *)aUser
{
    if (self = [super init]) {
        
        self.theUser = aUser;
        
    }
    return self;
}

- (void)setupUserInfoList
{
    
}

@end
