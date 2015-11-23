//
//  WJItemsControlView.m
//  SliderSegment
//
//  Created by silver on 15/11/3.
//  Copyright (c) 2015年 Fsilver. All rights reserved.
//

#import "WJItemsControlView.h"


@implementation WJItemsConfig

-(id)init
{
    self = [super init];
    if(self){
        
        _itemWidth = 0;
        _itemFont = [UIFont boldSystemFontOfSize:16];
        _textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1];
        _selectedColor = [UIColor colorWithRed:61/255.0 green:209/255.0 blue:165/255.0 alpha:1];
        _linePercent = 0.8;
        _lineHieght = 2.5;
    }
    return self;
}

@end


@interface WJItemsControlView()

@property(nonatomic,strong)UIView *line;


@end


@implementation WJItemsControlView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.tapAnimation = YES;
        
    }
    return self;
}

-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    if(!_config){
        NSLog(@"请先设置config");
        return;
    }
    
    float x = 0;
    float y = 0;
    float width = _config.itemWidth;
    float height = self.frame.size.height;
    
    for (int i=0; i<titleArray.count; i++) {
        
         x = _config.itemWidth*i;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
        btn.tag = 100+i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_config.textColor forState:UIControlStateNormal];
        btn.titleLabel.font = _config.itemFont;
        [btn addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if(i==0){

           [btn setTitleColor:_config.selectedColor forState:UIControlStateNormal];
            _currentIndex = 0;
            self.line = [[UIView alloc] initWithFrame:CGRectMake(_config.itemWidth*(1-_config.linePercent)/2.0, CGRectGetHeight(self.frame) - _config.lineHieght, _config.itemWidth*_config.linePercent, _config.lineHieght)];
            _line.backgroundColor = _config.selectedColor;
            [self addSubview:_line];
        }
    }
    
    self.contentSize = CGSizeMake(width*titleArray.count, height);
}


#pragma mark - 点击事件

-(void)itemButtonClicked:(UIButton*)btn
{
    //接入外部效果
    _currentIndex = btn.tag-100;
    
    if(_tapAnimation){
        
        //有动画，由call is scrollView 带动线条，改变颜色
        
        
    }else{
        
        //没有动画，需要手动瞬移线条，改变颜色
        [self changeItemColor:_currentIndex];
        [self changeLine:_currentIndex];
    }
    
    [self changeScrollOfSet:_currentIndex];
    
    if(self.tapItemWithIndex){
        _tapItemWithIndex(_currentIndex,_tapAnimation);
    }
    
    
}


#pragma mark - Methods

//改变文字焦点
-(void)changeItemColor:(NSInteger)index
{
    for (int i=0; i<_titleArray.count; i++) {
        
        UIButton *btn = (UIButton*)[self viewWithTag:i+100];
        [btn setTitleColor:_config.textColor forState:UIControlStateNormal];
        if(btn.tag == index+100){
            [btn setTitleColor:_config.selectedColor forState:UIControlStateNormal];
        }
    }
}

//改变线条位置
-(void)changeLine:(float)index
{
    CGRect rect = _line.frame;
    rect.origin.x = index*_config.itemWidth + _config.itemWidth*(1-_config.linePercent)/2.0;
    _line.frame = rect;
}


//向上取整
- (NSInteger)changeProgressToInteger:(float)x
{
    
    float max = _titleArray.count;
    float min = 0;
    
    NSInteger index = 0;
    
    if(x< min+0.5){
        
        index = min;
        
    }else if(x >= max-0.5){
        
        index = max;
        
    }else{
        
        index = (x+0.5)/1;
    }
    
    return index;
}


//移动ScrollView
-(void)changeScrollOfSet:(NSInteger)index
{
    float  halfWidth = CGRectGetWidth(self.frame)/2.0;
    float  scrollWidth = self.contentSize.width;
    
    float leftSpace = _config.itemWidth*index - halfWidth + _config.itemWidth/2.0;
    
    if(leftSpace<0){
        leftSpace = 0;
    }
    if(leftSpace > scrollWidth- 2*halfWidth){
        leftSpace = scrollWidth-2*halfWidth;
    }
    [self setContentOffset:CGPointMake(leftSpace, 0) animated:YES];
}



#pragma mark - 在ScrollViewDelegate中回调
-(void)moveToIndex:(float)x
{
    [self changeLine:x];
    NSInteger tempIndex = [self changeProgressToInteger:x];
    if(tempIndex != _currentIndex){
        //保证在一个item内滑动，只执行一次
        [self changeItemColor:tempIndex];
    }
    _currentIndex = tempIndex;
}

-(void)endMoveToIndex:(float)x
{
    [self changeLine:x];
    [self changeItemColor:x];
    _currentIndex = x;
    
    [self changeScrollOfSet:x];
}





@end















































