//
//  QiuGouViewController.m
//  农家帮
//
//  Created by 赵波 on 16/3/8.
//  Copyright © 2016年 jingqi. All rights reserved.
//

#import "QiuGouViewController.h"
#import "XinJianQiuGouViewController.h"

@interface QiuGouViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation QiuGouViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我的求购信息";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadViews {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"新建", @"") style:UIBarButtonItemStylePlain target:self action:@selector(xinJian)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height- 64) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setTableFooterView:[UIView new]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = BaseColor(245, 245, 245, 1);
    [self.view addSubview:tableView];
}

- (void)xinJian {
    
    XinJianQiuGouViewController *xvc = [[XinJianQiuGouViewController alloc] init];
    
    [self.navigationController pushViewController:xvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
