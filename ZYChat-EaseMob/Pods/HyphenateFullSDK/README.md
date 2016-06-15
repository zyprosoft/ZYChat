# HyphenateFullSDK


环信iOS FullSDK  CocoaPod repo

从3.1.1开始, 小伙伴们可以使用 Cocoapods 来集成环信3.0SDK啦, 集成方法如下:

1. Podfile 文件添加如下代码

		pod 'HyphenateFullSDK'
		
2. 使用时, 需要引入头文件, 在 pch 预编译文件中, 引入头文件如下:

		#import <HyphenateFullSDK/EMSDKFull.h>
		
接下来, 就可以正常使用环信的所有功能啦.

具体的使用步骤可以参考我们的官方文档: [初始化](http://docs.easemob.com/doku.php?id=im:300iosclientintegration)