//
//  GJCFQuickUIMacrocDefine.h
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-10-22.
//  Copyright (c) 2014年 ganji.com. All rights reserved.
//

/**
 *  UI相关的快速访问工具宏
 */

#import "GJCFQuickUIUitil.h"

/**
 *  将0-360的角度转换为圆角度表示
 *
 *  @param degree
 *
 *  @return 真实的角度表示
 */
#define GJCFDegreeToRadius(degree) (degree * M_PI / 180)

/**
 *  获取角度对应的NSNumber对象
 */
#define GJCFDegreeToRadiusValue(degree) @(GJCFDegreeToRadius(degree))

/**
 *  快速得到RGB颜色
 */
#define GJCFQuickRGBColor(redValue,greenValue,blueValue) [GJCFQuickUIUitil colorFromRed:redValue green:greenValue blue:blueValue]

/**
 *  获取带alpha值的RGB颜色
 */
#define GJCFQuickRGBColorAlpha(redValue,greenValue,blueValue,alpha) [GJCFQuickUIUitil colorFromRed:redValue green:greenValue blue:blueValue withAlpha:alpha]

/**
 *  从16进制字符中得到颜色
 */
#define GJCFQuickHexColor(hexString) [GJCFQuickUIUitil colorFromHexString:hexString]

/**
 *  从一个View获取翻转的文本绘制的图形上下文CGContextRef
 */
#define GJCFContextRefTextMatrixFromView(aView) [GJCFQuickUIUitil getTextCTMContextRefFromView:aView]

/**
 *  快速获取图片
 */
#define GJCFQuickImage(imageName) [GJCFQuickUIUitil imageWithName:imageName]

/**
 *  修正图片方向
 *
 */
#define GJCFFixOretationImage(aImage) [GJCFQuickUIUitil fixOretationImage:aImage]

/**
 *  创建圆角图片
 */
#define GJCFRoundCornerImage(aImage,cornerSize,boardSize) [GJCFQuickUIUitil createRoundCornerImage:aImage withCornerSize:cornerSize withBoardSize:boardSize]

/**
 *  组合图片
 */
#define GJCFQuickCombineImage(backgroundImage,maskImage) [GJCFQuickUIUitil combineImage:backgroundImage withMaskImage:maskImage]

/**
 *  返回圆形图片,默认用白色作为遮挡颜色
 */
#define GJCFCycleImage(aImage) [GJCFQuickUIUitil roundImage:aImage]

/**
 *  截取Rect部分的图片
 */
#define GJCFPartImage(aImage,rect) [GJCFQuickUIUitil partImage:aImage withRect:rect]

/**
 *  返回纠正方向后得图片
 */
#define GJCFCorrectOrientationImage(aImage) [GJCFQuickUIUitil correctImageOrientation:aImage]

/**
 *  返回一个纠正了方向并且进行了scale倍数缩放的图片
 */
#define GJCFCorrectOrientationImageWithScale(aImage,scale) [GJCFQuickUIUitil correctImageOrientation:aImage withScaleSize:scale]

/**
 *  返回ALAsset纠正方向后并且进行了scale倍数缩放的fullResolutionImage图片
 */
#define GJCFCorrectOrientationALAssetFullResolutionImageWithScale(aALAsset,scale) [GJCFQuickUIUitil  correctFullSolutionImageFromALAsset:aALAsset withScaleSize:scale]

/**
 *  返回ALAsset纠正方向后的fullResolutionImage图片
 */
#define GJCFCorrectOrientationALAssetFullResolutionImage(aALAsset) [GJCFQuickUIUitil correctFullSolutionImageFromALAsset:aALAsset]

/**
 *  获取一个View的截图
 */
#define GJCFScreenShotFromView(aView) [GJCFQuickUIUitil viewScreenShot:aView]

/**
 *  获取一个Layer的截图
 */
#define GJCFScreenShotFromLayer(aLayer) [GJCFQuickUIUitil layerScreenShot:aLayer]

/**
 *  按照aColor颜色创建一张size大小的图片
 *
 */
