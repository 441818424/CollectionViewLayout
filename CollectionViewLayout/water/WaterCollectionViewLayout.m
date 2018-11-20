//
//  WaterCollectitionViewLayout.m
//  CollectionViewLayout
//
//  Created by PAD_Chenxiang_MAC on 2018/1/19.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "WaterCollectionViewLayout.h"
@interface WaterCollectionViewLayout()
/** 保存cell的布局 */
@property (nonatomic,strong) NSMutableDictionary *cellLayoutInfo;
/** 保存头部视图布局 */
@property (nonatomic,strong) NSMutableDictionary *headLayoutInfo;
/** 保存尾部视图布局 */
@property (nonatomic,strong) NSMutableDictionary *footLayoutInfo;

/** 记录开始的y值 */
@property (nonatomic,assign) CGFloat startY;
/** 记录瀑布流每列最底部那个cell的y值 */
@property (nonatomic,strong) NSMutableDictionary *maxYForColumn;
/** 记录需要添加动画的NSIndexPath */
@property (nonatomic,strong) NSMutableArray *shouldAnimationIndexPaths;


@end
@implementation WaterCollectionViewLayout

- (instancetype)init
{
    if (self = [super init]) {
        self.numberOfColums = 3;
        self.topAndBottomSpacing = 10;
        self.cellSpacing = 10;
        self.headerViewHeight = 0;
        self.footerViewHeight = 0;
        self.startY = 0;
        self.maxYForColumn = [NSMutableDictionary dictionary];
        self.shouldAnimationIndexPaths = [NSMutableArray array];
        self.cellLayoutInfo = [NSMutableDictionary dictionary];
        self.headLayoutInfo = [NSMutableDictionary dictionary];
        self.footLayoutInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //重新布局需要清空
    [self.cellLayoutInfo removeAllObjects];
    [self.headLayoutInfo removeAllObjects];
    [self.footLayoutInfo removeAllObjects];
    [self.maxYForColumn removeAllObjects];
    self.startY = 0;
    
    CGFloat viewWidth = self.collectionView.frame.size.width;
    CGFloat itemWith = (viewWidth - self.cellSpacing * (self.numberOfColums + 1)) / self.numberOfColums;
    
    //取出有多少个组
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        //存储headView属性
        NSIndexPath *supplementaryViewIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        //头视图的高度不为0，并且响应设置头视图的代理方法，添加对应的头视图布局对象
        if (self.headerViewHeight > 0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:supplementaryViewIndexPath];
            
            //设置头视图的frame
            attribute.frame = CGRectMake(0, self.startY, self.collectionView.frame.size.width, self.headerViewHeight);
            //保存布局对象
            self.headLayoutInfo[supplementaryViewIndexPath] = attribute;
            //设置下个布局对象的开始y值
            self.startY = self.startY + self.headerViewHeight + self.topAndBottomSpacing;
            
            
        }else{
        //没有头部视图的时候，也要设置section的第一排cell到顶部的距离
            self.startY += self.topAndBottomSpacing;
        }
        
        //将section第一排cell的frame的Y值进行设置
        for (int i = 0; i < self.numberOfColums; i++) {
            self.maxYForColumn[@(i)] = @(self.startY);
        }
        
        //计算cell的布局
        //取出section有多少row
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        //分别设置每个cell的布局对象
        for (NSInteger row = 0; row < rows; row++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
            //计算当前cell加到哪一行（瀑布流加到最短的一列）
            //拿到第一列的值
            CGFloat y = [self.maxYForColumn[@(0)] floatValue];
            NSInteger currentColumn = 0;
            for (int i = 1; i < self.numberOfColums; i++) {
                if ([self.maxYForColumn[@(i)] floatValue] < y) {
                    y = [self.maxYForColumn[@(i)] floatValue];
                    currentColumn = i;
                }
            }
            //计算x值
            CGFloat x = self.cellSpacing + (itemWith + self.cellSpacing) * currentColumn;
            //根据代理取当前cell的高度，高度根据图片的原始宽高比进行设置的
            CGFloat height = [self.delegate collectionView:self.collectionView layout:self heightOfItemAtIndexPath:cellIndexPath itemWidth:itemWith];
            //设置当前cell的布局对象的frame
            attribute.frame = CGRectMake(x, y, itemWith, height);
            //重新设置当前列的y值
            y = y + self.cellSpacing + height;
            self.maxYForColumn[@(currentColumn)] = @(y);
            //保存cell的布局对象
            self.cellLayoutInfo[cellIndexPath] = attribute;
            
            //当到达section的最后一个cell时，取出最后一排的底部y值设置为startY，决定下个视图对象的起始Y值
            if (row == rows - 1) {
                CGFloat maxY = [self.maxYForColumn[@(0)] floatValue];
                for (int i = 1; i < self.numberOfColums; i++) {
                    if ([self.maxYForColumn[@(i)] floatValue] > maxY) {
                        maxY = [self.maxYForColumn[@(i)] floatValue];
                    }
                }
                self.startY = maxY - self.cellSpacing + self.topAndBottomSpacing;
            }
        }
        
        //存储footView属性
        if (self.footerViewHeight > 0 && [self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:supplementaryViewIndexPath];
            attribute.frame = CGRectMake(0, self.startY, self.collectionView.frame.size.width, self.footerViewHeight);
            self.footLayoutInfo[supplementaryViewIndexPath] = attribute;
            self.startY += self.footerViewHeight;
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    //添加当前屏幕可见的cell的布局
    [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) { //如果两个矩阵交叉
            [allAttributes addObject:attribute];
        }
    }];

    //添加当前屏幕可见的头视图的布局
    [self.headLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) { //如果两个矩阵交叉
            [allAttributes addObject:attribute];
        }
    }];
    //添加当前屏幕可见的尾视图的布局
    [self.footLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attribute.frame)) { //如果两个矩阵交叉
            [allAttributes addObject:attribute];
        }
    }];
    
    return allAttributes;
}
//插入cell的时候系统自动调用
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = self.cellLayoutInfo[indexPath];
    return attribute;

}
//- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, MAX(self.startY, self.collectionView.frame.size.height));
}

//对应UICollectionViewUpdateItem 的indexPathBeforeUpdate 设置调用
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    
    if ([self.shouldAnimationIndexPaths containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes *attr = self.cellLayoutInfo[itemIndexPath];
        
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        attr.alpha = 1;
        [self.shouldAnimationIndexPaths removeObject:itemIndexPath];
        return attr;
    }
    return nil;
}

//对应UICollectionViewUpdateItem 的indexPathAfterUpdate 设置调用
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if ([self.shouldAnimationIndexPaths containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes *attr = self.cellLayoutInfo[itemIndexPath];
        
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(2, 2), 0);
        //        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        attr.alpha = 0;
        [self.shouldAnimationIndexPaths removeObject:itemIndexPath];
        return attr;
    }
    return nil;
}

- (void)finalizeCollectionViewUpdates
{
    self.shouldAnimationIndexPaths = nil;
}

@end



