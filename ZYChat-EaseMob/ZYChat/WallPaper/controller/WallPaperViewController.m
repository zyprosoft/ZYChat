//
//  ViewController.m
//  瀑布流demo
//
//  Created by yuxin on 15/6/6.
//  Copyright (c) 2015年 yuxin. All rights reserved.
//

#import "WallPaperViewController.h"
#import "ZWCollectionViewFlowLayout.h"
#import "ZWCollectionViewCell.h"
#import "shopModel.h"
#import "GDataXMLNode.h"
#import "MJRefresh.h"
#import "WJItemsControlView.h"

@interface WallPaperViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,ZWwaterFlowDelegate>

@property (nonatomic,strong)UICollectionView * collectView;
@property (nonatomic,strong)NSMutableArray * shops;
@property (nonatomic,assign)NSInteger currentPageIndex;
@property (nonatomic,strong)WJItemsControlView *itemControlView;
@property (nonatomic,strong)NSArray *categories;
@property (nonatomic,strong)NSString *currentCategory;

@end

@implementation WallPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setStrNavTitle:@"图片墙"];
    
    self.currentPageIndex = 1;
    self.shops = [[NSMutableArray alloc]init];
    
    self.categories = @[@"唯美",@"清新",@"主流",@"个性",@"伤感",@"斯基",@"欧美",@"阿狸",@"科比",@"小新",@"小碎花",@"智能",@"龙猫",@"诱惑",@"苹果",@"安卓",@"大屏幕",@"手机",@"三星",@"车模",];
    self.currentCategory = @"唯美";
    
    //头部控制的segMent
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.itemWidth = GJCFSystemScreenWidth/5.0;
    
    _itemControlView = [[WJItemsControlView alloc]initWithFrame:CGRectMake(0,0, GJCFSystemScreenWidth, 40)];
    _itemControlView.tapAnimation = YES;
    _itemControlView.config = config;
    _itemControlView.titleArray = self.categories;
    GJCFWeakSelf weakSelf = self;
    [_itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        weakSelf.currentCategory = weakSelf.categories[index];
        [weakSelf.collectView headerBeginRefreshing];
        
        [weakSelf.itemControlView moveToIndex:index];
        
    }];
    [self.view addSubview:_itemControlView];
    
//注册cell
    ZWCollectionViewFlowLayout *layOut = [[ZWCollectionViewFlowLayout alloc] init];
    layOut.degelate =self;
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, GJCFSystemScreenWidth,GJCFSystemScreenHeight - 64.f - 40.f) collectionViewLayout:layOut];
    self.collectView.delegate =self;
    self.collectView.dataSource =self;
    self.collectView.gjcf_top = 40.f;
    [self.view addSubview:self.collectView];
    [self.collectView registerNib:[UINib nibWithNibName:@"ZWCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    [self addHeader];
    [self addFooter];
}

- (void)addHeader
{
    // 添加下拉刷新头部控件
    GJCFWeakSelf weakSelf = self;
    [self.collectView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        weakSelf.currentPageIndex = 1;
        [weakSelf requestWallList];
        
    } dateKey:@"collection"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    
    [self.collectView headerBeginRefreshing];
}

- (void)addFooter
{
    GJCFWeakSelf weakSelf = self;
    
    // 添加上拉刷新尾部控件
    [self.collectView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        weakSelf.currentPageIndex++;
        
        [weakSelf requestWallList];
        
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZWCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [GJGCCommonFontColorStyle mainThemeColor];
    cell.shop = self.shops[indexPath.item];
    return cell;
}

//代理方法
-(CGFloat)ZWwaterFlow:(ZWCollectionViewFlowLayout *)waterFlow heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPach
{
    if (indexPach.item < 0 || indexPach.item > self.shops.count -1) {
        return 0.f;
    }
    shopModel * shop = self.shops[indexPach.item];
    return shop.h/shop.w*width;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    shopModel * shop = self.shops[indexPath.item];

    if (self.resultBlock) {
        self.resultBlock(shop.img);
    }
}


#pragma mark - 请求网络数据

- (void)requestWallList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       
        NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.3gbizhi.com/tag-%@/%ld.html",GJCFStringEncodeString(self.currentCategory),(long)self.currentPageIndex]]];
        
        NSLog(@"url:%@",[NSString stringWithFormat:@"http://www.3gbizhi.com/tag-%@/%ld.html",GJCFStringEncodeString(@"唯美"),(long)self.currentPageIndex]);
        
        NSString *htmlString = [[NSString alloc]initWithData:htmlData encoding:NSUTF8StringEncoding];
        
        NSLog(@"htmlData:%@",htmlString);

        GDataXMLDocument *htmlDoc = [[GDataXMLDocument alloc]initWithHTMLString:htmlString error:nil];
        
        NSLog(@"htmlDoc :%@",htmlDoc);
        
        NSArray *elements = [htmlDoc nodesForXPath:@"//img" error:nil];
        
        NSLog(@"elememnts:%@",elements);
        
        if (self.currentPageIndex == 1) {
            [self.shops removeAllObjects];
        }
        
        for (GDataXMLElement *node in elements) {
            
            @autoreleasepool {
                
            for (GDataXMLNode *subNode in node.attributes) {
                
                if (!GJCFStringIsNull(subNode.stringValue)) {
                    
                    NSLog(@"stringValue:%@",subNode.stringValue);
                    
                    if ([subNode.stringValue hasPrefix:@"http://"]) {
                        
                        shopModel *item = [[shopModel alloc]init];
                        item.h = 321;
                        item.w = 238;
                        item.img = subNode.stringValue;
                        
                        [self.shops addObject:item];
                        
                    }
                }
             }
           }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectView headerEndRefreshing];
            [self.collectView  footerEndRefreshing];
            
            //reloadData会不起效果iOS7.0 ,用这个方法可以
            [self.collectView reloadSections:[NSIndexSet indexSetWithIndex:0]];

        });

    });
}

@end
