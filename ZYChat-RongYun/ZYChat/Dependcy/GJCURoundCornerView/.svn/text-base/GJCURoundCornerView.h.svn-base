//
//  GJCURoundCornerView.h
//  GJCoreUserInterface
//
//  Created by ZYVincent on 14-11-4.
//  Copyright (c) 2014年 ganji. All rights reserved.
//

/*
 * 代码原作者:Tomasz Kuźma
 * 为避免引用冲突改名加入到本地库
 *
 */

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, GJCURoundedCorner) {
    GJCURoundedCornerNone         = 0,
    GJCURoundedCornerTopRight     = 1 <<  0,
    GJCURoundedCornerBottomRight  = 1 <<  1,
    GJCURoundedCornerBottomLeft   = 1 <<  2,
    GJCURoundedCornerTopLeft      = 1 <<  3,
};

typedef NS_OPTIONS(NSUInteger, GJCUDrawnBorderSides) {
    GJCUDrawnBorderSidesNone      = 0,
    GJCUDrawnBorderSidesRight     = 1 <<  0,
    GJCUDrawnBorderSidesLeft      = 1 <<  1,
    GJCUDrawnBorderSidesTop       = 1 <<  2,
    GJCUDrawnBorderSidesBottom    = 1 <<  3,
};

typedef NS_ENUM(NSInteger, GJCUGradientDirection) {
    GJCUGradientDirectionHorizontal,
    GJCUGradientDirectionVertical,
    GJCUGradientDirectionUp,
    GJCUGradientDirectionDown,
};

extern const GJCURoundedCorner GJCURoundedCornerAll;
extern const GJCUDrawnBorderSides GJCUDrawnBorderSidesAll;

UIImage * GJCURoundedCornerImage(CGSize size,
                               GJCURoundedCorner corners,
                               GJCUDrawnBorderSides drawnBorders,
                               UIColor *fillColor,
                               UIColor *borderColor,
                               CGFloat borderWidth,
                               CGFloat cornerRadius);

@interface GJCURoundCornerView : UIView

/* Which borders should be drawn - default GJCUDrawnBordersSidesAll - only not rounded borders can *NOT* be drawn atm  */
@property (nonatomic, assign) GJCUDrawnBorderSides drawnBordersSides;

/* Which corners should be rounded - default GJCURoundedCornerAll */
@property (nonatomic, assign) GJCURoundedCorner roundedCorners;

/* Fill color of the figure - default white */
@property (nonatomic, strong) UIColor *fillColor;

/* Stroke color for the figure, default is light gray */
@property (nonatomic, strong) UIColor *borderColor;

/* Border line width, default 1.0f */
@property (nonatomic, assign) CGFloat borderWidth;

/* Corners radius , default 15.0f */
@property (nonatomic, assign) CGFloat cornerRadius;

/* Direction of the gradient [options -, |,  /,  \] (if there will be a gradient drawn), default vertical  */
@property (nonatomic, assign) GJCUGradientDirection gradientDirection;

/* NSArray of NSDictionaries with NSNumber with color's locations and the UIColor object, default nil  */
@property (nonatomic, strong) NSArray *gradientColorsAndLocations;

@end