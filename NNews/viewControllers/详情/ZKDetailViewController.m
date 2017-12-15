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
#import "ZKDetailModelManager.h"
#import "ZKFullViewController.h"
#import "ZKPictureFullController.h"
#import "ZKPlayerView.h"


@interface ZKDetailViewController ()<UITableViewDataSource, UITableViewDelegate, ZKDetailHeaderViewDelegate, ZKPlayerViewDelegate>
@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) NSMutableArray       * listArray; //评论数据
@property (nonatomic, strong) ZKDetailHeaderView   * headerView;
@property (nonatomic, strong) ZKPlayerView         * videoPlayView;
@property (nonatomic, assign) BOOL                   isVideoFullWindow;
@property (nonatomic, strong) ZKFullViewController * videoFullWindow;
@property (nonatomic, assign) CGRect                 headerFrame;
@property (nonatomic, assign) NSInteger              page;
@end

static NSString * const cellVideoIdentifider   = @"videoDetailCellID";
static NSString * const cellPictureIdentifider = @"pictureDetailCellID";

@implementation ZKDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArray = [NSMutableArray array];
    [self setUI];
    
//#warning - 返回事件需要自定义,需要判断播放是否完成
    UIImage * image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    left.imageInsets = UIEdgeInsetsMake(4, -8, 4, 0);
    self.navigationItem.leftBarButtonItem = left;
}

- (void)setType:(detailType)type {
    _type = type;
    if (type == typeVideo) {
        self.headerView.type = typeVideo;
        self.headerView.videoModel = self.videoModel;
        self.headerFrame = self.headerView.frame = CGRectMake(0, 0, D_WIDTH, self.videoModel.cellHeight);
    }else if (type == typePicture) {
        self.headerView.type = typePicture;
        self.headerView.pictureModel = self.pictureModel;
        self.headerFrame = self.headerView.frame = CGRectMake(0, 0, D_WIDTH, self.pictureModel.cellHeight);
    }
    self.tableView.tableHeaderView = self.headerView;
}

- (void)loadNewListData{ //加载最新的消息
    
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    NSString * urlString = @"http://api.budejie.com/api/api_open.php";
    if (_type == typeVideo) {
        para[@"a"] = @"dataList";
        para[@"c"] = @"comment";
        para[@"data_id"] = self.videoModel.ID;
        para[@"hot"] = @"1";
    }else if (_type == typePicture) {
        para[@"a"] = @"dataList";
        para[@"c"] = @"comment";
        para[@"data_id"] = self.pictureModel.ID;
        para[@"hot"] = @"1";
    }
    [ZKDetailModelManager detailWithURLString:urlString andPara:para success:^(id responsder) {
        if (responsder[@"hot"]) {
            if (self.listArray.count) {
                [self.listArray removeAllObjects];
            }
            // 最热评论
            NSArray * hot = [ZKTTVideoComment mj_objectArrayWithKeyValuesArray:responsder[@"hot"]];
            [self.listArray addObjectsFromArray:hot];
            self.page = 1;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
        }
    } failure:^(NSError * error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)refreshLoadMoreListData{ //上拉加载更多的信息
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    NSString * urlString = @"http://api.budejie.com/api/api_open.php";
    if (_type == typeVideo) {
        para[@"a"] = @"dataList";
        para[@"c"] = @"comment";
        para[@"data_id"] = self.videoModel.ID;
        para[@"page"] = @(self.page);
        ZKTTVideoComment * videoComment = [self.listArray lastObject];
        para[@"lastcid"] = videoComment.ID;
    }else if (_type == typePicture) {
        para[@"a"] = @"dataList";
        para[@"c"] = @"comment";
        para[@"data_id"] = self.pictureModel.ID;
        para[@"page"] = @(self.page);
        ZKTTVideoComment * videoComment = [self.listArray lastObject];
        para[@"lastcid"] = videoComment.ID;
    }
    [ZKDetailModelManager detailWithURLString:urlString andPara:para success:^(id resopnsder) {
        if (resopnsder&&[resopnsder isKindOfClass:[NSDictionary class]]) {
            NSArray * array = resopnsder[@"data"];
            if (array.count) {
                NSArray * newComments = [ZKTTVideoComment mj_objectArrayWithKeyValuesArray:array];
                [self.listArray addObjectsFromArray:newComments];
                self.page ++;
            }
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }else {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
    //return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTTVideoComment * comment = self.listArray[indexPath.row];
    ZKDetailTableViewCell *  cell = [tableView dequeueReusableCellWithIdentifier:cellVideoIdentifider forIndexPath:indexPath];
    cell.videoComment = comment;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTTVideoComment * comment = self.listArray[indexPath.row];
    return comment.cellHeight;
}

#pragma mark - ZKDetailHeaderViewDelegate
- (void)startPlayVideo:(NSString *)videoLink {
    CGRect frame = self.headerFrame;
    ZKPlayerView * videoPlayView = [[ZKPlayerView alloc] initWithStreamURL:videoLink];
    self.videoPlayView = videoPlayView;
    self.videoPlayView.frame = frame;
    self.videoPlayView.delegate = self;
    self.tableView.tableHeaderView = self.videoPlayView;
}

- (void)seeBigPicture:(ZKTTPicture *)pictureModel {
    ZKPictureFullController * fullVC = [[ZKPictureFullController alloc] init];
    fullVC.pictureModel = pictureModel;
    [self presentViewController:fullVC animated:YES completion:nil];
}

#pragma mark - ZKVidepPlayViewDelegate
- (void)openFullWindow:(BOOL)open{
    __weak typeof(self)weakSelf = self;
    if (open) {
        self.isVideoFullWindow = open;
        [self presentViewController:weakSelf.videoFullWindow animated:YES completion:^{
            weakSelf.videoPlayView.frame = weakSelf.videoFullWindow.view.frame;
            [weakSelf.videoFullWindow.view addSubview:weakSelf.videoPlayView];
        }];
    }else {
        [self.videoFullWindow dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.videoPlayView.frame = weakSelf.headerFrame;
                weakSelf.tableView.tableHeaderView = weakSelf.videoPlayView;
            });
            weakSelf.isVideoFullWindow = NO;
        }];
    }
}

- (void)playerDidFinish {
    if (self.isVideoFullWindow) {
        [self.videoFullWindow dismissViewControllerAnimated:YES completion:^{
           
        }];
    }
    if (self.videoPlayView) {
        [self.videoPlayView resetPlayer];
        self.videoPlayView = nil;
    }
    self.headerView.frame = self.headerFrame;
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark - lazy init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.allowsSelection = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:NSClassFromString(@"ZKDetailTableViewCell") forCellReuseIdentifier:cellVideoIdentifider];
        __weak typeof(self)weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewListData];
        }];
        [_tableView.mj_header beginRefreshing];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf refreshLoadMoreListData];
        }];
    }
    return _tableView;
}

- (ZKDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[ZKDetailHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
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

#pragma mark - Private Method
- (void)backAction {
    if (self.videoPlayView) {
        [self.videoPlayView resetPlayer];
        self.videoPlayView = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    if (_type==typeVideo) {
        NSLog(@"video ZKDetailViewController dealloc !!!");
    }else{
        NSLog(@"picture ZKDetailViewController dealloc !!!");
    }
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
