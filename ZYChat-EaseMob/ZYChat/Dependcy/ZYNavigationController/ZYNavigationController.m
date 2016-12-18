//
//  ZYNavigationController.m
//  ZYNavigationController
//
//  Created by ZYVincent on 15-7-15.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "ZYNavigationController.h"
#import "GJCFUitils.h"

#define kZYNavigationControllerHasShowDragBackUDF @"kZYNavigationControllerHasShowDragBackUDF"

@interface ZYNavigationController ()

@property (nonatomic,assign)CGPoint startPoint;

@property (nonatomic,strong)UIImageView *lastScreenShotView;

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic, strong) NSMutableArray *screenShotList;

@property (nonatomic, assign) BOOL isMoving;

@end

static CGFloat offset_float = 0.65;// 拉伸参数
static CGFloat min_distance = 100;// 最小回弹距离

@implementation ZYNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认允许右滑返回
    self.canDragBack = YES;
    
    //添加拖拽手势
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    
    [self.view addGestureRecognizer:recognizer];
    
}

#pragma mark - theme

- (void)setType:(ZYResourceType)type
{
    NSString *imgName = nil;
    switch (type) {
        case ZYResourceTypeRecent:
            imgName = kThemeRecentNavBar;
            break;
        case ZYResourceTypeSquare:
            imgName = kThemeSquareNavBar;
            break;
        case ZYResourceTypeHome:
            imgName = kThemeHomeNavBar;
            break;
        default:
            break;
    }
    [self.navigationBar setBackgroundImage:ZYThemeImage(imgName) forBarMetrics:UIBarMetricsDefault];
}

- (NSMutableArray *)screenShotList {
    
    if (!_screenShotList) {
        _screenShotList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return _screenShotList;
}

#pragma mark - UINavigationController 方法重载

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    [self.screenShotList removeLastObject];
    
    return [super popViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 1) {
        [self.screenShotList addObject:GJCFScreenShotFromView(self.view)];
    } else {
        UIViewController *firstVC = self.viewControllers.firstObject;
        UIImage *rootScreenShot = GJCFScreenShotFromView(firstVC.tabBarController.view);
        
        //取不到tabbarController的截图就取自身得截图
        if (!rootScreenShot) {
            rootScreenShot = GJCFScreenShotFromView(self.view);
        }
        [self.screenShotList addObject:rootScreenShot];
    }
    [super pushViewController:viewController animated:animated];
    
    
    BOOL isShowFirst = [GJCFUDFGetValue(kZYNavigationControllerHasShowDragBackUDF) boolValue];
    if (!isShowFirst && self.canDragBack) {
        [self performSelector:@selector(addDragBackGuideView) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    }
}

/**
 *  添加一个拖拽返回引导
 */
- (void)addDragBackGuideView
{
    
}

- (void) popAnimation {
    
    //一个不能做返回动作
    if (self.viewControllers.count == 1) {
        
        return;
    }
    
    if (!self.backGroundView) {
        
        CGRect frame = self.view.frame;
        
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        
        _backGroundView.backgroundColor = [UIColor redColor];
        
        //把这个贴在要返回得视图下面，然后把截图贴上去，这样就看上去就像前一屏能被看到得效果
        [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
    }
    
    _backGroundView.hidden = NO;
    
    if (self.lastScreenShotView) [self.lastScreenShotView removeFromSuperview];
    
    UIImage *lastScreenShot = [self.screenShotList lastObject];
    
    self.lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    
    self.lastScreenShotView.frame = (CGRect){-(GJCFSystemScreenWidth*offset_float),0,GJCFSystemScreenWidth,GJCFSystemScreenHeight};
    
    [self.backGroundView addSubview:self.lastScreenShotView];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self moveViewWithX:GJCFSystemScreenWidth];
        
    } completion:^(BOOL finished) {

        [self gestureAnimation:NO];
        
        self.view.gjcf_left = 0;
        
        _isMoving = NO;
        
        self.backGroundView.hidden = YES;
        
    }];
}

- (void)gestureAnimation:(BOOL)animated {
    
    [self.screenShotList removeLastObject];
    
    [super popViewControllerAnimated:animated];
    
}

// 动态改变前一个截图和当前视图得位置关系
- (void)moveViewWithX:(float)x
{
    x = x > GJCFSystemScreenWidth?GJCFSystemScreenWidth : x;
    
    x = x < 0? 0 : x;
    
    self.view.gjcf_left = x;
    
    self.lastScreenShotView.frame = (CGRect){-(GJCFSystemScreenWidth*offset_float)+x*offset_float,0,GJCFSystemScreenWidth,GJCFSystemScreenHeight};
}

#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // 不允许拖拽手势得话，啥都不做
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // 拿到应用窗口得触摸事件
    CGPoint touchPoint = [recoginzer locationInView:[UIApplication sharedApplication].keyWindow];
    
    // 把前一个视图得截图显示出来，用来制造拖拽返回的效果
    switch (recoginzer.state) {
        case UIGestureRecognizerStateBegan:
        {
            _isMoving = YES;
            
            self.startPoint = touchPoint;
            
            CGRect frame = self.view.frame;
            
            if (!_backGroundView) {
                
                _backGroundView = [[UIView alloc]init];
                
                _backGroundView.backgroundColor = [UIColor redColor];
                
            }
            
            _backGroundView.frame = CGRectMake(0, 0, frame.size.width , frame.size.height);
            
            [self.view.superview insertSubview:self.backGroundView belowSubview:self.view];
            
            _backGroundView.hidden = NO;
            
            if (self.lastScreenShotView) [self.lastScreenShotView removeFromSuperview];
            
            UIImage *lastScreenShot = [self.screenShotList lastObject];
            
            self.lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
            
            self.lastScreenShotView.frame = (CGRect){-(GJCFSystemScreenWidth*offset_float),0,GJCFSystemScreenWidth,GJCFSystemScreenHeight};
            
            [self.backGroundView addSubview:self.lastScreenShotView];

        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //触摸改变位置
            if (_isMoving) {
                
                [self moveViewWithX:touchPoint.x - self.startPoint.x];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (touchPoint.x - self.startPoint.x > min_distance)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    [self moveViewWithX:GJCFSystemScreenWidth];
                    
                } completion:^(BOOL finished) {
                    
                    [self gestureAnimation:NO];
                    
                    self.view.gjcf_left = 0.f;
                    
                    _isMoving = NO;
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    [self moveViewWithX:0];
                    
                } completion:^(BOOL finished) {
                    
                    _isMoving = NO;
                    
                    self.backGroundView.hidden = YES;
                    
                }];
                
            }

        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                [self moveViewWithX:0];
                
            } completion:^(BOOL finished) {
                
                _isMoving = NO;
                
                self.backGroundView.hidden = YES;
                
            }];

        }
            break;
        default:
            break;
    }
}


@end
