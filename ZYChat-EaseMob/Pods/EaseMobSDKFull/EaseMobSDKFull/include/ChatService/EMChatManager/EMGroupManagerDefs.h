/*!
 @header EMGroupManagerDefs.h
 @abstract GroupManager相关宏定义
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#ifndef EaseMobClientSDK_EMGroupManagerDefs_h
#define EaseMobClientSDK_EMGroupManagerDefs_h

/*!
 @enum
 @brief 退出群组的原因
 @constant eGroupLeaveReason_BeRemoved 被管理员移除出该群组
 @constant eGroupLeaveReason_UserLeave 用户主动退出该群组
 @constant eGroupLeaveReason_Destroyed 该群组被别人销毁
 */
typedef NS_ENUM(NSInteger, EMGroupLeaveReason) {
    eGroupLeaveReason_BeRemoved = 1,
    eGroupLeaveReason_UserLeave,
    eGroupLeaveReason_Destroyed
};

/*!
 @enum
 @brief 群组中的成员角色
 @constant eGroupMemberRole_Member 普通成员
 @constant eGroupMemberRole_Admin  群组管理员
 @constant eGroupMemberRole_Owner  群组创建者
 */
typedef NS_ENUM(NSInteger, EMGroupMemberRole) {
    eGroupMemberRole_Member = 0,
    eGroupMemberRole_Admin,
    eGroupMemberRole_Owner,
} ;


#endif
