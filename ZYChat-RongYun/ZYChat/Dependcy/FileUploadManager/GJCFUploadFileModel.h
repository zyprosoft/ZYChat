//
//  GJCFUploadFileModel.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-12.
//  Copyright (c) 2014年 ZYProSoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

/* 上传文件对象 */
@interface GJCFUploadFileModel : NSObject<NSCoding>

/* 文件名 */
@property (nonatomic,strong)NSString *fileName;

/* 文件的二进制数据 */
@property (nonatomic,strong)NSData   *fileData;

/* 文件的多媒体类型 */
@property (nonatomic,strong)NSString *mimeType;

/* 模拟表单提交的时候要求的表单的名字 */
@property (nonatomic,strong)NSString *formName;

/* 如果是图片的时候可以用上来保存宽度 */
@property (nonatomic,assign)CGFloat  imageWidth;

/* 如果是图片的时候可以用上来保存高度 */
@property (nonatomic,assign)CGFloat  imageHeight;

/* 用来保存待上传文件的本地路径地址 */
@property (nonatomic,strong)NSString *localStorePath;

/* 待上传Assets文件 */
@property (nonatomic,strong)ALAsset *contentAsset;

/* 是否是上传Assets文件 */
@property (nonatomic,assign)BOOL isUploadAsset;

/* 是否上传Asset文件原始图片,默认上传原始图片 */
@property (nonatomic,assign)BOOL isUploadAssetOriginImage;

/* 是否上传一张图片 */
@property (nonatomic,assign)BOOL isUploadImage;

/* 是否上传路径的图片被归档过，默认未被归档 */
@property (nonatomic,assign)BOOL isUploadImageHasBeenArchieved;

/* 是否上传语音 */
@property (nonatomic,assign)BOOL isUploadAudio;

/* 如果是语音的时候可以用上来保存语音时长 */
@property (nonatomic,assign)NSTimeInterval audioDuration;

/* 用户希望携带的自定义信息 */
@property (nonatomic,strong)NSDictionary *userInfo;

// ===================== 推荐使用待上传文件路径来上传文件 ============= //

/* 便捷对象生成 */
+ (GJCFUploadFileModel*)fileModelWithFileName:(NSString*)fileName withFilePath:(NSString*)filePath withFormName:(NSString*)formName;

/* 便捷对象生成 */
+ (GJCFUploadFileModel*)fileModelWithFileName:(NSString*)fileName withFilePath:(NSString*)filePath withFormName:(NSString*)formName withMimeType:(NSString*)mimeType;


/* 便捷对象生成 */
+ (GJCFUploadFileModel*)fileModelWithFileName:(NSString*)fileName withFileData:(NSData*)fileData withFormName:(NSString*)formName;

/* 便捷对象生成 */
+ (GJCFUploadFileModel*)fileModelWithFileName:(NSString*)fileName withFileData:(NSData*)fileData withFormName:(NSString*)formName withMimeType:(NSString*)mimeType;


+ (NSString*)mimeTypeWithFileName:(NSString*)fileName;

/* 自身检测是否符合上传规则 */
- (BOOL)isValidateForUpload;

@end
