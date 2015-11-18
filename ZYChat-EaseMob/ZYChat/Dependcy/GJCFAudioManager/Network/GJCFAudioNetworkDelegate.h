//
//  GJCFAudioNetworkDelegate.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GJCFAudioNetwork;

@protocol GJCFAudioNetworkDelegate <NSObject>

@required

/* 使用者必须通过这个将自己知道的返回结果格式成GJCFAudioModel对象，否则认定上传失败 */
- (GJCFAudioModel *)audioNetwork:(GJCFAudioNetwork *)audioNetwork formateUploadResult:(GJCFAudioModel *)baseResultModel formateDict:(NSDictionary *)formateDict;

@optional

/* 这个协议要返回正确的Audio对象，必须要实现上面的格式化方法 */
- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork finishUploadAudioFile:(GJCFAudioModel *)audioFile;

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork finishDownloadWithAudioFile:(GJCFAudioModel *)audioFile;

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork forAudioFile:(NSString *)audioFileLocalPath uploadFaild:(NSError *)error;

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork forAudioFile:(NSString *)audioFileUnique downloadFaild:(NSError *)error;

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork forAudioFile:(NSString *)audioFileLocalPath uploadProgress:(CGFloat)progress;

- (void)audioNetwork:(GJCFAudioNetwork *)audioNetwork forAudioFile:(NSString *)audioFileUnique downloadProgress:(CGFloat)progress;

@end
