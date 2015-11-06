//
//  GJAssetsPickerCommonStyleDescription.m
//  GJAssetsPickerViewController
//
//  Created by ZYVincent on 14-9-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFAssetsPickerCommonStyleDescription.h"

@implementation GJCFAssetsPickerCommonStyleDescription

//设定一些初始值
- (id)init
{
    if (self = [super init]) {
        
        self.hidden = NO;
        self.originPoint = CGPointMake(0, 0);
        self.frameSize = CGSizeZero;
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
      self.hidden =  [aDecoder decodeBoolForKey:@"hidden"];
        
      self.normalStateImage =  [aDecoder decodeObjectForKey:@"normalStateImage"];
        
      self.highlightStateImage =  [aDecoder decodeObjectForKey:@"highlightStateImage"];

      self.selectedStateImage = [aDecoder decodeObjectForKey:@"selectedStateImage"];

      self.normalStateTitle = [aDecoder decodeObjectForKey:@"normalStateTitle"];

      self.selectedStateTitle = [aDecoder decodeObjectForKey:@"selectedStateTitle"];

      self.normalStateTextColor = [aDecoder decodeObjectForKey:@"normalStateTextColor"];

      self.highlightStateTextColor = [aDecoder decodeObjectForKey:@"highlightStateTextColor"];

      self.selectedStateTextColor = [aDecoder decodeObjectForKey:@"selectedStateTextColor"];

      self.backgroundImage = [aDecoder decodeObjectForKey:@"backgroundImage"];

      self.backgroundColor = [aDecoder decodeObjectForKey:@"backgroundColor"];

      self.font = [aDecoder decodeObjectForKey:@"font"];

      self.title = [aDecoder decodeObjectForKey:@"title"];

      self.titleColor = [aDecoder decodeObjectForKey:@"titleColor"];

      self.alpha = [aDecoder decodeFloatForKey:@"alpha"];
        
      self.frameSize = [aDecoder decodeCGSizeForKey:@"frameSize"];
        
      self.originPoint = [aDecoder decodeCGPointForKey:@"originPoint"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:self.hidden forKey:@"hidden"];
    
    [aCoder encodeObject:self.normalStateImage forKey:@"normalStateImage"];
    
    [aCoder encodeObject:self.highlightStateImage forKey:@"highlightStateImage"];

    [aCoder encodeObject:self.selectedStateImage forKey:@"selectedStateImage"];
    
    [aCoder encodeObject:self.normalStateTitle forKey:@"normalStateTitle"];
    
    [aCoder encodeObject:self.selectedStateTitle forKey:@"selectedStateTitle"];
    
    [aCoder encodeObject:self.normalStateTextColor forKey:@"normalStateTextColor"];
    
    [aCoder encodeObject:self.highlightStateTextColor forKey:@"highlightStateTextColor"];
    
    [aCoder encodeObject:self.selectedStateTextColor forKey:@"selectedStateTextColor"];
    
    [aCoder encodeObject:self.backgroundImage forKey:@"backgroundImage"];
    
    [aCoder encodeObject:self.backgroundColor forKey:@"backgroundColor"];
    
    [aCoder encodeObject:self.font forKey:@"font"];
    
    [aCoder encodeObject:self.title forKey:@"title"];
    
    [aCoder encodeObject:self.titleColor forKey:@"titleColor"];
    
    [aCoder encodeFloat:self.alpha forKey:@"alpha"];
    
    [aCoder encodeCGSize:self.frameSize forKey:@"frameSize"];
    
    [aCoder encodeCGPoint:self.originPoint forKey:@"originPoint"];
}

@end