#define GJCFQuickImageByColorWithSize(aColor,size) [GJCFQuickUIUitil imageForColor:aColor withSize:size]

/**
 *  创建一个线性渐变图片
 *
 *  @param colors    按顺序渐变颜色数组
 *  @param size      需要创建的图片的大小
 *
 *  最大只支持三种颜色，起始位置颜色，中间颜色，结束颜色
 *  依次位置为 0,0.5,1.0
 *  超过3种颜色也只取前三种颜色为渐变色
 *
 *  @return 返回渐变颜色图片
 */
#define GJCFLinearGradientImageByColorsWithSize(colors,size) [GJCFQuickUIUitil gradientLinearImageFromColors:colors withImageSize:size]

/**
 *  创建线性渐变图片
 *
 *  @param fromColor 起始发颜色
 *  @param toColor   中间颜色
 *  @param size      图片大小
 *
 *  @return 渐变图片
 */
#define GJCFLinearGradientImageFromColorToColor(fromColor,toColor,size) [GJCFQuickUIUitil gradientLinearImageFromColor:fromColor withToColor:toColor withImageSize:size]

/**
 *  创建球形渐变图片
 *
 *  @param fromColor 中心颜色
 *  @param toColor   外层颜色
 *  @param size      图片大小
 *
 *  @return 渐变图片
 */
#define GJCFRadialGradientImageFromColorToColor(fromColor,toColor,size) [GJCFQuickUIUitil gradientRadialImageFromColor:fromColor withToColor:toColor withImageSize:size]

/**
 *  创建球形渐变图片
 *
 *  @param colors 颜色值数组
 *  @param size 图片大小
 *
 *  @return 渐变图片
 */
#define GJCFRadialGradientImageByColorsWithSize(colors,size) [GJCFQuickUIUitil gradientRadialImageFromColors:colors withImageSize:size]

/**
 *  创建网格线图片
 *
 *  @param lineGap 格线距离
 *  @param color   格线颜色
 *  @param size    图片大小
 *
 *  @return 网格线图片
 */
#define GJCFGridImageByLineGapAndColorWithSize(lineGap,color,size) [GJCFQuickUIUitil gridImageByHoriLineGap:lineGap withVerticalLineGap:lineGap withLineColor:color withImageSize:size]

/**
 *  创建水平网格线图片
 *
 *  @param lineGap 格线距离
 *  @param color   格线颜色
 *  @param size    图片大小
 *
 *  @return 网格线图片
 */
#define GJCFGridImageHorizByLineGapAndColorWithSize(lineGap,color,size) [GJCFQuickUIUitil gridImageHorizonByLineGap:lineGap withLineColor:color withImageSize:size]

/**
 *  创建垂直网格线图片
 *
 *  @param lineGap 格线距离
 *  @param color   格线颜色
 *  @param size    图片大小
 *
 *  @return 网格线图片
 */
#define GJCFGridImageVerticalByLineGapAndColorWithSize(lineGap,color,size) [GJCFQuickUIUitil gridImageVerticalByLineGap:lineGap withLineColor:color withImageSize:size]

/**
 *  快速从文件夹读取图片
 */
#define GJCFQuickImageByFilePath(filePath) [GJCFQuickUIUitil imageWithFilePath:filePath]

/**
 *  快速从归档路径读取图片
 */
#define GJCFQuickUnArchievedImage(filePath) [GJCFQuickUIUitil imageUnArchievedFromFilePath:filePath]

/**
 *  获取拉伸的图片
 *
 *  @param image      原图片
 *  @param leftOffset 左边起始位置
 *  @param topOffset  顶部起始位置
 *
 *  @return 返回拉伸后的图片
 */
#define GJCFImageStrecth(image,leftOffset,topOffset) [GJCFQuickUIUitil stretchImage:image withTopOffset:topOffset withLeftOffset:leftOffset]

