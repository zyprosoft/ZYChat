//
//  GJGCInformationBaseCellDelegate.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 14-11-11.
//  Copyright (c) 2014年 ZYV. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GJGCInformationBaseCell;

@protocol GJGCInformationBaseCellDelegate <NSObject>

@optional

/**
 *  点击个人相册
 *
 *  @param photoBoxCell
 *  @param index
 */
- (void)informationPersonPhotoBoxCell:(GJGCInformationBaseCell *)photoBoxCell didTapOnPhotoIndex:(NSInteger)index;

/**
 *  点击群组相册
 *
 *  @param photoBoxCell
 *  @param index
 */
- (void)informationGroupPhotoBoxCell:(GJGCInformationBaseCell *)photoBoxCell didTapOnPhotoIndex:(NSInteger)index;

/**
 *  点击加入群组中的某一个群组
 *
 *  @param groupShowCell
 *  @param index         
 */
- (void)informationGroupShowCell:(GJGCInformationBaseCell *)groupShowCell didTapOnGroupItemIndex:(NSInteger)index;

/**
 *  点击了群成员展示的邀请按钮
 *
 *  @param memberShowCell 
 */
- (void)informationMemberShowCellDidTapOnInviteMember:(GJGCInformationBaseCell *)memberShowCell;

@end
