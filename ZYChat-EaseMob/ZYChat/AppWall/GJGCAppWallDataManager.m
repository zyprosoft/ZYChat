//
//  GJGCAppWallDataManager.m
//  ZYChat
//
//  Created by ZYVincent on 15/11/26.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCAppWallDataManager.h"
#import "ZYDataCenter.h"
#import "GDataXMLNode.h"

@interface GJGCAppWallDataManager ()

@end

@implementation GJGCAppWallDataManager

- (instancetype)init
{
    if (self = [super init]) {
        
        self.paramsModel = [[GJGCAppWallParamsModel alloc]init];
        self.isFirstLoadingFinish = NO;
    }
    return self;
}

- (void)refresh
{
    if (self.isFirstLoadingFinish) {
        [self.delegate dataManagerRequireRefresh:self];
    }
}

- (void)requestAppListNow
{
    [self requestListData];
}

- (void)requestListData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self htmlUrl]]];
        
        NSString *htmlString = [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding];
        
//        NSLog(@"htmlString:%@",htmlString);
        
        GDataXMLDocument *htmlDoc = [[GDataXMLDocument alloc]initWithHTMLString:htmlString error:nil];
        
//        NSLog(@"htmlDoc :%@",htmlDoc);
        
        NSArray *elements = [htmlDoc nodesForXPath:@"//dl" error:nil];
        
        NSLog(@"elememnts:%@",elements);
        
    NSMutableArray *AppIconAndNames = [NSMutableArray array];
    NSMutableArray *linkNodes = [NSMutableArray array];

    NSInteger needCount = 20;
        
     @autoreleasepool {
         
//        for(NSInteger index = 0;index < elements.count;index++) {
         
            GDataXMLElement *node = elements[0];
            
            NSArray *imageNodes = [node nodesForXPath:@"//dt" error:nil];

            //取图标和名字
            GDataXMLNode *subImageNode = [imageNodes firstObject];
            NSArray *imageAndAppNode = [subImageNode nodesForXPath:@"//img" error:nil];
         
            for (GDataXMLElement *subItemNode in imageAndAppNode) {
                
                NSString *appIcon = [subItemNode attributeForName:@"src"].stringValue;
                
                if ([appIcon rangeOfString:@"mzstatic.com/image/thumb/Purple"].location != NSNotFound) {
                    
                    NSLog(@"App Icon :%@",appIcon);
                    
                    NSString *appName = [subItemNode attributeForName:@"title"].stringValue;
                    NSLog(@"App Name :%@",appName);
                    
                    [AppIconAndNames addObject:@[appName,appIcon]];
                }
                
                if (AppIconAndNames.count >= needCount) {
                    break;
                }
            }
            
            //取app store链接
            for(NSInteger index = 0;index < elements.count;index++) {
                
                GDataXMLElement *node = elements[0];
                
                NSArray *innerNameNodes = [node nodesForXPath:@"//dd" error:nil];
                
                GDataXMLElement *linkRealItem = nil;
                for (GDataXMLElement *item in innerNameNodes) {
                    if ([[item attributeForName:@"style"].stringValue isEqualToString:@"vertical-align:top; padding:0px;"]) {
                        linkRealItem = item;
                        break;
                    }
                }
                NSArray *linkHrefNode = [linkRealItem nodesForXPath:@"//a" error:nil];
                
                for (GDataXMLElement *subLinkItemNode in linkHrefNode) {
                    
                    NSString *appLink = [subLinkItemNode attributeForName:@"href"].stringValue;
                    NSLog(@"App Store Link :%@",appLink);
                    
                    if ([appLink hasPrefix:@"http://itunes.apple.com/"] || [appLink hasPrefix:@"https://itunes.apple.com/"]) {
                        
                        [linkNodes addObject:appLink];
                        
                    }
                    
                    if (linkNodes.count >= needCount) {
                        break;
                    }
                }
                
            }
         
//        }
         
      }
     
        if (self.isRefresh) {
            [self clearData];
        }
        
        //创建UI数据源
        for (NSInteger index = 0; index < AppIconAndNames.count;index++) {
            
            NSArray *appItem = AppIconAndNames[index];
            
            GJGCInfoBaseListContentModel *item = [[GJGCInfoBaseListContentModel alloc]init];
            item.title = appItem[0];
            item.headUrl = appItem[1];
            item.appStoreLink = linkNodes[index];
            item.time = [NSString stringWithFormat:@"%ld名",(long)index+1];
            
            [self addContentModel:item];
        }
        
       dispatch_async(dispatch_get_main_queue(), ^{
           
           self.isReachFinish = YES;
           self.isRefresh = NO;
           self.isLoadMore = NO;
           self.isFirstLoadingFinish = YES;
           
           [self.delegate dataManagerRequireRefresh:self];
           
       });

    });
}

- (NSString *)htmlUrl
{
    NSMutableString *resultUrl = [NSMutableString stringWithString:@"http://www.app12345.com/?"];
    
    NSDictionary *getParams = @{
                                @"area":self.paramsModel.area,
                                @"store":@"Apple Store",
                                @"device":self.paramsModel.device,
                                @"pop_id":@"27",
                                @"showdate":self.paramsModel.date,
                                @"showtime":@"12",
                                @"genre_id":self.paramsModel.categoryId,
                                };
    
    [resultUrl appendString:GJCFStringEncodeDict(getParams)];
    
    NSLog(@"html url:%@",resultUrl);
    
    return resultUrl;
}

@end