/**
 *  获取重设大小拉伸后的图片
 *
 *  @param image  原图片
 *  @param top    顶部起始位置
 *  @param bottom 底部起始位置
 *  @param left   左边起始位置
 *  @param right  右边起始位置
 *
 *  @return 重设大小拉伸后后的图片
 */
#define GJCFImageResize(image,top,bottom,left,right) [GJCFQuickUIUitil resizeImage:image withEdgeTop:top withEdgeBottom:bottom withEdgeLeft:left withEdgeRight:right]

/**
 *  以duration持续时间执行一个UIView动画block
 */
#define GJCFAnimationWithDuration(duration,block) [GJCFQuickUIUitil animationDuration:duration action:block]

/**
 *  延迟second秒，以duration持续时间执行一个UIView动画block
 */
#define GJCFAnimationDelayWithDuration(second,duration,block) [GJCFQuickUIUitil animationDelay:second animationDuration:duration action:block]

/**
 *  默认隐藏显示视图动画
 */
#define GJCFAnimationHiddenShowView(view) [GJCFQuickUIUitil defaultHiddenShowView:view]

/**
 *  指定duration时长隐藏显示动画
 */
#define GJCFAnimationHiddenShowViewDuration(view,duration) [GJCFQuickUIUitil hiddenShowView:view withDuration:duration]

/**
 *  默认显示隐藏视图动画
 */
#define GJCFAnimationShowHiddenView(view) [GJCFQuickUIUitil defaultShowHiddenView:view]

/**
 *  指定duration时长显示隐藏动画
 */
#define GJCFAnimationShowHiddenViewDuration(view,duration) [GJCFQuickUIUitil showHiddenView:view withDuration:duration]

/**
 *  默认隐藏视图动画
 */
#define GJCFAnimationHiddenView(view) [GJCFQuickUIUitil defaultHiddenView:view]

/**
 *  指定duration时长隐藏动画
 */
#define GJCFAnimationHiddenViewDuration(view,duration) [GJCFQuickUIUitil hiddenView:view withDuration:duration]

/**
 *  默认显示视图动画
 */
#define GJCFAnimationShowView(view) [GJCFQuickUIUitil defaultShowView:view]

/**
 *  指定duration时长显示视图动画
 */
#define GJCFAnimationShowViewDuration(view,duration) [GJCFQuickUIUitil showView:view withDuration:duration]

/**
 *  指定duration时间长度，从当前视图alpha到目标alpha
 */
#define GJCFAnimationShowAlphaViewDuration(view,alpha,duration) [GJCFQuickUIUitil showView:view finalAlpha:alpha withDuration:duration]

/**
 *  移动当前视图到指定rect的动画,不支持便捷写法的CGRect  CGRect{20,20,20,20} 这种写法是不支持的需要使用CGRectMake
 */
#define GJCFAnimationMoveViewRect(view,rect,duration) [GJCFQuickUIUitil moveView:view newRect:rect withDuration:duration]

/**
 *  x轴增量移动动画
 */
#define GJCFAnimationMoveViewX(view,xDetal,duration) [GJCFQuickUIUitil moveViewX:view originXDetal:xDetal withDuration:duration]

/**
 *  y轴增量移动动画
 */
#define GJCFAnimationMoveViewY(view,yDetal,duration) [GJCFQuickUIUitil moveViewY:view originYDetal:yDetal withDuration:duration]

/**
 *  width增量变化动画
 */
#define GJCFAnimationMoveViewWidth(view,detal,duration) [GJCFQuickUIUitil moveViewWidth:view widthDetal:detal withDuration:duration]

/**
 *  height增量变化动画
 */
#define GJCFAnimationMoveViewHeight(view,detal,duration) [GJCFQuickUIUitil moveViewHeight:view heightDetal:detal withDuration:duration]

/**
 *  移动到指定x轴点动画
 */
#define GJCFAnimationMoveViewToX(view,toX,duration) [GJCFQuickUIUitil moveViewToX:view toOriginX:toX withDuration:duration]

/**
 *  移动到指定y轴点动画
 */
#define GJCFAnimationMoveViewToY(view,toY,duration) [GJCFQuickUIUitil moveViewToY:view toOriginY:toY withDuration:duration]

