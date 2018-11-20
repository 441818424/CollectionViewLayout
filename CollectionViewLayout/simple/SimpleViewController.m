//
//  SimpleViewController.m
//  CollectionViewLayout
//
//  Created by PAD_Chenxiang_MAC on 2018/1/18.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "SimpleViewController.h"
#import "SimpleCollectionViewCell.h"
#import "SimpleHeadViewCollectionReusableView.h"
#import "SimpleFootViewCollectionReusableView.h"

@interface SimpleViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/** <#注释#> */
@property (nonatomic,strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
/** <#注释#> */
@property (nonatomic,strong) NSMutableArray *dataArr;



@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = CGSizeMake(80, 80);
    self.flowLayout.minimumLineSpacing = 10;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.headerReferenceSize = CGSizeMake(60, 40);
    self.flowLayout.footerReferenceSize = CGSizeMake(60, 40);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"simpleCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleHeadViewCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"simpleHead"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SimpleFootViewCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"simpleFoot"];
    
    self.dataArr = [NSMutableArray array];
    
    for (int i = 0; i < 50; i++) {
        CGSize size = CGSizeMake(arc4random() % 20 + 20, arc4random() % 20 + 30);
        NSValue *value = [NSValue valueWithCGSize:size];
        
        [self.dataArr addObject:value];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.collectionView addGestureRecognizer:longPress];
    
    [self.view addSubview:self.collectionView];
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
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:self.collectionView]];
          
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

#pragma mark --- delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;

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
//设置是否可以选中cell
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//设置是否支持高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//设置高亮颜色
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];

}
//取消高亮颜色
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}

//是否展示菜单
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"cut:"]) {
        return YES;
    }else if ([NSStringFromSelector(action) isEqualToString:@"copy:"]){
        return YES;
    }else if ([NSStringFromSelector(action) isEqualToString:@"paste:"]){
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender
{
        NSLog(@"点击了%@事件",NSStringFromSelector(action));
//          if ([NSStringFromSelector(action) isEqualToString:@"cut:"]) {
//              [self.dataArr removeObjectAtIndex:indexPath.row];
//              [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
//          }else if ([NSStringFromSelector(action) isEqualToString:@"copy:"]){
//              [self.dataArr insertObject:self.dataArr[indexPath.row] atIndex:indexPath.row];
//              [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
//          }else if ([NSStringFromSelector(action) isEqualToString:@"paste:"]){
//             
//          }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    NSValue *value = self.dataArr[sourceIndexPath.item];
    [self.dataArr removeObjectAtIndex:sourceIndexPath.row];
    [self.dataArr insertObject:value atIndex:destinationIndexPath.item];
    NSLog(@"from %ld  to:%ld",sourceIndexPath.row,destinationIndexPath.row);
}




@end
