# ZYChat

## (一) 是一个实战项目的聊天UI框架，针对高频次高速率刷新最近会话列表和实际对话页面做了缓冲优化,经过测试会话使用的性能和体验非常稳定。

## (二) UI框架参考MVVM思想设计，并采用自身总结的一些常用设计模式,可以帮助你快速实现搭建多样式的列表页面，代码复用率可以有稳定的提升。

## (三) ZYChat-EaseMob 是基于环信的UI项目应用实战，将ZYChat类库和实际项目使用结合。

### 项目运行截图

![s_show](https://raw.githubusercontent.com/zyprosoft/ZYChat/master/ScreenShot/s_show.png "s_show")  

###项目代码结构图

![c_show](https://raw.githubusercontent.com/zyprosoft/ZYChat/master/ScreenShot/c_show.png "c_show")  

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



