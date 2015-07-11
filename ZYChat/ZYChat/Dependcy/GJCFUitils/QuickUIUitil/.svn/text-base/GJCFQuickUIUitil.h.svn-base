//
//  GJCFQuickUIUitil.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-22.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

typedef void (^GJCFQuickAnimationCompletionBlock) (BOOL finished);

@interface GJCFQuickUIUitil : NSObject

+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)colorFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue withAlpha:(CGFloat)alpha;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIImage *)imageWithName:(NSString *)imageName;

+ (UIImage *)imageWithFilePath:(NSString *)filePath;

+ (UIImage *)imageUnArchievedFromFilePath:(NSString *)filePath;

+ (UIImage *)roundImage:(UIImage *)aImage;

+ (UIImage *)partImage:(UIImage *)aImage withRect:(CGRect)partRect;

+ (UIImage *)correctImageOrientation:(UIImage *)aImage;

+ (UIImage *)correctImageOrientation:(UIImage *)aImage withScaleSize:(CGFloat)scale;

+ (UIImage *)correctFullSolutionImageFromALAsset:(ALAsset *)asset;

+ (UIImage *)correctFullSolutionImageFromALAsset:(ALAsset *)asset withScaleSize:(CGFloat)scaleSize;

+ (UIImage *)combineImage:(UIImage *)backgroundImage withMaskImage:(UIImage *)maskImage;

+ (UIImage *)fixOretationImage:(UIImage *)aImage;

+ (UIImage *)createRoundCornerImage:(UIImage *)aImage withCornerSize:(NSInteger)cornerSize withBoardSize:(NSInteger)boardSize;

/* 根据颜色创建图片 */
+ (UIImage *)imageForColor:(UIColor*)aColor withSize:(CGSize)aSize;

+ (UIImage *)gradientLinearImageFromColor:(UIColor *)fromColor withToColor:(UIColor *)toColor withImageSize:(CGSize)size;

+ (UIImage *)gradientLinearImageFromColors:(NSArray *)colors withImageSize:(CGSize)size;

+ (UIImage *)gradientRadialImageFromColor:(UIColor *)fromColor withToColor:(UIColor *)toColor withImageSize:(CGSize)size;

+ (UIImage *)gradientRadialImageFromColors:(NSArray *)colors withImageSize:(CGSize)size;

+ (UIImage *)gridImageHorizonByLineGap:(CGFloat)lineGap withLineColor:(UIColor *)lineColor withImageSize:(CGSize)size;

+ (UIImage *)gridImageVerticalByLineGap:(CGFloat)lineGap withLineColor:(UIColor *)lineColor withImageSize:(CGSize)size;

+ (UIImage *)gridImageByHoriLineGap:(CGFloat)hLineGap withVerticalLineGap:(CGFloat)vLineGap withLineColor:(UIColor *)lineColor withImageSize:(CGSize)size;

/* 图片拉伸 */
+ (UIImage *)stretchImage:(UIImage *)originImage withTopOffset:(CGFloat)top withLeftOffset:(CGFloat)left;

+ (UIImage *)resizeImage:(UIImage *)originImage withEdgeTop:(CGFloat)top withEdgeBottom:(CGFloat)bottom withEdgeLeft:(CGFloat)left withEdgeRight:(CGFloat)right;

+ (void)animationDuration:(NSTimeInterval)duration action:(dispatch_block_t)block;

+ (void)animationDelay:(NSTimeInterval )delaySecond animationDuration:(NSTimeInterval)duration action:(dispatch_block_t)block;

+ (void)animationView:(UIView *)view withDuration:(NSTimeInterval)duration action:(dispatch_block_t)block withOptions:(UIViewAnimationOptions)options completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)animationView:(UIView *)view delay:(NSTimeInterval)delaySecond animationDuration:(NSTimeInterval)duration action:(dispatch_block_t)block withOptions:(UIViewAnimationOptions)options completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)defaultHiddenShowView:(UIView *)view;

+ (void)defaultShowHiddenView:(UIView *)view;

+ (void)defaultHiddenView:(UIView *)view;

+ (void)defaultShowView:(UIView *)view;

+ (void)hiddenView:(UIView *)view withDuration:(NSTimeInterval)duration;

+ (void)showView:(UIView *)view withDuration:(NSTimeInterval)duration;

+ (void)showView:(UIView *)view finalAlpha:(CGFloat)alpha withDuration:(NSTimeInterval)duration;

+ (void)hiddenShowView:(UIView *)view withDuration:(NSTimeInterval)duration;

+ (void)showHiddenView:(UIView *)view withDuration:(NSTimeInterval)duration;

+ (void)moveView:(UIView *)view newRect:(CGRect)rect withDuration:(NSTimeInterval)duration;

+ (void)moveViewX:(UIView *)view originXDetal:(CGFloat)moveX withDuration:(NSTimeInterval)duration;

