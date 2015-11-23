//
//  ViewController.h
//  瀑布流demo
//
//  Created by yuxin on 15/6/6.
//  Copyright (c) 2015年 yuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJGCBaseViewController.h"

typedef void (^WallPaperDidFinishChooseImageBlock) (NSString *imageUrl);

@interface WallPaperViewController : GJGCBaseViewController

@property (nonatomic,copy)WallPaperDidFinishChooseImageBlock resultBlock;

@end

