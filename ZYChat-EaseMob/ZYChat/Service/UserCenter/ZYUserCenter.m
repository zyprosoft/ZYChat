//
//  ZYUserCenter.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYUserCenter.h"
#import "ZYFriendServiceManager.h"
#import "EaseMob.h"
#import "ZYDatabaseManager.h"

#define kZYUserCenterLoginUserDir     @"LoginUserDir"
#define kZYUserCenterLastLoginUserUDF @"kZYUserCenterLastLoginUserUDF"

@interface ZYUserCenter ()

@property (nonatomic,strong)ZYUserModel *innerLoginUser;

@property (nonatomic,strong)GJGCMessageExtendUserModel *innerExtendUserInfo;

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
        
        [self readLastLoginUser];
    }
    return self;
}

- (void)LoginUserWithMobile:(NSString *)mobile withPassword:(NSString *)password withSuccess:(ZYUserCenterRequestSuccessBlock)success withFaild:(ZYUserCenterRequestFaildBlock)faild
{
    [self loginEaseMobWithMobile:mobile password:password];
}


- (ZYUserModel *)currentLoginUser
{
    return self.innerLoginUser;
}

- (BOOL)isLogin
{
    return self.innerLoginUser? YES:NO;
}

- (NSString *)userSavePath:(NSString *)userId
{
    NSString *cacheDir = GJCFAppCachePath(kZYUserCenterLoginUserDir);
    if (!GJCFFileDirectoryIsExist(cacheDir)) {
        GJCFFileDirectoryCreate(cacheDir);
    }
    
    return [cacheDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.md5",userId]];
}

- (void)saveUserPassword:(NSString *)userId password:(NSString *)password
{
    NSString *passKey = [NSString stringWithFormat:@"%@_kZYUserCenterLastLoginUserPassUDF",userId];

    GJCFUDFCache(passKey, password);
}

- (NSString *)getUserPassword:(NSString *)userId
{
    NSString *passKey = [NSString stringWithFormat:@"%@_kZYUserCenterLastLoginUserPassUDF",userId];

    return GJCFUDFGetValue(passKey);
}

- (NSString *)getLastUserPassword
{
    return [self getUserPassword:self.innerLoginUser.mobile];
}

- (void)updateNickname:(NSString *)nickname
{
    if (GJCFStringIsNull(nickname)) {
        return;
    }
    
    self.innerLoginUser.nickname = nickname;
    
    [self saveCurrentLoginUser];
}

- (void)saveCurrentLoginUser
{
    if (!self.innerLoginUser) {
        return;
    }
    [self setupUserExtendInfo];
    
    NSDictionary *userInfo = [self.innerLoginUser toDictionary];
    
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];

    [userData writeToFile:[self userSavePath:self.innerLoginUser.userId] atomically:YES];
    
    GJCFUDFCache(kZYUserCenterLastLoginUserUDF, self.innerLoginUser.userId);
}

- (void)readLastLoginUser
{
    NSString *userId = GJCFUDFGetValue(kZYUserCenterLastLoginUserUDF);
    
    if (GJCFStringIsNull(userId)) {
        return;
    }
    
    NSData *userData = [NSData dataWithContentsOfFile:[self userSavePath:userId]];
    
    NSDictionary *userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    self.innerLoginUser = [[ZYUserModel alloc]initWithDictionary:userInfo error:nil];
    [self setupUserExtendInfo];
}

- (void)autoLogin
{
    if (!self.innerLoginUser) {
        return;
    }
    
    NSString *password = [self getUserPassword:self.innerLoginUser.userId];
    [self loginEaseMobWithMobile:self.innerLoginUser.mobile password:password];
}

- (void)setupUserExtendInfo
{
    self.innerExtendUserInfo = [[GJGCMessageExtendUserModel alloc]init];
    self.innerExtendUserInfo.nickName = self.innerLoginUser.nickname;
    self.innerExtendUserInfo.sex = self.innerLoginUser.sex;
    self.innerExtendUserInfo.headThumb = self.innerLoginUser.headThumb;
    self.innerExtendUserInfo.userName = self.innerLoginUser.name;
}

- (GJGCMessageExtendUserModel *)extendUserInfo
{
    return self.innerExtendUserInfo;
}

- (void)loginEaseMobWithMobile:(NSString *)mobile password:(NSString *)password
{
    GJCFNotificationPostObj(ZYUserCenterLoginEaseMobSuccessNoti,@{@"state":@(2)});
   
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:mobile password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        
        if (!error) {
        GJCFNotificationPostObj(ZYUserCenterLoginEaseMobSuccessNoti,@{@"state":@(1)});
            
            NSLog(@"loginUser:%@",loginInfo);
            
            if (!self.innerLoginUser) {
                self.innerLoginUser = [[ZYUserModel alloc]init];
                self.innerLoginUser.name = mobile;
                self.innerLoginUser.nickname = @"至尊宝001";
                self.innerLoginUser.headThumb = @"http://att.zhibo8.cc/attachments/1207131906d0b25442e9681c72.jpg";
                self.innerLoginUser.sex = @"0";
            }
            self.innerLoginUser.userId = [loginInfo objectForKey:@"username"];
            self.innerLoginUser.mobile = self.innerLoginUser.userId;
            
            [self saveUserPassword:mobile password:password];
            [self saveCurrentLoginUser];
            
            NSLog(@"登录环信成功");
            
//            [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
//                
//                for (EMGroup *group in groups) {
//                    
//                    [[EaseMob sharedInstance].chatManager asyncDestroyGroup:group.groupId];
//                    
//                }
//                
//            } onQueue:nil];
            
        }else{
            
            NSLog(@"登录环信失败");
        GJCFNotificationPostObj(ZYUserCenterLoginEaseMobSuccessNoti,@{@"state":@(0)});

        }
        
    } onQueue:nil];
}

@end
