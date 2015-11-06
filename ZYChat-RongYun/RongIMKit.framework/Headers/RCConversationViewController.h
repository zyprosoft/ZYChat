//
//  RCConversationViewController.h
//  RongIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#ifndef __RCConversationViewController
#define __RCConversationViewController
#import <UIKit/UIKit.h>
#import "RCBaseViewController.h"
#import "RCPluginBoardView.h"
#import "RCChatSessionInputBarControl.h"
#import "RCEmojiBoardView.h"
#import "RCThemeDefine.h"

@class RCMessageBaseCell;
@class RCMessageModel;

#define PLUGIN_BOARD_ITEM_ALBUM_TAG    1001
#define PLUGIN_BOARD_ITEM_CAMERA_TAG   1002
#define PLUGIN_BOARD_ITEM_LOCATION_TAG 1003
#if RC_VOIP_ENABLE
#define PLUGIN_BOARD_ITEM_VOIP_TAG     1004
#endif

/**
 *  RCConversationViewController
 */
@interface RCConversationViewController : RCBaseViewController
/**
 *  targetId
 */
@property(nonatomic, strong) NSString *targetId;
/**
 *  targetName
 */
@property(nonatomic, strong) NSString *userName;
/**
 *  unReadMessage
 */
@property(nonatomic, assign) NSInteger unReadMessage;
/**
 *  新消息提示条，未读消息上限150条
 */
@property(nonatomic, strong) UIButton *unReadButton;
/**
 *  未读消息label，开发者可以按照需求修改未读消息数的显示
 */
@property(nonatomic,strong) UILabel *unReadMessageLabel;
/**
 *  会话类型
 */
@property(nonatomic) RCConversationType conversationType;
/**
 *  展示会话的CollectionView控件，可以修改这个控件的属性比如背景
 */
@property(nonatomic, strong) UICollectionView *conversationMessageCollectionView;
/**
 *  会话数据存储数组
 */
@property(nonatomic, strong) NSMutableArray *conversationDataRepository;
/**
 *  UICollectionViewFlowLayout
 */
@property(nonatomic, strong) UICollectionViewFlowLayout *customFlowLayout;
/**
 *  输入工具栏
 */
@property(nonatomic, strong) RCChatSessionInputBarControl *chatSessionInputBarControl;
/**
 *  功能板
 */
@property(nonatomic, strong) RCPluginBoardView *pluginBoardView;
/**
 *  emoji
 */
@property(nonatomic, strong) RCEmojiBoardView *emojiBoardView;

/**
 *  new msg label
 */
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;

/**
 *  默认No，如果Yes，开启右上角和右下角未读个数icon。
 */
@property(nonatomic, assign) BOOL enableUnreadMessageIcon;

/**
 *  默认No,如果Yes, 当消息不在最下方时显示 右下角新消息数图标
 */
@property(nonatomic, assign) BOOL enableNewComingMessageIcon;

/**
 *  是否开启语音消息连读，设置为Yes，播放语音消息时 会连续播放下面所有收到的未读语音消息
 */
@property(nonatomic, assign) BOOL enableContinuousReadUnreadVoice;

/**
 * 是否允许保存新拍照片到本地系统
 */
@property(nonatomic, assign) BOOL enableSaveNewPhotoToLocalSystem;

/**
 * 用于查询会话列表未读消息数目显示在返回按钮之上。调用notifyUpdateUnreadMessageCount更新返回图标和设置Target
 * 设置了此值需要在继承会话VC，并重写leftBarButtonItemPressed函数，参考demo中RCDChatViewController
 * 值为想要统计未读数的会话类型Array。
 */
@property(nonatomic, strong) NSArray *displayConversationTypeArray;

/**
 * 是否显示发送者的名字，YES显示，NO不显示，默认是YES。
 * 有些场景可能用得到，比如单聊时，不需要显示发送者的名字。
 */
@property(nonatomic) BOOL displayUserNameInCell;

