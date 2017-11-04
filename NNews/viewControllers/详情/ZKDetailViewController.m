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
#import "ZKFullViewController.h"
#import "ZKVideoPlayView.h"

@interface ZKDetailViewController ()<UITableViewDataSource, UITableViewDelegate, ZKDetailHeaderViewDelegate, ZKVideoPlayViewDelegate>
@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) ZKDetailHeaderView   * headerView;
@property (nonatomic, strong) ZKVideoPlayView      * videoPlayView;
@property (nonatomic, assign) BOOL                   isVideoFullWindow;
@property (nonatomic, strong) ZKFullViewController * videoFullWindow;
@end

static NSString * const cellIdentifider = @"detailCellID";

@implementation ZKDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setType:(detailType)type {
    _type = type;
    if (type == typeVideo) {
        self.headerView.type = typeVideo;
        self.headerView.videoModel = self.videoModel;
        self.headerView.frame = CGRectMake(0, 0, D_WIDTH, self.videoModel.cellHeight);
    }else if (type == typePicture) {
        self.headerView.type = typePicture;
    }
    self.tableView.tableHeaderView = self.headerView;
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

#pragma mark - ZKDetailHeaderViewDelegate
- (void)startPlayVideo:(NSString *)videoLink {
    CGRect frame = self.headerView.coverFrame;
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoLink]];
    ZKVideoPlayView * videoPlayView = [[ZKVideoPlayView alloc] init];
    self.videoPlayView = videoPlayView;
    self.videoPlayView.frame = frame;
    self.videoPlayView.playerItem = item;
    self.videoPlayView.delegate = self;
    [self.headerView addSubview:self.videoPlayView];
}

#pragma mark - ZKVidepPlayViewDelegate
- (void)openFullPlayWindow:(BOOL)full {
    if (full) {
        self.isVideoFullWindow = full;
        [self presentViewController:self.videoFullWindow animated:YES completion:^{
            self.videoPlayView.frame = self.videoFullWindow.view.frame;
            [self.videoFullWindow.view addSubview:self.videoPlayView];
        }];
    }else {
        [self.videoFullWindow dismissViewControllerAnimated:YES completion:^{
            self.videoPlayView.frame = self.headerView.coverFrame;
            [self.headerView addSubview:self.videoPlayView];
        }];
    }
}

- (void)videoPlayFinish {
    if (self.isVideoFullWindow) {
        [self.videoFullWindow dismissViewControllerAnimated:YES completion:^{
           
        }];
    }
    [self.videoPlayView resetVideoPlay];
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
        //_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //[weakSelf refreshLoadMoreList];
        //}];
        //[_tableView.mj_header beginRefreshing];
    }
    return _tableView;
}

- (ZKDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ZKDetailHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor purpleColor];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (ZKFullViewController *)videoFullWindow {
    if (!_videoFullWindow) {
        _videoFullWindow = [[ZKFullViewController alloc] init];
    }
    return _videoFullWindow;
}

#pragma mark - setUI
- (void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
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
