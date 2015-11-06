//
//  ZYUserCenter.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "ZYUserCenter.h"
#import "ZYFriendServiceManager.h"

@interface ZYUserCenter ()

@property (nonatomic,strong)ZYUserModel *innerLoginUser;

@end

@implementation ZYUserCenter

+ (ZYUserCenter *)shareCenter
{
    static ZYUserCenter *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!_instance) {
            _instance = [[self alloc]init];
        }
    });
    
    return _instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self autoLogin];
    }
    return self;
}

- (void)autoLogin
{
    ZYFriendServiceManager *friendManager = [[ZYFriendServiceManager alloc]init];
    ZYUserModel *aUser = [[ZYUserModel alloc]init];
    aUser.mobile = @"13810551555";
    aUser.address = @"test address";
    
    [friendManager registUser:aUser withSuccess:^(ZYUserModel *resultUser) {
        
        self.innerLoginUser = resultUser;
        
    } withFaild:^(NSError *error) {
        
    }];
    
}

- (ZYUserModel *)currentLoginUser
{
    return self.innerLoginUser;
}

@end
