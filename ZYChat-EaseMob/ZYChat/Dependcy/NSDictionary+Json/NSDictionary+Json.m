//
//  NSDictionary+Json.m
//  ZYChat
//
//  Created by ZYVincent on 16/6/29.
//  Copyright © 2016年 ZYProSoft. All rights reserved.
//

#import "NSDictionary+Json.h"

@implementation NSDictionary (Json)

- (NSString *)toJson
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return json;
}

@end
