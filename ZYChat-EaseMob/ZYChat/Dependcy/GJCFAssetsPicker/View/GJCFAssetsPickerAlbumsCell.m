//
//  GJAssetsPickerAlbumsCell.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAssetsPickerAlbumsCell.h"
#import "GJCFAssetsPickerConstans.h"

@implementation GJCFAssetsPickerAlbumsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /*  系统样式，如果要完全自定义相册的Cell请进行继承，然后重新设置自己想要的样式 */
    self.imageView.frame = CGRectMake(8, 8, 49, 49);
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.textLabel.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
    self.textLabel.font = [UIFont systemFontOfSize:16];
    [self.textLabel sizeToFit];
    self.textLabel.frame = (CGRect){70,24,self.textLabel.frame.size.width,self.textLabel.frame.size.height};
    
    self.detailTextLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.detailTextLabel.font = [UIFont systemFontOfSize:16];
    [self.detailTextLabel sizeToFit];
    self.detailTextLabel.frame = (CGRect){self.textLabel.frame.origin.x+self.textLabel.frame.size.width+4.5,24,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height};
    
}

- (void)setAlbums:(GJCFAlbums *)aAlbums
{
    self.imageView.image = aAlbums.posterImage;
    self.textLabel.text = [NSString stringWithFormat:@"%@",aAlbums.name];
    self.detailTextLabel.text = [NSString stringWithFormat:@"(%d)张",aAlbums.totalCount];
    
    [self setNeedsLayout];
}

@end
