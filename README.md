# ZYChat

## (一) 是一个实战项目的聊天UI框架，针对高频次高速率刷新最近会话列表和实际对话页面做了缓冲优化,经过测试会话使用的性能和体验非常稳定。

## (二) UI框架参考MVVM思想设计，并采用自身总结的一些常用设计模式,可以帮助你快速实现搭建多样式的列表页面，代码复用率可以有稳定的提升。

## (三) ZYChat-EaseMob 是基于环信的UI项目应用实战，将ZYChat类库和实际项目使用结合。

## (四) 消息类型目前扩展至: 文本，语音，音乐，网页，鲜花特效，短视频

## (五) 想更深入的探讨学习请加QQ群:219357847

### 项目运行截图

![s_show](https://raw.githubusercontent.com/zyprosoft/ZYChat/master/ScreenShot/s_show.png "s_show")  

###项目代码结构图

![c_show](https://raw.githubusercontent.com/zyprosoft/ZYChat/master/ScreenShot/c_show.png "c_show")  

### 项目新增功能

* 1. 直接在聊天界面播放音乐
* 2. 新增送花功能

##项目核心模块注释

# ChatDetail  具体聊天
  *Resource 用到的图片
  *UITableViewCell 聊天所有的cell使用
  
    *Base      聊天内容基类Cell,负责分发类型
    
    *ChatCell  聊天内容Cell,    负责处理聊天类型的消息展示
    
      *GJGCChatFriendBaseCell , 基础内容Cell，包含消息显示的：头像，昵称(根据会话类型显示隐藏),气泡,状态
      
      *GJGCChatFriendTextMessageCell, 文本内容显示
      
      *GJGCChatFriendImageMessageCell, 图片内容显示
      
      *GJGCChatFriendAudioMessageCell, 语音内容显示
      
      *GJGCChatFriendTimeCell, 时间块显示
      
    *SystemNoti 系统消息Cell,   负责展示系统消息
    
  *View 聊天时候用到的自定义视图和风格控制
  
    *GJGCCommonFontColorStyle 全局风格控制
    
    *GJGCCommonHeadView 全局头像显示
    
    *GJGCChatContentEmojiParser 文本解析成图文内容
    
    *GJGCRefreshHeader 下拉刷新
    
    *GJGCRefreshFooter 上拉加载
    
    *GJGCLoadingStatusHUD 加载HUD,基类初始化，全局可用
    
  *ViewController
  
    *Base 基础类,负责分发 系统消息或者对话消息类型
  
    *MessageExtend 消息类型扩展，基于环信的消息ext字段来扩展消息，以支持gif等更多类型消息
    
    *Friend 单聊会话，群聊本质上也是1v1会话，只是有一些特殊逻辑需要单独处理，为了避免庞大的DataManager和ViewController,需要分开
    
    *GifLoadManager 本地Gif包管理
    
    *Group 群聊管理
    
    *SystemAssist 系统消息管理
    
#RecentChat 最近会话

  *GJGCRecentChatViewController  视图管理层
  *GJGCRecentChatCell            单行会话展示
  *GJGCRecentChatModel           内容模型
  *GJGCRecentChatDataManager     模型管理层
  *GJGCRecentChatStyle           风格管理
  *GJGCRecentChatTitleView       服务器连接状态展示

#Square  广场

  *CreateGroup  创建群组
  *PublicGroup  广场群组列表
  
#GroupCommonUI  群组资料和个人资料展示
 
  *GJGCGroupInformationViewController 群组资料展示
  *GJGCPersonInformationViewController 个人资料展示
  

#如何扩展消息类型

 扩展消息类型需要做三件事情
 
 1. 继承GJGCChatFriendBaseCell 来扩展对话消息
 2. GJGCChatFriendConstans 在关系绑定中将内容类型和新扩展的消息类型绑定
 3. 在创建内容模型的时候，将内容类型设置为新创建的内容类型即可绑定
 
##例子

 *首先创建内容展示的样子，GJGCCHatFriendGifCell
 *在内容模型中定义        gifLocalId , 在 GJGCChatFriendConstans 中定义内容类型 GJGCChatFriendContentTypeGif
 * 在GJGCChatFriendConstans 实现 ContentType 和 Cell的绑定
 *在创建GJGCChatFriendContentModel的时候将内容设置为GJGCChatFriendContentTypeGif就可以实现加载对应的gifCell

#如何基于环信的消息扩展字段配合GJGCMessageExtendModel实现扩展消息类型的目的

 *userInfo : 用户信息，始终从消息中带过去，根据App情况，也可以不用传过去节省流量，这里我们是没有服务器，所以传过去
 
 *data:   扩展消息的内容，看一下我们定义的一些常量key,对应的我们可以把需要扩展的内容填充
 
 *message_type: 扩展的消息类型，类似常规时候的 text,gif,voice这些类型的定义方式
 
 *is_message_extend: 是否是消息扩展，当不是扩展消息的时候，我们只读用户扩展信息userInfo就可以了
 
 *display_text: 扩展消息应该展示的文本，如果对方源码不支持此扩展消息，相应这个文本会有变化
 
 *is_support_display: 根据双方本地的内容协议支持来确定，是否支持正常显示这条扩展消息
 

###工具类库注释 (Dependcy)

*Base64   用于压缩编码字符串，在群信息压缩的环节使用

*EaseMob  环信聊天服务SDK

*fmdb     最好用的Sqlite,在上面做了一层简单的封装，支持对象化CURD操作

*GJCFCachePathMananger 应用层全局的缓存目录管理

*GJCUProgressView 自定义的一个进度展示

*SDWebImage   最好用的图片缓存库，目前基本全部使用此类库来加载图片

*JSONModel    实测使用最稳定的Json转模型，很好的自定义扩展，在项目中Json与模型转化和生成都运用到了

*GJCURoundCornerView 取自另一个作者的一个控件，可以自定义四个角的圆角和试图的bord情况

*GJCUCapture  根据Apple的AVCapture Demo 自定义的一个拍照的组件，母的是解决iOS7.0 iPhone4,5下的拍照黑屏问题

*GJGCChatInputPnael  项目中对话使用的聊天输入控制面板

*AFNetworking  最好用的网络库

*AudioCoder    语音编码库，公开的

*DownloadManager 任务化下载组件

*FileUploadManager 任务化上传组件

*FLAnimateImage  用于Gif表情展示

*GJCFAssetsPicker 自定义图片选择

*GJCFAuidoManager 播放和录音

*GJCFCoreText     自定义图文混排组件

*GJCFUitils       常用工具函数

*GJCUAsyncImageView 自定义异步图片加载，不是非常稳定，目前底层全部改成SDWebImage加载

*GJCUImageBrowase 大图浏览组件


#为什么做这个聊天室？

 大家都在做App，可能各种需求，各种蛋疼的坑，老板说，我们就是要有个IM消息服务，但是还得能自己定义，那么OK，我们的目标来了，谁来写呢，再写一遍，很麻烦，ZYChat经过对话详情页疯狂对发消息测试，没有任何问题，所以，我们要得是一个真实的对话聊天项目，并且它是开源的，大家都可以来做一些自己想做的扩展，我们需要关心的就是，我们要做的是什么，如何使用它，节省我们的时间。所以，ZYChat-EaseMob就诞生了。
 
#帮助我改进

我知道这个代码可能在很多大神面前都是不值得一提的东西，但是，我希望帮助到它能够帮助到得人就可以了。如果还有需要帮助咨询的，可以给我发邮件1003081775@qq.com，如果感兴趣可以联系我加入一起开发完善此项目,谢谢大家支持,更多需要详细解答问题的请加QQ群:219357847。