+ (void)moveViewY:(UIView *)view originYDetal:(CGFloat)moveY withDuration:(NSTimeInterval)duration;

+ (void)moveViewWidth:(UIView *)view widthDetal:(CGFloat)moveWidth withDuration:(NSTimeInterval)duration;

+ (void)moveViewHeight:(UIView *)view heightDetal:(CGFloat)moveHeight withDuration:(NSTimeInterval)duration;

+ (void)moveViewToX:(UIView *)view toOriginX:(CGFloat)moveX withDuration:(NSTimeInterval)duration;

+ (void)moveViewToY:(UIView *)view toOriginY:(CGFloat)moveY withDuration:(NSTimeInterval)duration;

+ (void)moveViewToWidth:(UIView *)view toWidth:(CGFloat)moveWidth withDuration:(NSTimeInterval)duration;

+ (void)moveViewToHeight:(UIView *)view toHeight:(CGFloat)moveHeight withDuration:(NSTimeInterval)duration;

+ (void)moveViewCenter:(UIView *)view newCenter:(CGPoint)center withDuration:(NSTimeInterval)duration;

+ (void)moveViewSize:(UIView *)view newSize:(CGSize)size withDuration:(NSTimeInterval)duration;

+ (void)moveView:(UIView *)view originXDetal:(CGFloat)moveX originYDetal:(CGFloat)moveY widthDetal:(CGFloat)moveWidth heightDetla:(CGFloat)moveHeight withDuration:(NSTimeInterval)duration;

+ (void)flipViewFromLeft:(UIView *)view withDuration:(NSTimeInterval)duration action:(dispatch_block_t)block completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)flipViewFromRight:(UIView *)view withDuration:(NSTimeInterval)duration action:(dispatch_block_t)block completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)flipViewFromTop:(UIView *)view withDuration:(NSTimeInterval)duration action:(dispatch_block_t)block completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)flipViewFromBottom:(UIView *)view withDuration:(NSTimeInterval)duration action:(dispatch_block_t)block completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)flipView:(UIView *)view fromLeft:(BOOL)isLeft fromRight:(BOOL)isRight fromTop:(BOOL)isTop fromBottom:(BOOL)isBottom action:(dispatch_block_t)block withDuration:(NSTimeInterval)duration completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)pageUpViewFromBottom:(UIView *)view withDuration:(NSTimeInterval)duration action:(dispatch_block_t)block completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)pageUpView:(UIView *)view fromLeft:(BOOL)isLeft fromRight:(BOOL)isRight fromTop:(BOOL)isTop fromBottom:(BOOL)isBottom action:(dispatch_block_t)block withDuration:(NSTimeInterval)duration completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)pageDownViewFromTop:(UIView *)view withDuration:(NSTimeInterval)duration action:(dispatch_block_t)block completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)pageDownView:(UIView *)view fromLeft:(BOOL)isLeft fromRight:(BOOL)isRight fromTop:(BOOL)isTop fromBottom:(BOOL)isBottom action:(dispatch_block_t)block withDuration:(NSTimeInterval)duration completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

+ (void)cubeView:(UIView *)view withDuration:(NSTimeInterval)duration  action:(dispatch_block_t)block completionBlock:(GJCFQuickAnimationCompletionBlock)completion;

/* CAAnimation */

+ (void)rotationViewX:(UIView *)view withDegree:(CGFloat)degree withDuration:(NSTimeInterval)duration;

+ (void)rotationViewY:(UIView *)view withDegree:(CGFloat)degree withDuration:(NSTimeInterval)duration;

+ (void)rotationViewZ:(UIView *)view withDegree:(CGFloat)degree withDuration:(NSTimeInterval)duration;

+ (void)translationViewX:(UIView *)view withOriginX:(CGFloat)originX withDuration:(NSTimeInterval)duration;

+ (void)translationViewY:(UIView *)view withOriginY:(CGFloat)originY withDuration:(NSTimeInterval)duration;

+ (void)translationViewZ:(UIView *)view withOriginZ:(CGFloat)originZ withDuration:(NSTimeInterval)duration;

+ (void)scaleViewX:(UIView *)view withScaleSize:(CGFloat)size withDuration:(NSTimeInterval)duration;

+ (void)scaleViewY:(UIView *)view withScaleSize:(CGFloat)size withDuration:(NSTimeInterval)duration;

+ (void)scaleViewZ:(UIView *)view withScaleSize:(CGFloat)size withDuration:(NSTimeInterval)duration;

+ (void)animationView:(UIView *)view withAnimationPath:(NSString *)path toValue:(NSValue *)value withDuration:(NSTimeInterval)duration;

/* repeat block in mainQueue*/
- (void)addRepeatBlockInfo:(NSDictionary *)blockActionInfoDict;

- (void)removeBlockInfo:(NSString *)blockIdentifier;

