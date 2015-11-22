//
//  GJGCSnowFallLayer.h
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/4/20.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GJGCParticleEffectLayer : CAEmitterLayer

@property(nonatomic,assign)CGFloat delayHideTime;

- (id)initWithImageName:(NSString *)imageName;
- (id)initWithImageNameArray:(NSArray *)imageNameArray;

-(void)initializeValue;

-(CAEmitterCell*)createSubLayerContainer;
-(CAEmitterCell *)createSubLayer:(UIImage *)image;

@end
