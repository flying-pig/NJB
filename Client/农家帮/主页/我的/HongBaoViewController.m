//
//  HongBaoViewController.m
//  农家帮
//
//  Created by Mac on 16/3/25.
//  Copyright © 2016年 jingqi. All rights reserved.
//

#import "HongBaoViewController.h"
#import "HongBaoYouxiaoTableViewCell.h"
#import "MyConfirmBaseButton.h"
#import "HongBaoShiYongTableViewCell.h"
#import "HongBaoGuoQiTableViewCell.h"
#import "AddHongBaoViewController.h"
#import "SenderHongBaoViewController.h"
#import "MJRefresh.h"
@interface HongBaoViewController ()<UITableViewDataSource, UITableViewDelegate, MJRefreshBaseViewDelegate>

@end

@implementation HongBaoViewController
{
    UITableView * _tableView;
    NSMutableArray * _dataArrayOfYouXiao;
    NSMutableArray * _dataArrayOfshiyong;
    NSMutableArray * _dataArrayOfguoqi;
    MyConfirmBaseButton * _youxiaozhong;
    MyConfirmBaseButton * _yishiyong;
    MyConfirmBaseButton * _yiguoqi;
    UIView * _lowLineView;//button被电击之后的下划线
    
    UIButton * _AddHongBaoButton;
    
    MJRefreshHeaderView * _headerRefreshView;
    MJRefreshFooterView * _footerRefreshView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"我的红包", @"");
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [button addTarget:self action:@selector(leftBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self chuangjiansangeanniu];
    [self createAddHongBaoAnniu];
    [self ADDRefresh];
    [self requestData];
    // Do any additional setup after loading the view.
}


- (void)ADDRefresh
{
    _headerRefreshView = [MJRefreshHeaderView header];
    _footerRefreshView = [MJRefreshFooterView footer];
    _footerRefreshView.delegate = self;
    _headerRefreshView.delegate = self;
    
    _headerRefreshView.scrollView = _tableView;
    _footerRefreshView.scrollView = _tableView;
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _headerRefreshView) {
        [self requestData];
    }
    if (refreshView == _footerRefreshView) {
        [self requestData];
    }
}

- (void)requestData
{
    [[JudgeNetState shareInstance] monitorNetworkType:self.view complete:^(NSInteger state) {
        
        if (state == 1 || state == 2) {
            
            JQBaseRequest * jq = [[JQBaseRequest alloc]init];
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            
            [jq ChaXunMaiJia4PuTongHongBaoListWithProducerId:[NSString stringWithFormat:@"%@", [user objectForKey:@"ProducerId"]] complete:^(NSDictionary *responseObject) {
                _dataArrayOfYouXiao = [[NSMutableArray alloc]init];
                _dataArrayOfshiyong = [[NSMutableArray alloc]init];
                _dataArrayOfguoqi = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in responseObject[@"List"]) {
                    if ([[NSString stringWithFormat:@"%@", dict[@"type"]]isEqualToString:@"0"] == YES) {
                        [_dataArrayOfYouXiao addObject:dict];
                    }
                    if ([[NSString stringWithFormat:@"%@", dict[@"type"]]isEqualToString:@"1"] == YES) {
                        [_dataArrayOfshiyong addObject:dict];
                    }
                    if ([[NSString stringWithFormat:@"%@", dict[@"type"]]isEqualToString:@"2"] == YES) {
                        [_dataArrayOfguoqi addObject:dict];
                    }
                }
                
                [_tableView reloadData];
                [_headerRefreshView endRefreshing];
                [_footerRefreshView endRefreshing];
                
            } fail:^(NSError *error, NSString *errorString) {
                
            }];
        }
    }];
}
//ios9 在使用刷新的时候切记释放
-(void)dealloc {
    
    [_headerRefreshView free];
    [_footerRefreshView free];
}


