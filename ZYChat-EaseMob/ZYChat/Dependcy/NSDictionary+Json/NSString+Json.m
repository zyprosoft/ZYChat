//
//  NSString+Json.m
//  ZYChat
//
//  Created by ZYVincent on 16/6/29.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)

- (NSDictionary *)toDictionary
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    return jsonDict;
}

@end
