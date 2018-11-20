//
//  MainViewController.m
//  CollectionViewLayout
//
//  Created by PAD_Chenxiang_MAC on 2018/1/18.
//  Copyright © 2018年 Tianwen. All rights reserved.
//

#import "MainViewController.h"
#import "SimpleViewController.h"
#import "WaterViewController.h"
#import "SquareViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

/** <#注释#> */
@property (nonatomic,strong) UITableView *tableView;
/**  */
@property (nonatomic,strong) NSArray *dataArr;



@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.dataArr = @[@"UICollectionView基础使用",@"瀑布流",@"方形布局"];
    [self setupTableView];
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

}

#pragma mark ---- delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SimpleViewController *vc = [[SimpleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        WaterViewController *vc = [[WaterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SquareViewController *vc = [[SquareViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