//创建红包添加按钮
- (void)createAddHongBaoAnniu
{
     _AddHongBaoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, Screen_Height - 88 * scaleHeight - 64, Screen_Width, 88 * scaleHeight)];
    [_AddHongBaoButton setBackgroundImage:[UIImage imageNamed:@"zjhh_btn_queding _down.png"] forState:UIControlStateNormal];
    [_AddHongBaoButton setTitleColor:BaseColor(255, 255, 255, 1) forState:UIControlStateNormal];
    [_AddHongBaoButton setTitle:@"增加红包" forState:UIControlStateNormal];
    [self.view addSubview:_AddHongBaoButton];
    [_AddHongBaoButton addTarget:self action:@selector(AddHongBaoButtonClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)AddHongBaoButtonClick
{
    AddHongBaoViewController * avc = [[AddHongBaoViewController alloc]init];
    [self.navigationController pushViewController:avc animated:YES];
}

//创建三个button
- (void)chuangjiansangeanniu
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 96 * scaleHeight)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.tag  = 666;
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 95 * scaleHeight, Screen_Width, 1 * scaleHeight)];
    view2.backgroundColor = BaseColor(249, 249, 249, 1);
    [view addSubview:view2];
    _youxiaozhong = [[MyConfirmBaseButton alloc]init];
    _yiguoqi = [[MyConfirmBaseButton alloc]init];
    _yishiyong = [[MyConfirmBaseButton alloc]init];
    _youxiaozhong.titleLabel.font = BaseFont(25);
    _yishiyong.titleLabel.font = BaseFont(25);
    _yiguoqi.titleLabel.font = BaseFont(25);
    _lowLineView = [[UIView alloc]init];
     _lowLineView.backgroundColor = BaseColor(9, 142, 43, 1);
    [view addSubview:_youxiaozhong];
    [view addSubview:_yiguoqi];
    [view addSubview:_yishiyong];
    [view addSubview:_lowLineView];
    [_youxiaozhong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(52 * scaleWidth);
        make.right.mas_equalTo(_yishiyong.mas_left).offset(-106 * scaleWidth);
        make.width.mas_equalTo(@[_yishiyong, _yiguoqi]);
    }];
    [_yishiyong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_youxiaozhong.mas_right).offset(106 * scaleWidth);
        make.right.mas_equalTo(_yiguoqi.mas_left).offset(-102 * scaleWidth);
    }];
    [_yiguoqi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_yishiyong.mas_right).offset(102 * scaleWidth);
        make.right.mas_equalTo(-52 * scaleWidth);
    }];
    
    [_youxiaozhong setTitle:@"有效中" forState:UIControlStateNormal];
    [_yishiyong setTitle:@"已使用" forState:UIControlStateNormal];
    [_yiguoqi setTitle:@"已过期" forState:UIControlStateNormal];
    
    _youxiaozhong.titleLabel.font = [UIFont systemFontOfSize:21];
    _yishiyong.titleLabel.font = [UIFont systemFontOfSize:21];
    _yiguoqi.titleLabel.font = [UIFont systemFontOfSize:21];
    [_youxiaozhong addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_yishiyong addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_yiguoqi addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _youxiaozhong.selected = YES;
    [self panduanDixian];
    [self createUi];
}
- (void)buttonClick:(MyConfirmBaseButton *)button
{
    if (button == _youxiaozhong) {
        _youxiaozhong.selected  =YES;
        _yishiyong.selected  =NO;
        _yiguoqi.selected = NO;
        _AddHongBaoButton.hidden = NO;
    }
    if (button == _yishiyong) {
        _youxiaozhong.selected  =NO;
        _yishiyong.selected  =YES;
        _yiguoqi.selected = NO;
        _AddHongBaoButton.hidden = YES;
    }
    if (button == _yiguoqi) {
        _youxiaozhong.selected  = NO;
        _yishiyong.selected  = NO;
        _yiguoqi.selected = YES;
        _AddHongBaoButton.hidden = YES;
    }
    [self panduanDixian];
    if (_youxiaozhong.selected) {
        [_tableView registerClass:[HongBaoYouxiaoTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    if (_yishiyong.selected) {
        [_tableView registerClass:[HongBaoShiYongTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    if (_yiguoqi.selected) {
        [_tableView registerClass:[HongBaoGuoQiTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    [_tableView reloadData];
}
#pragma mark  --判断button的底线在哪一个位置
- (void)panduanDixian
{
    UIView * view = (id)[self.view viewWithTag:666];
    // 告诉self.view约束需要更新
    [view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [view updateConstraintsIfNeeded];
    if (_youxiaozhong.selected) {
        [_lowLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_youxiaozhong.mas_left);
            make.right.mas_equalTo(_youxiaozhong.mas_right);
            make.bottom.mas_equalTo(_youxiaozhong.mas_bottom);
            make.height.mas_equalTo(3 * scaleHeight);
        }];
    }
    if (_yishiyong.selected) {
        [_lowLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_yishiyong.mas_left);
            make.right.mas_equalTo(_yishiyong.mas_right);
            make.bottom.mas_equalTo(_yishiyong.mas_bottom);
            make.height.mas_equalTo(3 * scaleHeight);
        }];
    }
    if (_yiguoqi.selected) {
        [_lowLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_yiguoqi.mas_left);
            make.right.mas_equalTo(_yiguoqi.mas_right);
            make.bottom.mas_equalTo(_yiguoqi.mas_bottom);
            make.height.mas_equalTo(3 * scaleHeight);
        }];
    }
}



- (void)leftBackButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUi
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 96 * scaleHeight, Screen_Width, Screen_Height - 96 * scaleHeight - 88 * scaleHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_youxiaozhong.selected) {
        [_tableView registerClass:[HongBaoYouxiaoTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    if (_yishiyong.selected) {
        [_tableView registerClass:[HongBaoShiYongTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    if (_yiguoqi.selected) {
        [_tableView registerClass:[HongBaoGuoQiTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_youxiaozhong.selected) {
        return [_dataArrayOfYouXiao count];
    }
    if (_yishiyong.selected) {
        return [_dataArrayOfshiyong count];
    }
    if (_yiguoqi.selected) {
        return [_dataArrayOfguoqi count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HongBaoYouxiaoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_youxiaozhong.selected) {
        ((HongBaoYouxiaoTableViewCell *)cell).Message = _dataArrayOfYouXiao[indexPath.row][@"message"];
        ((HongBaoYouxiaoTableViewCell *)cell).Amount = _dataArrayOfYouXiao[indexPath.row][@"amount"];
        ((HongBaoYouxiaoTableViewCell *)cell).Time = _dataArrayOfYouXiao[indexPath.row][@"lastmodifiedtime"];
        [(HongBaoYouxiaoTableViewCell *)cell deleteBlockClick:^(UIButton *btn) {
            
            [self deleHongBaoWith:_dataArrayOfYouXiao[indexPath.row][@"id"] index:indexPath.row MutableArray:_dataArrayOfYouXiao];
        }];
    }
    if (_yishiyong.selected) {
        ((HongBaoShiYongTableViewCell *)cell).Message = _dataArrayOfshiyong[indexPath.row][@"message"];
        ((HongBaoShiYongTableViewCell *)cell).Amount = _dataArrayOfshiyong[indexPath.row][@"amount"];
        ((HongBaoShiYongTableViewCell *)cell).Time = _dataArrayOfshiyong[indexPath.row][@"lastmodifiedtime"];
        [(HongBaoShiYongTableViewCell *)cell deleteBlockClick:^(UIButton *btn) {
            [self deleHongBaoWith:_dataArrayOfshiyong[indexPath.row][@"id"] index:indexPath.row MutableArray:_dataArrayOfshiyong];
        }];
    }
    if (_yiguoqi.selected) {
        ((HongBaoGuoQiTableViewCell *)cell).Message = _dataArrayOfguoqi[indexPath.row][@"message"];
        ((HongBaoGuoQiTableViewCell *)cell).Amount = _dataArrayOfguoqi[indexPath.row][@"amount"];
        ((HongBaoGuoQiTableViewCell *)cell).Time = _dataArrayOfguoqi[indexPath.row][@"lastmodifiedtime"];
        [(HongBaoGuoQiTableViewCell *)cell deleteBlockClick:^(UIButton *btn) {
            [self deleHongBaoWith:_dataArrayOfguoqi[indexPath.row][@"id"] index:indexPath.row MutableArray:_dataArrayOfguoqi];
        }];
    }
    [cell senderButtonClick:^(UIButton *btn) {
        SenderHongBaoViewController * svc = [[SenderHongBaoViewController alloc]init];
        if (_youxiaozhong.selected) {
            svc.hongbaoID = _dataArrayOfYouXiao[indexPath.row][@"id"];
             [self.navigationController pushViewController:svc animated:YES];
        }
        if (_yishiyong.selected) {
//            svc.hongbaoID = _dataArrayOfshiyong[indexPath.row][@"id"];
        }
        if (_yiguoqi.selected) {
//            svc.hongbaoID = _dataArrayOfguoqi[indexPath.row][@"id"];
        }

       
    }];
    return cell;
}

#pragma mark --删除红包
- (void)deleHongBaoWith:(NSString *)HongbaoID index:(NSInteger)index MutableArray:(NSMutableArray *)array
{
    JQBaseRequest * jq = [[JQBaseRequest alloc]init];
    [jq ShanChuHongBaoWithRedEnvelopeId:HongbaoID complete:^(NSDictionary *responseObject) {
        UIAlertController*alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ATTENTION", @"") message:@"红包删除成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*otherAction = [UIAlertAction  actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction*action) {
            
            [array removeObjectAtIndex:index];
            [_tableView reloadData];
            
        }];
        
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } fail:^(NSError *error, NSString *errorString) {
        UIAlertController*alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ATTENTION", @"") message:[NSString stringWithFormat:@"%@", errorString] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*otherAction = [UIAlertAction  actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction*action) {
            
            
        }];
        
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HongBaoYouxiaoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor yellowColor];
    return 290 * scaleHeight;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
