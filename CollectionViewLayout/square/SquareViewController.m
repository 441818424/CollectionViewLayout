//
//  SquareViewController.m
//  CollectionViewLayout
//
//  Created by PAD_Chenxiang_MAC on 2018/1/22.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "SquareViewController.h"
#import "SquareLayout.h"
#import "SquareCollectionViewCell.h"

@interface SquareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/** <#注释#> */
@property (nonatomic,strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic,strong) SquareLayout *layout;

/** <#注释#> */
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation SquareViewController
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
    self.navigationItem.title = @"方形布局";
    
    self.layout = [[SquareLayout alloc] init];
   
   
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SquareCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"squareCell"];
  
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
    SquareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"squareCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.dataArr[indexPath.row]];
    return cell;
}



@end
