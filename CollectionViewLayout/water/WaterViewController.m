//
//  WaterViewController.m
//  CollectionViewLayout
//
//  Created by PAD_Chenxiang_MAC on 2018/1/19.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "WaterViewController.h"
#import "WaterCollectionViewLayout.h"
#import "WaterCollectionViewCell.h"
#import "SimpleHeadViewCollectionReusableView.h"
#import "SimpleFootViewCollectionReusableView.h"


@interface WaterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WaterCollectionViewLayoutDelegate>
/** <#注释#> */
@property (nonatomic,strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic,strong) WaterCollectionViewLayout *layout;

/** <#注释#> */
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation WaterViewController

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (int i = 0; i <= 100; i++) {
            [_dataArr addObject:[NSString stringWithFormat:@"%d.jpg",i%20]];
        }
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"瀑布流";
    
    self.layout = [[WaterCollectionViewLayout alloc] init];
    self.layout.headerViewHeight = 100;
    self.layout.footerViewHeight = 60;
    self.layout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WaterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"waterCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleHeadViewCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simpleHead"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleFootViewCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"simpleFoot"];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.collectionView addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *touchIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            if (touchIndexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:touchIndexPath];
            }else{
                break;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
        }
            break;
        default:
            break;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SimpleHeadViewCollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simpleHead" forIndexPath:indexPath];
        return head;
    }else{
        SimpleFootViewCollectionReusableView *foot =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"simpleFoot" forIndexPath:indexPath];
        return foot;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    cell.contentView.alpha = 0;
    cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0, 0), 0);
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
         //分布动画 第一个动画是该动画开始的百分比时间
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.8 animations:^{
            cell.contentView.alpha = 0.5;
            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.2, 1.2), 0);
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            cell.contentView.alpha = 1;
            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0);
        }];
    } completion:^(BOOL finished) {
        
    }];
 
    

}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    NSValue *value = self.dataArr[sourceIndexPath.item];
    [self.dataArr removeObjectAtIndex:sourceIndexPath.row];
    [self.dataArr insertObject:value atIndex:destinationIndexPath.item];
    NSLog(@"from %ld  to:%ld",sourceIndexPath.row,destinationIndexPath.row);
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waterCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.dataArr[indexPath.row]];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (UIImage *)imageAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIImage imageNamed:[self.dataArr objectAtIndex:indexPath.row]];

}
#pragma mark --- WaterCollectionViewLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WaterCollectionViewLayout *)layout heightOfItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    return  itemWidth / [self imageAtIndexPath:indexPath].size.width * [self imageAtIndexPath:indexPath].size.height;

}
@end
