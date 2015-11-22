//
//  HARegistContentModel.h
//  HelloAsk
//
//  Created by ZYVincent on 15-9-4.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  内容类型
 */
typedef NS_ENUM(NSUInteger, HARegistContentType){
    /**
     *  用户名
     */
    HARegistContentTypeUserName,
    /**
     *  密码
     */
    HARegistContentTypePassword,
};

@interface HARegistContentModel : NSObject

@property (nonatomic,assign)HARegistContentType contentType;

@property (nonatomic,strong)NSString *tagName;

@property (nonatomic,strong)NSString *placeHolder;

@property (nonatomic,strong)NSString *content;

@property (nonatomic,assign)CGFloat contentHeight;

@end
