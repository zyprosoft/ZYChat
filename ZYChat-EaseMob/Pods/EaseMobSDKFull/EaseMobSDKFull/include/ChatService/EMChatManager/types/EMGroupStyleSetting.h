/*!
 @header EMGroupStyleSetting.h
 @abstract 群组参数设置（用于创建群组）
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

/*!
 @enum
 @brief 群组类型
 @constant eGroupStyle_PrivateOnlyOwnerInvite 私有群组，只能owner权限的人邀请人加入
 @constant eGroupStyle_PrivateMemberCanInvite 私有群组，owner和member权限的人可以邀请人加入
 @constant eGroupStyle_PublicJoinNeedApproval 公开群组，允许非群组成员申请加入，需要管理员同意才能真正加入该群组
 @constant eGroupStyle_PublicOpenJoin         公开群组，允许非群组成员加入，不需要管理员同意
 @constant eGroupStyle_PublicAnonymous        公开匿名群组，允许非群组成员加入，不需要管理员同意
 @constant eGroupStyle_Default                默认群组类型
 @discussion
        eGroupStyle_Private：私有群组，只允许群组成员邀请人进入
        eGroupStyle_Public： 公有群组，允许非群组成员加入
 */
typedef NS_ENUM(NSInteger, EMGroupStyle){
    eGroupStyle_PrivateOnlyOwnerInvite = 0, 
    eGroupStyle_PrivateMemberCanInvite,
    eGroupStyle_PublicJoinNeedApproval,
    eGroupStyle_PublicOpenJoin,
    eGroupStyle_PublicAnonymous,
    eGroupStyle_Default = eGroupStyle_PrivateOnlyOwnerInvite,
};

#define KSDK_GROUP_MINUSERSCOUNT 3
#define KSDK_GROUP_MAXUSERSCOUNT 500
#define KSDK_GROUP_USERSCOUNTDEFAULT 200

/*!
 @class
 @brief 群组参数设置类
 */
@interface EMGroupStyleSetting : NSObject

/*!
 @property
 @brief 群组的类型
 */
@property (nonatomic) EMGroupStyle groupStyle;

/*!
 @property
 @brief 群组的最大成员数(3 - 2000，ios默认是200)
 */
@property (nonatomic) NSInteger groupMaxUsersCount;

@end
