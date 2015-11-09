sdk-ios-cocoapods
=================

环信iOS SDK  CocoaPod repo

从2.0.6开始, 小伙伴们可以使用 Cocoapods 来集成环信啦, 集成方法如下:

1. Podfile 文件添加如下代码

		source 'https://github.com/CocoaPods/Specs.git'
		pod 'EaseMobSDK', :git => 'https://github.com/easemob/sdk-ios-cocoapods.git'
		
2. 使用时, 需要引入头文件, 在 pch 预编译文件中, 引入头文件如下:

		#import <EaseMobSDK/EaseMob.h>
		
接下来, 就可以正常使用环信的所有功能啦.

具体的使用步骤可以参考我们的官方文档: [初始化](http://developer.easemob.com/docs/emchat/ios/singlechat.html)
