//
//  GJGCVideoCallViewController.h
//  ZYChat
//
//  Created by bob on 16/8/25.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "GJGCBaseViewController.h"

@interface GJGCVideoCallViewController : GJGCBaseViewController

- (instancetype)initWithSession:(EMCallSession *)session
                     isIncoming:(BOOL)isIncoming;

@property (strong, nonatomic) NSString *chatter;

@end
