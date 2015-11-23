//
//  ZWCollectionViewCell.h
//  瀑布流demo
//
//  Created by yuxin on 15/6/6.
//  Copyright (c) 2015年 yuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopModel.h"
@interface ZWCollectionViewCell : UICollectionViewCell
@property(nonatomic,retain)shopModel * shop;
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *shopName;

@end