- (void)startRepeatAction;

+ (NSString *)repeatDoAction:(dispatch_block_t)block;

+ (NSString *)repeatDoAction:(dispatch_block_t)block withDelay:(NSTimeInterval)delaySecond;

+ (NSString *)repeatDoAction:(dispatch_block_t)block withRepeatDuration:(NSTimeInterval)duration;

+ (NSString *)repeatDoAction:(dispatch_block_t)block withDelay:(NSTimeInterval)delaySecond withRepeatDuration:(NSTimeInterval)duration;

+ (void)stopRepeatAction:(NSString *)blockIdentifier;

/* transform */

+ (void)view3DRotateX:(UIView *)view withDegree:(CGFloat)degree;

+ (void)view3DRotateY:(UIView *)view withDegree:(CGFloat)degree;

+ (void)view3DRotateZ:(UIView *)view withDegree:(CGFloat)degree;

+ (void)view3DRotate:(UIView *)view x:(CGFloat)x y:(CGFloat)yState z:(CGFloat)zState withDegree:(CGFloat)degree;

+ (void)view3DTranslateX:(UIView *)view withValue:(CGFloat)value;

+ (void)view3DTranslateY:(UIView *)view withValue:(CGFloat)value;

+ (void)view3DTranslateZ:(UIView *)view withValue:(CGFloat)value;

+ (void)view3DTranslate:(UIView *)view x:(CGFloat)xState y:(CGFloat)yState z:(CGFloat)zState;

+ (void)view3DScaleX:(UIView *)view withValue:(CGFloat)value;

+ (void)view3DScaleY:(UIView *)view withValue:(CGFloat)value;

+ (void)view3DScaleZ:(UIView *)view withValue:(CGFloat)value;

+ (void)view3DScale:(UIView *)view x:(CGFloat)xState y:(CGFloat)yState z:(CGFloat)zState;

/* cycle Animation */

+ (void)animationViewXCycle:(UIView *)view withXMoveDetal:(CGFloat)moveX withDuration:(NSTimeInterval)duration;

+ (void)animationViewYCycle:(UIView *)view withYMoveDetal:(CGFloat)moveY withDuration:(NSTimeInterval)duration;

+ (void)animationViewZCycle:(UIView *)view withZMoveDetal:(CGFloat)moveZ withDuration:(NSTimeInterval)duration;

+ (void)animationViewRotateXCycle:(UIView *)view withXRotateDetal:(CGFloat)xDegree withDuration:(NSTimeInterval)duration;

+ (void)animationViewRotateYCycle:(UIView *)view withYRotateDetal:(CGFloat)yDegree withDuration:(NSTimeInterval)duration;

+ (void)animationViewRotateZCycle:(UIView *)view withZRotateDetal:(CGFloat)zDegree withDuration:(NSTimeInterval)duration;

+ (CGContextRef)getTextCTMContextRefFromView:(UIView *)aView;

+ (UIImage *)viewScreenShot:(UIView *)aView;

+ (UIImage *)layerScreenShot:(CALayer *)layer;

/* CAAnimation */

+ (void)animationLayer:(CALayer *)aLayer positionXWithFromValue:(NSValue *)fromValue withToValue:(NSValue *)toValue withRepeatCount:(NSInteger)repeatCount withDuration:(NSTimeInterval)duration;

+ (void)animationLayer:(CALayer *)aLayer positionYWithFromValue:(NSValue *)fromValue withToValue:(NSValue *)toValue withRepeatCount:(NSInteger)repeatCount  withDuration:(NSTimeInterval)duration;

+ (void)animationLayer:(CALayer *)aLayer positionCenterWithFromValue:(NSValue *)fromValue withToValue:(NSValue *)toValue withRepeatCount:(NSInteger)repeatCount  withDuration:(NSTimeInterval)duration;

+ (void)animationLayer:(CALayer *)aLayer path:(NSString *)path withFromValue:(NSValue *)fromValue withToValue:(NSValue *)toValue withRepeatCount:(NSInteger)repeatCount  withDuration:(NSTimeInterval)duration;

+ (void)animationLayer:(CALayer *)aLayer positionXByValue:(NSValue *)value withRepeatCount:(NSInteger)repeatCount withDuration:(NSTimeInterval)duration;

+ (void)animationLayer:(CALayer *)aLayer positionYByValue:(NSValue *)value  withRepeatCount:(NSInteger)repeatCount  withDuration:(NSTimeInterval)duration;

+ (void)animationLayer:(CALayer *)aLayer positionCenterByValue:(NSValue *)value  withRepeatCount:(NSInteger)repeatCount  withDuration:(NSTimeInterval)duration;

+ (void)animationLayer:(CALayer *)aLayer path:(NSString *)path ByValue:(NSValue *)value  withRepeatCount:(NSInteger)repeatCount  withDuration:(NSTimeInterval)duration;


@end