/**
 * 默认输入框类型，值为文本或者语言，默认为文本。
 */
@property(nonatomic) RCChatSessionInputBarInputType defaultInputType;

/**
 * 当会话为聊天室时获取的历史信息数目，默认值为10，在viewDidLoad之前设置
 * -1表示不获取，0表示系统默认数目(现在默认值为10条)，正数表示获取的具体数目，最大值为50
 */
@property(nonatomic, assign) int defaultHistoryMessageCountOfChatRoom;

/**
 *  init method
 *
 *  @param conversationType conversationType
 *  @param targetId         targetId
 *
 *  @return converation
 */
- (id)initWithConversationType:(RCConversationType)conversationType targetId:(NSString *)targetId;

/**
 *  设置头像样式,请在viewDidLoad之前调用
 *
 *  @param avatarStyle avatarStyle
 */
- (void)setMessageAvatarStyle:(RCUserAvatarStyle)avatarStyle;
/**
 *  设置头像大小,请在viewDidLoad之前调用
 *
 *  @param size size
 */
- (void)setMessagePortraitSize:(CGSize)size;

/**
 *  注册消息Cell
 *
 *  @param cellClass  cellClass
 *  @param identifier identifier
 */
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
/**
 *  在会话界面删除消息并更新会话界面
 *
 *  @param model  被删除消息的model
 */
- (void)deleteMessage:(RCMessageModel *)model;
/**
*  append消息到datasource中，并显示。可以用在插入提醒消息的场景。
*
*  @param message 消息
*/
- (void)appendAndDisplayMessage:(RCMessage *)message;
/**
 *  滚动到list的最底部
 *
 *  @param animated 是否动画
 */
- (void)scrollToBottomAnimated:(BOOL)animated;
#pragma mark override
/**
 *  返回方法，如果继承，请重写该方法，并且优先调用父类方法;
 *
 *  @param sender 发送者
 */
- (void)leftBarButtonItemPressed:(id)sender;

#pragma mark override
/**
 *  重写方法实现自定义消息的显示
 *
 *  @param collectionView collectionView
 *  @param indexPath      indexPath
 *
 *  @return RCMessageTemplateCell
 */
- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark override
/**
 *  将要显示会话消息，可以修改RCMessageBaseCell的头像形状，添加自定定义的UI修饰，建议不要修改里面label 文字的大小，cell 大小是根据文字来计算的，如果修改大小可能造成cell 显示出现问题
 *
 *  @param cell      cell
 *  @param indexPath indexPath
 */
- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;

#pragma mark override
/**
 *  重写方法实现自定义消息的显示的高度
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param indexPath            indexPath
 *
 *  @return 显示的高度
 */
- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark override
/**
 *  点击消息内容
 *
 *  @param model 数据
 */
- (void)didTapMessageCell:(RCMessageModel *)model;

/**
 *  点击消息内容中的链接，此事件不会再触发didTapMessageCell
 *
 *  @param url   Url String
 *  @param model 数据
 */
- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model;

/**
 *  点击消息内容中的电话号码，此事件不会再触发didTapMessageCell
 *
 *  @param phoneNumber Phone number
 *  @param model       数据
 */
- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model;
#pragma mark override
/**
 *  点击头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didTapCellPortrait:(NSString *)userId;

/**
 *  长按头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didLongPressCellPortrait:(NSString *)userId;

#pragma mark override
/**
 *  长按消息内容
 *
 *  @param model 数据
 *  @param view 长按视图区域
 */
- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view;

#pragma mark override
/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param model 图片消息model
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;

#pragma mark override
/**
 *  打开地理位置。开发者可以重写，自己根据经纬度打开地图显示位置。默认使用内置地图
 *
 *  @param locationMessageContent 位置消息
 */
- (void)presentLocationViewController:(RCLocationMessage *)locationMessageContent;

