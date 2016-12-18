//
//  ZYUserCenter.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/6.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "ZYUserCenter.h"
#import "ZYFriendServiceManager.h"
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
    [self loginEaseMobWithMobile:mobile password:password withSuccess:success withFaild:faild];
}

- (void)LogoutWithSuccess:(ZYUserCenterRequestSuccessBlock)success
               withFaild:(ZYUserCenterRequestFaildBlock)faild
{
    [[EMClient sharedClient] asyncLogout:NO success:^{
        
        self.innerLoginUser = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BTToast(@"退出环信成功");
            
            if (success) {
                success(@"退出环信成功");
            }
        });
        
    } failure:^(EMError *aError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"退出环信失败");
            
            if (faild) {
                faild([NSError errorWithDomain:@"com.zychat.error" code:-1999 userInfo:@{@"errMsg":@"退出环信失败"}]);
            }
            
        });
        
        
        
    }];
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

- (void)updateAvatar:(NSString *)imageUrl
{
    if (GJCFStringIsNull(imageUrl)) {
        return;
    }
    
    self.innerLoginUser.headThumb = imageUrl;
    
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
    [self loginEaseMobWithMobile:self.innerLoginUser.mobile password:password withSuccess:nil withFaild:nil];
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

- (void)loginEaseMobWithMobile:(NSString *)mobile password:(NSString *)password withSuccess:(ZYUserCenterRequestSuccessBlock)success withFaild:(ZYUserCenterRequestFaildBlock)faild
{
    GJCFNotificationPostObj(ZYUserCenterLoginEaseMobSuccessNoti,@{@"state":@(2)});
   
    [[EMClient sharedClient] asyncLoginWithUsername:mobile password:password success:^{
      
        dispatch_async(dispatch_get_main_queue(), ^{
            
            GJCFNotificationPostObj(ZYUserCenterLoginEaseMobSuccessNoti,@{@"state":@(1)});

        });
        
        if (!self.innerLoginUser) {
            self.innerLoginUser = [[ZYUserModel alloc]init];
            self.innerLoginUser.name = mobile;
            NSString *timeString = GJCFStringCurrentTimeStamp;
            self.innerLoginUser.nickname = [NSString stringWithFormat:@"剑仙李白-%@",[timeString substringFromIndex:timeString.length-4]];
            self.innerLoginUser.headThumb = @"http://imgsrc.baidu.com/forum/pic/item/9d82d158ccbf6c81f34d2e53bc3eb13533fa4016.jpg";
            self.innerLoginUser.sex = @"0";
        }
        self.innerLoginUser.userId = mobile;
        self.innerLoginUser.mobile = self.innerLoginUser.userId;
        
        [self saveUserPassword:mobile password:password];
        [self saveCurrentLoginUser];
        
        NSLog(@"登录环信成功");
        
        if (success) {
            success(@"登录环信成功");
        }
        
    } failure:^(EMError *aError) {
        
        NSLog(@"登录环信失败");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            GJCFNotificationPostObj(ZYUserCenterLoginEaseMobSuccessNoti,@{@"state":@(0)});
            
        });
        
        if (faild) {
            faild([NSError errorWithDomain:@"com.zychat.error" code:-1999 userInfo:@{@"errMsg":@"登录环信失败"}]);
        }
        
    }];
}

@end