/**
 *  指定视图width到目标宽度的动画
 */
#define GJCFAnimationMoveViewToWidth(view,width,duration) [GJCFQuickUIUitil moveViewToWidth:view toWidth:width withDuration:duration]

/**
 *  指定视图height到目标高度的动画
 */
#define GJCFAnimationMoveViewToHeight(view,height,duration) [GJCFQuickUIUitil moveViewToHeight:view toHeight:height withDuration:duration]

/**
 *  移动视图中心动画 不支持便捷写法的CGPoint  (CGPoint){20,20} 这种写法是不支持的需要使用CGPointMake
 */
#define GJCFAnimationMoveViewCenter(view,center,duration) [GJCFQuickUIUitil moveViewCenter:view newCenter:center withDuration:duration]

/**
 *  缩放视图大小动画,不支持便捷写法的CGSize  (CGSize){20,20} 这种写法是不支持的,需要使用CGSizeMake
 */
#define GJCFAnimationMoveViewSize(view,size,duration) [GJCFQuickUIUitil moveViewSize:view newSize:size withDuration:duration]

/**
 *  从左开始翻转视图动画
 */
#define GJCFAnimationLeftFlipView(view,duration,block,completion) [GJCFQuickUIUitil flipViewFromLeft:view withDuration:duration action:block completionBlock:completion]

/**
 *  从右开始翻转视图动画
 */
#define GJCFAnimationRightFlipView(view,duration,block,completion) [GJCFQuickUIUitil flipViewFromRight:view withDuration:duration action:block completionBlock:completion]

/**
 *  从顶部开始翻转视图动画
 */
#define GJCFAnimationTopFlipView(view,duration,block,completion) [GJCFQuickUIUitil flipViewFromTop:view withDuration:duration action:block completionBlock:completion]

/**
 *  从底部开始翻转视图动画
 */
#define GJCFAnimationBottomFlipView(view,duration,block,completion) [GJCFQuickUIUitil flipViewFromBottom:view withDuration:duration action:block completionBlock:completion]

/**
 *  向上翻页动画
 */
#define GJCFAnimationPageUpView(view,duration,block,completion) [GJCFQuickUIUitil pageUpViewFromBottom:view withDuration:duration action:block completionBlock:completion]

/**
 *  向下翻页动画
 */
#define GJCFAnimationPageDownView(view,duration,block,completion) [GJCFQuickUIUitil pageDownViewFromTop:view withDuration:duration action:block completionBlock:completion]

/**
 *  立体翻转动画
 */
#define GJCFAnimationCubeView(view,duration,block,completion) [GJCFQuickUIUitil cubeView:view withDuration:duration  action:block completionBlock:completion]

/**
 *  绕X轴倾斜视图degree角度  degree范围:0-360
 */
#define GJCFAnimationViewRotateX(view,degree,duration) [GJCFQuickUIUitil rotationViewX:view withDegree:degree withDuration:duration]

/**
 *  绕Y轴倾斜视图degree角度  degree范围:0-360
 */
#define GJCFAnimationViewRotateY(view,degree,duration) [GJCFQuickUIUitil rotationViewY:view withDegree:degree withDuration:duration]

/**
 *  绕Z轴倾斜视图degree角度  degree范围:0-360
 */
#define GJCFAnimationViewRotateZ(view,degree,duration) [GJCFQuickUIUitil rotationViewZ:view withDegree:degree withDuration:duration]

/**
 *  translationX动画
 */
#define GJCFAnimationViewTranslationX(view,originX,duration) [GJCFQuickUIUitil translationViewX:view withOriginX:originX withDuration:duration]

/**
 *  translationY动画
 */
#define GJCFAnimationViewTranslationY(view,originY,duration) [GJCFQuickUIUitil translationViewY:view withOriginY:originY withDuration:duration]

/**
 *  translationZ动画
 */
#define GJCFAnimationViewTranslationZ(view,originZ,duration) [GJCFQuickUIUitil translationViewZ:view withOriginZ:originZ withDuration:duration]

