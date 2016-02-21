//
//  GJGCInformationBaseModel.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-6.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJGCInformationCellConstans.h"

/**
 *  分割线类型
 */
typedef NS_ENUM(NSUInteger, GJGCInformationSeprateLineStyle) {
    /**
     *  上面全分割，底部短分割
     */
    GJGCInformationSeprateLineStyleTopFullBottomShort,
    /**
     *  上面无分割，底部短分割
     */
    GJGCInformationSeprateLineStyleTopNoneBottomShort,
    /**
     *  上面无分割，底部全分割
     */
    GJGCInformationSeprateLineStyleTopNoneBottomFull,
    /**
     *  上面和底部全分割
     */
    GJGCInformationSeprateLineStyleTopFullBottomFull,
    
    /**
     *  上面全分割，底部无分割
     */
    GJGCInformationSeprateLineStyleTopFullBottomNone,
};

@interface GJGCInformationBaseModel : NSObject

#pragma mark - 样式控制属性

@property (nonatomic,assign)CGFloat topLineMargin;

@property (nonatomic,assign)CGFloat baseLineMargin;

@property (nonatomic,assign)GJGCInformationSeprateLineStyle seprateStyle;

@property (nonatomic,assign)GJGCInformationContentType baseContentType;

@property (nonatomic,strong)NSString *iconImageName;

@property (nonatomic,assign)BOOL shouldShowIndicator;

@property (nonatomic,assign)CGFloat contentHeight;

@end
