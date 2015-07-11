//
//  GJAlbums.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-10.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

#import "GJCFAlbums.h"

@implementation GJCFAlbums

- (id)initWithAssetsGroup:(ALAssetsGroup *)aGroup
{
    if (self = [super init]) {
        
        self.assetsGroup = aGroup;
        
    }
    return self;
}
- (UIImage*)posterImage
{
    if (!self.assetsGroup) {
        return nil;
    }
    return [UIImage imageWithCGImage:[self.assetsGroup posterImage]];
}

- (NSInteger)totalCount
{
    if (!self.assetsGroup) {
        return 0;
    }
    return [self.assetsGroup numberOfAssets];
}

- (NSString *)name
{
    if (!self.assetsGroup) {
        return nil;
    }
    NSString *sGroupPropertyName = (NSString *)[self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if ([sGroupPropertyName isEqualToString:@"Camera Roll"]) {
        
        return @"相机胶卷";
    }
    return sGroupPropertyName;
}

- (void)setFilter:(ALAssetsFilter *)filter
{
    if (_filter == filter) {
        
        return;
    }
    
    _filter = filter;
    
    [self.assetsGroup setAssetsFilter:_filter];
}

- (BOOL)isEqual:(GJCFAlbums*)aAlbums
{
    if (!aAlbums) {
        return NO;
    }
    
    if (![aAlbums isKindOfClass:[GJCFAlbums class]]) {
        return NO;
    }
    
    return [aAlbums.name isEqualToString:self.name];
}
            
@end
