//
//  RCLocationViewController.h
//  iOS-IMKit
//
//  Created by YangZigang on 14/11/4.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
/**
 *  RCLocationViewController
 */
@interface RCLocationViewController : RCBaseViewController <MKMapViewDelegate>

/** @name 属性 */

/** 需要显示的位置坐标 */
@property(nonatomic, assign) CLLocationCoordinate2D location;
/** 需要显示的位置名称 */
@property(nonatomic, strong) NSString *locationName;

/**
 *  返回按钮按下   如果自定义导航按钮或者自定义按钮，请自定义该方法
 *
 *  @param sender sender
 */
- (void)leftBarButtonItemPressed:(id)sender;

@end