/**
 *  scaleX动画
 */
#define GJCFAnimationViewScaleX(view,size,duration) [GJCFQuickUIUitil scaleViewX:view withScaleSize:size withDuration:duration]

/**
 *  scaleY动画
 */
#define GJCFAnimationViewScaleY(view,size,duration) [GJCFQuickUIUitil scaleViewY:view withScaleSize:size withDuration:duration]

/**
 *  scaleZ动画
 */
#define GJCFAnimationViewScaleZ(view,size,duration) [GJCFQuickUIUitil scaleViewZ:view withScaleSize:size withDuration:duration]

/**
 *  将视图绕X轴倾斜degree角度，degree范围 -360到360
 */
#define GJCFView3DRotateX(view,degree) [GJCFQuickUIUitil view3DRotateX:view withDegree:degree]

/**
 *  将视图绕Y轴倾斜degree角度，degree范围 -360到360
 */
#define GJCFView3DRotateY(view,degree) [GJCFQuickUIUitil view3DRotateY:view withDegree:degree]

/**
 *  将视图绕Z轴倾斜degree角度，degree范围 -360到360
 */
#define GJCFView3DRotateZ(view,degree) [GJCFQuickUIUitil view3DRotateZ:view withDegree:degree]

/**
 *  X轴变换
 */
#define GJCFView3DTranslateX(view,value) [GJCFQuickUIUitil view3DTranslateX:view withValue:value]

/**
 *  Y轴变换
 */
#define GJCFView3DTranslateY(view,value) [GJCFQuickUIUitil view3DTranslateY:view withValue:value]

/**
 *  Z轴变换
 */
#define GJCFView3DTranslateZ(view,value) [GJCFQuickUIUitil view3DTranslateZ:view withValue:value]

/**
 *  X轴方向缩放,代表一个缩放比例，一般都是 0 --- 1 之间的数字
 */
#define GJCFView3DScaleX(view,value) [GJCFQuickUIUitil view3DScaleX:view withValue:value]

/**
 *  Y轴方向缩放,代表一个缩放比例，一般都是 0 --- 1 之间的数字
 */
#define GJCFView3DScaleY(view,value) [GJCFQuickUIUitil view3DScaleY:view withValue:value]

/**
 *  Z轴方向缩放,整体比例变换时，也就是m11（sx）== m22（sy）时，若m33（sz）>1，图形整体缩小，若0<1，
 *  图形整体放大，若m33（sz）<0，发生关于原点的对称等比变换
 */
#define GJCFView3DScaleZ(view,value) [GJCFQuickUIUitil view3DScaleZ:view withValue:value]

/**
 *  重复某个block
 */
#define GJCFRepeatAction(repeatBlock) [GJCFQuickUIUitil repeatDoAction:repeatBlock]

/**
 *  延迟second秒开始重复某个动作
 */
#define GJCFRepeatActionDelay(second,repeatBlock) [GJCFQuickUIUitil repeatDoAction:repeatBlock withDelay:second]

/**
 *  重复某个动作duration时长
 */
#define GJCFRepeatActionDuration(duration,repeatBlock) [GJCFQuickUIUitil repeatDoAction:repeatBlock withRepeatDuration:duration]

/**
 *  延迟某个动作second秒，并且只执行duration时长
 */
#define GJCFRepeatActionDelayDuration(second,duration,repeatBlock) [GJCFQuickUIUitil repeatDoAction:repeatBlock withDelay:second withRepeatDuration:duration]

/**
 *  根据blockIdentifier停止某个block重复动作
 */
#define GJCFStopRepeatAction(blockIdentifier) [GJCFQuickUIUitil stopRepeatAction:blockIdentifier]

/**
 *  X轴上以moveXDetal偏移量一个来回,moveXDetal > 0
 */
#define GJCFAnimationViewXCycle(view,moveXDetal,duration) [GJCFQuickUIUitil animationViewXCycle:view withXMoveDetal:moveXDetal withDuration:duration]

