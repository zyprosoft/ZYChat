//
//  RCLocationPickerViewController.h
//  iOS-IMKit
//
//  Created by YangZigang on 14/10/31.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCBaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

/** POI搜索结束后用于回调的block

 参数： pois 需要显示的POI列表

 参数： clearPreviousResult 如果地图位置已经发生变化，需要清空之前的POI数据

 参数： hasMore 如果POI数据很多，可以进行“更多”显示

 参数： error  搜索POI出现错误时，返回错误信息
 */
typedef void (^OnPoiSearchResult)(NSArray *pois, BOOL clearPreviousResult, BOOL hasMore, NSError *error);

@protocol RCLocationPickerViewControllerDelegate;
@protocol RCLocationPickerViewControllerDataSource;

/**
 * 位置选取视图控制器
 */
@interface RCLocationPickerViewController
    : RCBaseViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
/**
 *  delegate
 */
@property(nonatomic, weak) id<RCLocationPickerViewControllerDelegate> delegate;
/**
 *  dataSource
 */
@property(nonatomic, strong) id<RCLocationPickerViewControllerDataSource> dataSource;
/**
 *  mapViewContainer
 */
@property(nonatomic, strong) IBOutlet UIView *mapViewContainer;

/** @name 初始化函数 */

/** 初始化

 @param dataSource 详见<RCLocationPickerViewControllerDataSource>
 */
- (instancetype)initWithDataSource:(id<RCLocationPickerViewControllerDataSource>)dataSource;

/**
 *“返回”按钮按下后，会调用本函数。本函数默认执行
 *;如果自定义导航按钮或者自定义按钮，请自定义该方法
 *
 *  @param sender 事件发送者
 */
- (void)leftBarButtonItemPressed:(id)sender;

/** 完成按钮动作。
 * “完成”按钮按下后，会调用本函数。
 * 本函数会调用RCLocationPickerViewControllerDelegate的locationPicker:didSelectLocation:locationName:mapScreenShot:方法。
 * @param sender sender
 */
- (void)rightBarButtonItemPressed:(id)sender;
@end

/**
 *  位置获取视图数据源
 */
@protocol RCLocationPickerViewControllerDataSource <NSObject>

@optional
/**
 @return 在界面上显示的地图控件
 */
- (UIView *)mapView;

/**
 @return 界面上显示的中心点标记。如不想显示中心点标记，可以返回nil。
 */
- (CALayer *)annotationLayer;

/**
 *  位置标注名称
 *
 *  @param placeMark 位置标注
 *
 *  @return 返回地图标注的名称。
 */
- (NSString *)titleOfPlaceMark:(id)placeMark;

/**
 *  获取位置标注坐标
 *
 *  @param placeMark 位置标注
 *
 *  @return 返回地图标注的坐标。
 */
- (CLLocationCoordinate2D)locationCoordinate2DOfPlaceMark:(id)placeMark;

/**
 @param location 地图中心点
 @param animated 是否开启动画效果
 */
- (void)setMapViewCenter:(CLLocationCoordinate2D)location animated:(BOOL)animated;

/**
 @param coordinateRegion 地图显示区域
 @param animated 是否开启动画效果
 */
- (void)setMapViewCoordinateRegion:(MKCoordinateRegion)coordinateRegion animated:(BOOL)animated;

/**
 *  开发者自己实现的 RCLocationPickerViewControllerDataSource
 *可以据此进行特定处理。当有新的POI列表时，默认选中第一个。
 *
 *  @param placeMark 用户选择了某一个位置标注
 */
- (void)userSelectPlaceMark:(id)placeMark;

/**
 *  地图中心点坐标
 *
 *  @return 当前地图中心点，发送给好友的位置消息中会包含该中心点的坐标。
 */
- (CLLocationCoordinate2D)mapViewCenter;

/**
 * 设置POI搜索完毕后的回调block
 *
 *  @param poiSearchResult poi查询结果
 */
- (void)setOnPoiSearchResult:(OnPoiSearchResult)poiSearchResult;

/**
 * 获取当前视野中POI
 */
- (void)beginFetchPoisOfCurrentLocation;

/**
 * @return 对当前地图进行截图，该截图的缩略图会包含在发送给好友的位置消息中。
 */
- (UIImage *)mapViewScreenShot;

@end

/**
 * 当位置选择界面选择完毕后，通知delegate以便进行下一步的地理位置消息发送。
 */
@protocol RCLocationPickerViewControllerDelegate <NSObject>

/**
 *  通知delegate，已经获取到相关的地理位置信息
 *
 *  @param locationPicker locationPicker
 *  @param location       location
 *  @param locationName   locationName
 *  @param mapScreenShot  mapScreenShot
 */
- (void)locationPicker:(RCLocationPickerViewController *)locationPicker
     didSelectLocation:(CLLocationCoordinate2D)location
          locationName:(NSString *)locationName
         mapScreenShot:(UIImage *)mapScreenShot;

@end
