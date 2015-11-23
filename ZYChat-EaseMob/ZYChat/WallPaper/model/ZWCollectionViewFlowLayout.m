//
//  ZWCollectionViewFlowLayout.m
//  瀑布流demo
//
//  Created by yuxin on 15/6/6.
//  Copyright (c) 2015年 yuxin. All rights reserved.
//

#import "ZWCollectionViewFlowLayout.h"
////列间距
//static const CGFloat columMargin = 10;
////行间距
//static const CGFloat rowMagin = 10;

@interface ZWCollectionViewFlowLayout()
@property(nonatomic,retain)NSMutableDictionary * maxYdic;
@end
@implementation ZWCollectionViewFlowLayout
-(NSMutableDictionary *)maxYdic
{
    if (!_maxYdic) {
        self.maxYdic = [[NSMutableDictionary alloc] init];
            }
    return _maxYdic;
}
-(instancetype)init
{
    if (self=[super init]) {
        self.colMagrin = 10;
        self.rowMagrin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.colCount = 3;
    }
    return self;
}
-(void)prepareLayout
{
    [super prepareLayout];
  

}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
-(CGSize)collectionViewContentSize
{
    __block NSString * maxCol = @"0";
    //找出最短的列
    [self.maxYdic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue]>[self.maxYdic[maxCol] floatValue]) {
            maxCol = column;
        }
    }];
    return CGSizeMake(0, [self.maxYdic[maxCol] floatValue]);
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
   __block NSString * minCol = @"0";
//找出最短的列
    [self.maxYdic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue]<[self.maxYdic[minCol] floatValue]) {
            minCol = column;
        }
}];
//    计算宽度
    CGFloat width = (self.collectionView.frame.size.width-self.sectionInset.left-self.sectionInset.right-(self.colCount-1)*self.colMagrin)/self.colCount;
//    计算高度
    CGFloat hight = [self.degelate ZWwaterFlow:self heightForWidth:width atIndexPath:indexPath];
//    CGFloat hight =100+arc4random_uniform(100);
    CGFloat x = self.sectionInset.left + (width+ self.colMagrin)* [minCol intValue];
    CGFloat y =[self.maxYdic[minCol] floatValue]+self.rowMagrin;
//    跟新最大的y值
    self.maxYdic[minCol] = @(y+hight);
    
//    计算位置
    UICollectionViewLayoutAttributes * attri =[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.frame = CGRectMake(x, y, width, hight);
    return attri;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    for(int i = 0;i<self.colCount;i++)
    {
        NSString * col = [NSString stringWithFormat:@"%d",i];
        self.maxYdic[col] = @0;
    }
    
    
    NSMutableArray * array = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];
    }
    return  array;
}
@end