#pragma mark override
/**
 *  重写方法，过滤消息或者修改消息
 *
 *  @param messageCotent 消息内容
 *
 *  @return 返回消息内容
 */
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent;

#pragma mark override
/**
 *  重写方法，消息发送之后需要append到datasource中，并显示。在这之前调用，可以修改要显示的消息。
 *
 *  @param message 消息
 *
 *  @return 返回消息
 */
- (RCMessage *)willAppendAndDisplayMessage:(RCMessage *)message;

#pragma mark override
/**
 *  重写方法，消息发送完成触发
 *
 *  @param stauts        0,成功，非0失败
 *  @param messageCotent 消息内容
 */
- (void)didSendMessage:(NSInteger)stauts content:(RCMessageContent *)messageCotent;

/**
 *  发送消息
 *
 *  @param messageContent 消息
 *
 *  @param pushContent push显示内容
 */
- (void)sendMessage:(RCMessageContent *)messageContent pushContent:(NSString *)pushContent;

/**
 *  发送图片消息，此方法会先上传图片到融云指定的图片服务器，再发送消息。
 *
 *  @param imageMessage 消息
 *
 *  @param pushContent push显示内容
 */
- (void)sendImageMessage:(RCImageMessage *)imageMessage pushContent:(NSString *)pushContent;

/**
 *  重新发送消息。
 *  消息发送失败后，会有小红点，点击小红点进行重发消息。此时已经删除掉数据库信息和列表信息，重写此函数来发送消息，详情请见demo
 *
 *  @param messageContent 消息
 */
- (void)resendMessage:(RCMessageContent *)messageContent;

/**
 *  上传图片到应用的图片服务器。
 *  当应用使用非融云的图片服务器时，请调用sendImageMessage:pushContent:appUpload:这个接口发送图片消息，appUpload设置为YES。融云会自动调用到本函数进行图片上传。
 *  应用需要overwrite此函数，在这个函数里上传并把进度和结果告诉融云，融云用来更新UI和发送消息。
 *
 *  @param message        保持下来的图片消息
 *
 *  @param uploadListener 上传状态回调。请务必在恰当的时机调用updateBlock和successBlock来通知融云状态
 */
- (void)uploadImage:(RCMessage *)message uploadListener:(RCUploadImageStatusListener *)uploadListener;

/**
 *  发送图片消息，
 *
 *  @param imageMessage 图片消息
 *
 *  @param pushContent push显示内容
 *
 *  @param appUpload  为NO上传图片到融云指定的图片服务器。为YES时融云会回调uploadImage:uploadListener:函数，请务必实现该方法，并在该方法中上传图片，然后通过uploadListener通知融云上传进度和结果。
 */
- (void)sendImageMessage:(RCImageMessage *)imageMessage pushContent:(NSString *)pushContent appUpload:(BOOL)appUpload;
#pragma mark override
/**
 *  发送新拍照的图片成功之后，如果需要保存到本地系统，则重写该方法
 *
 *  @param newImage 待保存的图片
 */
- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage;

#pragma mark override
/**
 语音消息开始录音
 */
- (void)onBeginRecordEvent;

#pragma mark override
/**
 语音消息录音结束
 */
- (void)onEndRecordEvent;

#pragma mark override
/**
 *  点击pluginBoardView上item响应事件
 *
 *  @param pluginBoardView 功能模板
 *  @param tag             标记
 */
-(void)pluginBoardView:(RCPluginBoardView*)pluginBoardView clickedItemWithTag:(NSInteger)tag;
#pragma mark override
/**
 *  重写方法，通知更新未读消息数目，用于导航显示未读消息，当收到别的会话消息的时候，会触发一次。
 */
- (void)notifyUpdateUnreadMessageCount;
#pragma mark override
/**
 *  重写方法，输入框监控方法
 *
 *  @param inputTextView inputTextView 输入框
 *  @param range         range 范围
 *  @param text          text 文本
 */
- (void)inputTextView:(UITextView *)inputTextView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text;
@end
#endif