/**
 *  Y轴上以moveYDetal偏移量一个来回,moveYDetal > 0
 */
#define GJCFAnimationViewYCycle(view,moveYDetal,duration) [GJCFQuickUIUitil animationViewYCycle:view withYMoveDetal:moveYDetal withDuration:duration]

/**
 *  Z轴上以moveZDetal偏移量一个来回,moveZDetal > 0
 */
#define GJCFAnimationViewZCycle(view,moveZDetal,duration) [GJCFQuickUIUitil animationViewZCycle:view withZMoveDetal:moveZDetal withDuration:duration]

/**
 *  绕X轴上以degree角度为偏移量一个来回,degree: 0-360
 */
#define GJCFAnimationViewRotateXCycle(view,degree,duration) [GJCFQuickUIUitil animationViewRotateXCycle:view withXRotateDetal:degree withDuration:duration]

/**
 *  绕Y轴上以degree角度为偏移量一个来回,degree: 0-360
 */
#define GJCFAnimationViewRotateYCycle(view,degree,duration) [GJCFQuickUIUitil animationViewRotateYCycle:view withYRotateDetal:degree withDuration:duration]

/**
 *  绕Z轴上以degree角度为偏移量一个来回,degree: 0-360
 */
#define GJCFAnimationViewRotateZCycle(view,degree,duration) [GJCFQuickUIUitil animationViewRotateZCycle:view withZRotateDetal:degree withDuration:duration]

/**
 *  fromValue到toValue的position移动CAAnimation
 *  animationKey 为 @"gjcf_animation_position"
 *
 */
#define GJCFCAAnimationPosition(aLayer,fromValue,toValue,repeatCount,duration) [GJCFQuickUIUitil animationLayer:aLayer positionCenterWithFromValue:fromValue withToValue:toValue withRepeatCount:repeatCount  withDuration:duration]

/**
 *  fromValue到toValue的position.x移动CAAnimation
 *  animationKey 为 @"gjcf_animation_position.x"
 */
#define GJCFCAAnimationPositionX(aLayer,fromValue,toValue,repeatCount,duration) [GJCFQuickUIUitil animationLayer:aLayer positionXWithFromValue:fromValue withToValue:toValue withRepeatCount:repeatCount withDuration:duration]

/**
 *  fromValue到toValue的position.y移动CAAnimation
 *  animationKey 为 @"gjcf_animation_position.y"
 */
#define GJCFCAAnimationPositionY(aLayer,fromValue,toValue,repeatCount,duration) [GJCFQuickUIUitil animationLayer:aLayer positionYWithFromValue:fromValue withToValue:toValue withRepeatCount:repeatCount withDuration:duration]

/**
 *  按照value移动postion的CAAnimation
 *  animationKey 为 @"gjcf_animation_by_position"
 */
#define GJCFCAAnimationPositionByValue(aLayer,value,repeatCount,duration) [GJCFQuickUIUitil animationLayer:aLayer positionCenterByValue:value  withRepeatCount:repeatCount  withDuration:duration]

/**
 *  按照value移动postion.x的CAAnimation
 *  animationKey 为 @"gjcf_animation_by_position.x"
 */
#define GJCFCAAnimationPositionXByValue(aLayer,value,repeatCount,duration) [GJCFQuickUIUitil animationLayer:aLayer positionXByValue:value withRepeatCount:repeatCount withDuration:duration]

/**
 *  按照value移动postion.y的CAAnimation
 *  animationKey 为 @"gjcf_animation_by_position.y"
 */
#define GJCFCAAnimationPositionYByValue(aLayer,value,repeatCount,duration) [GJCFQuickUIUitil animationLayer:aLayer positionYByValue:value withRepeatCount:repeatCount withDuration:duration]

/**
 *  按照指定路径做动画
 */
#define GJCFAnimationPathByValue(aLayer,aPath,value,repeatCount,duration) [GJCFQuickUIUitil animationLayer:aLayer path:aPath ByValue:value  withRepeatCount:repeatCount  withDuration:duration]




