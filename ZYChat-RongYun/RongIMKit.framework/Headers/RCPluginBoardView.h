//
//  RCPluginBoard.h
//  CollectionViewTest
//
//  Created by Liv on 15/3/15.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCPluginBoardViewDelegate;

/**
 *  会话视图功能扩展
 */
@interface RCPluginBoardView : UICollectionView

/**
 *  所有的扩展项
 */
@property(nonatomic, strong) NSMutableArray *allItems;

/**
 *  功能扩展回调
 */
@property(nonatomic, weak) id<RCPluginBoardViewDelegate> pluginBoardDelegate;

/**
 *  添加扩展项到功能面板的指定位置，在会话中，可以在viewdidload后，向RCPluginBoardView添加功能项
 *
 *  @param image 图片
 *  @param title 标题
 *  @param index 索引
 *  @param tag   标记，自定义扩展功能时需要注意不能与默认扩展的tag重复。默认tag定义在RCConversationViewController.h中
 */
- (void)insertItemWithImage:(UIImage*)image title:(NSString*)title atIndex:(NSInteger)index tag:(NSInteger)tag;

/**
 *  添加扩展项到功能面板的队尾，在会话中，可以在viewdidload后，向RCPluginBoardView添加功能项
 *
 *  @param image 图片
 *  @param title 标题
 *  @param tag   标记，自定义扩展功能时需要注意不能与默认扩展的tag重复。默认tag定义在RCConversationViewController.h中
 */
-(void)insertItemWithImage:(UIImage*)image title:(NSString*)title tag:(NSInteger)tag;

/**
 *  更改指定位置扩展项的图标或者标题
 *
 *  @param index 索引
 *  @param image 图片
 *  @param title 标题
 */
-(void)updateItemAtIndex:(NSInteger)index image:(UIImage*)image title:(NSString*)title;

/**
 *  更改指定标签扩展项的图标或者标题
 *
 *  @param tag   标签
 *  @param image 图片
 *  @param title 标题
 */
-(void)updateItemWithTag:(NSInteger)tag image:(UIImage*)image title:(NSString*)title;

/**
 *  删除已经添加的扩展项
 *
 *  @param index 索引
 */
- (void)removeItemAtIndex:(NSInteger)index;

/**
 *  删除已经添加的扩展项
 *
 *  @param tag 标记
 */
- (void)removeItemWithTag:(NSInteger)tag;

/**
 *  删除所有的扩展项
 */
- (void)removeAllItems;
@end

/**
 *  功能板回调事件
 */
@protocol RCPluginBoardViewDelegate <NSObject>

/**
 *  点击事件
 *
 *  @param pluginBoardView 功能模板
 *  @param tag             标记
 */
-(void)pluginBoardView:(RCPluginBoardView*)pluginBoardView clickedItemWithTag:(NSInteger)tag;
@end
