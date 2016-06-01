/*!
 *  \~chinese
 *  @header EMGroupOptions.h
 *  @abstract 群组属性选项
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMGroupOptions.h
 *  @abstract Group property options
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#define KSDK_GROUP_MINUSERSCOUNT 3
#define KSDK_GROUP_USERSCOUNTDEFAULT 200

/*!
 *  \~chinese 
 *  群组类型
 *
 *  \~english
 *  Group style
 */
typedef enum{
    EMGroupStylePrivateOnlyOwnerInvite  = 0,    /*! \~chinese 私有群组，只允许Owner邀请用户加入 \~english Private groups, only owner can invite users to join */
    EMGroupStylePrivateMemberCanInvite,         /*! \~chinese 私有群组，Owner和群成员均可邀请用户加入 \~english Private groups, both owner and members can invite users to join  */
    EMGroupStylePublicJoinNeedApproval,         /*! \~chinese 公开群组，Owner可以邀请用户加入; 非群成员用户发送入群申请，经Owner同意后才能入组 \~english Public groups, owner can invite users to join; User can join group after owner accept user's application */
    EMGroupStylePublicOpenJoin,                 /*! \~chinese 公开群组，用户可以自由加入 \~english Public groups, user can join the group freely */
}EMGroupStyle;

/*!
 *  \~chinese
 *  群组属性选项
 *
 *  \~english
 *  Group options
 */
@interface EMGroupOptions : NSObject

/*!
 *  \~chinese
 *  群组的类型
 *
 *  \~english
 *  Group style
 */
@property (nonatomic) EMGroupStyle style;

/*!
 *  \~chinese
 *  群组的最大成员数(3 - 2000，默认是200)
 *
 *  \~english
 *  The maximum number of group member(3-2000, the default is 200)
 */
@property (nonatomic) NSInteger maxUsersCount;

@end
