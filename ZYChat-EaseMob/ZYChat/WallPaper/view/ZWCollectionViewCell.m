//
//  ZWCollectionViewCell.m
//  瀑布流demo
//
//  Created by yuxin on 15/6/6.
//  Copyright (c) 2015年 yuxin. All rights reserved.
//

#import "ZWCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ZWCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setShop:(shopModel *)shop
{
    _shop = shop;
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:_shop.img]];
    self.shopName.hidden = YES;
}
@end
