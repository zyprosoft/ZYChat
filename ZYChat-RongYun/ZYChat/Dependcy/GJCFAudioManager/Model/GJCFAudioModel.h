//
//  GJCFAudioModel.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJCFAudioModel : NSObject

/* 文件唯一标示 */
@property (nonatomic,readonly)NSString *uniqueIdentifier;

/* 文件时长单位是秒 */
@property (nonatomic,assign)NSTimeInterval duration;

/* wav文件存储路径 */
@property (nonatomic,strong)NSString *localStorePath;

/* 文件在服务器的远程地址 */
@property (nonatomic,strong)NSString *remotePath;

/* 临时转换编码时候的文件,默认iOS本地应该保存wav格式的文件，
 * 但是在上传服务器可能要求是别的格式，比如AMR,所以，
 * 我们提供一个属性，来保存我们临时转换的文件路径 
 * 在下载服务器上的临时编码音频文件的时候，我们也将文件缓存到这个路径，
 * 然后对应的通过解码生成一份iOS本地的Wav格式文件，存在localStorePath路径下
 * 这样就可以确保我们始终访问localStorePath路径是iOS本地wav格式音频，tempEncodeFilePath是
 * 临时编码音频文件
 */
@property (nonatomic,strong)NSString *tempEncodeFilePath;

/* 限制录音时长 */
@property (nonatomic,assign)NSTimeInterval limitRecordDuration;

/* 限制播放时长 */
@property (nonatomic,assign)NSTimeInterval limitPlayDuration;

/* 文件通过表单模拟上传的时候要模拟的表单的名字 */
@property (nonatomic,strong)NSString *uploadFormName;

/* 文件名 */
@property (nonatomic,strong)NSString *fileName;

/* 临时转编码文件名 */
@property (nonatomic,strong)NSString *tempEncodeFileName;

/* wav文件大小 */
@property (nonatomic,readonly)CGFloat dataSize;

/* 用户自定义信息 */
@property (nonatomic,strong)NSDictionary *userInfo;

/* 文件扩展名 */
@property (nonatomic,strong)NSString *extensionName;

/* 临时转编码文件的扩展名 */
@property (nonatomic,strong)NSString *tempEncodeFileExtensionName;

/* 多媒体文件类型 */
@property (nonatomic,strong)NSString *mimeType;

/* 指定主缓存目录下面子缓存目录 */
@property (nonatomic,strong)NSString *subCacheDirectory;

/* 是否上传本地转编码的格式文件，默认是YES,因为服务器需要的是转编码后的音频文件 */
@property (nonatomic,assign)BOOL isUploadTempEncodeFile;

/* 是否需要存储一分转成本地WAV编码格式的文件,默认是YES,因为现在我们主要业务需要，目前只支持AMR转WAV */
@property (nonatomic,assign)BOOL isNeedConvertEncodeToSave;

/* 是否下载完就播放 */
@property (nonatomic,assign)BOOL shouldPlayWhileFinishDownload;

/* 当转码成本地iOS支持格式之后，是否将临时编码文件删除 */
@property (nonatomic,assign)BOOL isDeleteWhileFinishConvertToLocalFormate;

/* 当临时转码文件上传完成后，是否将临时编码文件删除 */
@property (nonatomic,assign)BOOL isDeleteWhileUploadFinish;

/* 该音频文件是否已经上传了 */
@property (nonatomic,assign)BOOL isBeenUploaded;

/* 删除临时编码文件 */
- (void)deleteTempEncodeFile;

/* 删除本地wav格式文件 */
- (void)deleteWavFile;


@end
