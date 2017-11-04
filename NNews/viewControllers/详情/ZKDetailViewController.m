//
//  ZKDetailViewController.m
//  NNews
//
//  Created by Tom on 2017/11/4.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKDetailViewController.h"
#import "ZKDetailHeaderView.h"
#import "ZKDetailTableViewCell.h"

@interface ZKDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView        * tableView;
@property (nonatomic, strong) ZKDetailHeaderView * headerView;
@end

static NSString * const cellIdentifider = @"detailCellID";

@implementation ZKDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.hidesBottomBarWhenPushed = YES;
    // Do any additional setup after loading the view.
}

- (void)setType:(detailType)type {
    self.tableView.tableHeaderView = self.headerView;
    _type = type;
    if (type == typeVideo) {
        self.headerView.type = typeVideo;
        self.headerView.videoModel = self.videoModel;
        self.headerView.frame = CGRectMake(0, 0, D_WIDTH, self.videoModel.cellHeight);
    }else if (type == typePicture) {
        self.headerView.type = typePicture;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return N_Cell;
}

#pragma mark - lazy init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:NSClassFromString(@"ZKDetailTableViewCell") forCellReuseIdentifier:cellIdentifider];
        //__weak typeof(self)weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //[weakSelf refreshLoadMoreList];
        }];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (ZKDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ZKDetailHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
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
