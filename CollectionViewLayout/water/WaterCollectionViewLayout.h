//
//  WaterCollectitionViewLayout.h
//  CollectionViewLayout
//
//  Created by PAD_Chenxiang_MAC on 2018/1/19.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterCollectionViewLayout;
@protocol WaterCollectionViewLayoutDelegate <NSObject>

//取cell的高
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterCollectionViewLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;



@end

@interface WaterCollectionViewLayout : UICollectionViewLayout

/** 瀑布流的列数 */
@property (nonatomic,assign) NSInteger numberOfColums;
/** cell之间的间距 */
@property (nonatomic,assign) CGFloat cellSpacing;
/** cell到顶部和底部的距离 */
@property (nonatomic,assign) CGFloat topAndBottomSpacing;
/** 头视图的高度 */
@property (nonatomic,assign) CGFloat headerViewHeight;
/** 尾视图的高度 */
@property (nonatomic,assign) CGFloat footerViewHeight;

/** 代理 */
@property (nonatomic,assign) id<WaterCollectionViewLayoutDelegate> delegate;


@end
