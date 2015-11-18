//
//  GJGCSnowFallLayer.m
//  ZYChat
//
//  Created by ZYVincent on 15/4/20.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "GJGCParticleEffectLayer.h"

@interface GJGCParticleEffectLayer()
@property(nonatomic,strong)NSArray *imageNameArray;
@end

@implementation GJGCParticleEffectLayer

- (id)initWithImageName:(NSString *)imageName{
    return [self initWithImageNameArray:[NSArray arrayWithObject:imageName]];
}

- (id)initWithImageNameArray:(NSArray *)imageNameArray{
    self = [super init];
    if (self) {
        self.imageNameArray = imageNameArray;
        [self initializeValue];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeValue];
    }
    return self;
}

-(void)initializeValue{
    // Configure the particle emitter to the top edge of the screen
    CAEmitterLayer *parentLayer = self;
    parentLayer.emitterPosition = CGPointMake(GJCFSystemScreenWidth / 2.0, -90);
    parentLayer.emitterSize		= CGSizeMake(GJCFSystemScreenWidth * 2.0, 0);
    
    // Spawn points for the flakes are within on the outline of the line
    parentLayer.emitterMode		= kCAEmitterLayerOutline;
    parentLayer.emitterShape	= kCAEmitterLayerLine;
    
    parentLayer.shadowOpacity = 1.0;
    parentLayer.shadowRadius  = 0.0;
    parentLayer.shadowOffset  = CGSizeMake(0.0, 1.0);
    parentLayer.shadowColor   = [[UIColor whiteColor] CGColor];
    parentLayer.seed = 1000;
    
    
    CAEmitterCell* containerLayer = [self createSubLayerContainer];
    containerLayer.name = @"containerLayer";
    NSMutableArray *subLayerArray = [NSMutableArray array];
    NSArray *contentArray = [self getContentsByArray:self.imageNameArray];
    for (UIImage *image in contentArray) {
        [subLayerArray addObject:[self createSubLayer:image]];
        [subLayerArray addObject:[self createSubKindLayer:image]];
    }
    
    if (containerLayer) {
        containerLayer.emitterCells = subLayerArray;
        parentLayer.emitterCells = [NSArray arrayWithObject:containerLayer];
    }else{
        parentLayer.emitterCells = subLayerArray;
    }
}
-(void)setDelayHideTime:(CGFloat)delayHideTime{
    _delayHideTime = delayHideTime;
    [self performSelector:@selector(stopFall) withObject:nil afterDelay:1];
}

-(void)stopFall{
    [self setValue:[NSNumber numberWithInt:0] forKeyPath:@"emitterCells.containerLayer.birthRate"];
}

-(CAEmitterCell*)createSubLayerContainer{
    CAEmitterCell* containerLayer = [CAEmitterCell emitterCell];
    containerLayer.birthRate			= 10.0;
    containerLayer.velocity			= 0;
    containerLayer.lifetime			= 0.35;
    return containerLayer;
}

-(CAEmitterCell *)createSubLayer:(UIImage *)image{
    
    CAEmitterCell *cellLayer = [CAEmitterCell emitterCell];
    
    cellLayer.birthRate		= 11.0;
    cellLayer.lifetime		= 20;
    
    cellLayer.velocity		= -100;				// falling down slowly
    cellLayer.velocityRange = 0;
    cellLayer.yAcceleration = 200.8;
    cellLayer.emissionRange = 0.5 * M_PI;		// some variation in angle
    cellLayer.spinRange		= 0.25 * M_PI;		// slow spin
    cellLayer.scale = 0.5;
    cellLayer.contents		= (id)[image CGImage];
    
    cellLayer.color			= [[UIColor whiteColor] CGColor];
    
    return cellLayer;
}

-(CAEmitterCell *)createSubKindLayer:(UIImage *)image{
    
    CAEmitterCell *cellLayer = [CAEmitterCell emitterCell];
    
    cellLayer.birthRate		= 8.0;
    cellLayer.lifetime		= 20;
    
    cellLayer.velocity		= -100;				// falling down slowly
    cellLayer.velocityRange = 0;
    cellLayer.yAcceleration = 160.8;
    cellLayer.emissionRange = 0.5 * M_PI;		// some variation in angle
    cellLayer.spinRange		= 0.25 * M_PI;		// slow spin
    cellLayer.scale = 0.43;
    cellLayer.contents		= (id)[image CGImage];
    
    cellLayer.color			= [[UIColor whiteColor] CGColor];
    
    return cellLayer;
}

-(NSArray *)getContentsByArray:(NSArray *)imageNameArray{
    NSMutableArray *retArray = [NSMutableArray array];
    
    for (NSString *imageName in imageNameArray) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [retArray addObject:image];
        }
    }
    return retArray;
}

@end
