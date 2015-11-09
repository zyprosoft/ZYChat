/*!
 @header EMBuddy.h
 @abstract 好友的信息描述类
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */
#import <Foundation/Foundation.h>

/*!
 @enum
 @brief 好友关系
 @constant eEMBuddyFollowState_NotFollowed  双方不是好友
 @constant eEMBuddyFollowState_Followed     对方已接受好友请求
 @constant eEMBuddyFollowState_BeFollowed   登录用户已接受了该用户的好友请求
 @constant eEMBuddyFollowState_FollowedBoth 登录用户和小伙伴都互相在好友列表中
 */
typedef NS_ENUM(NSInteger, EMBuddyFollowState) {
    eEMBuddyFollowState_NotFollowed = 0,    //双方不是好友
    eEMBuddyFollowState_Followed,           //对方已接受好友请求.
    eEMBuddyFollowState_BeFollowed,         //登录用户已接受了该用户的好友请求
    eEMBuddyFollowState_FollowedBoth        //"登录用户"和"小伙伴"都互相在好友列表中
};

/*!
 @class
 @brief 好友的信息描述类
 */
@interface EMBuddy : NSObject

/*!
 @method
 @brief 通过username初始化一个EMBuddy对象
 @param username 好友的username
 @discussion
 @result EMBuddy实例对象
 */
+ (instancetype)buddyWithUsername:(NSString *)username;

/*!
 @property
 @brief 好友的username
 */
@property (copy, nonatomic, readonly)NSString *username;

/*!
 @property
 @brief 好友状态
 */
@property (nonatomic) EMBuddyFollowState followState;

/*!
 @property
 @brief 是否等待对方接受好友请求()
 @discussion A向B发送好友请求,会自动将B添加到A的好友列表中,但isPendingApproval为NO,表示等待B接受A的好友请求,如果在好友列表中,不需要显示isPendingApproval为NO的用户,屏蔽它即可
 */
@property (nonatomic) BOOL isPendingApproval;

@end
