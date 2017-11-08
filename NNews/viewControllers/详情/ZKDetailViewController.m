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
#import "ZKVideoPlayView.h"


@interface ZKDetailViewController ()<UITableViewDataSource, UITableViewDelegate, ZKDetailHeaderViewDelegate, ZKVideoPlayViewDelegate>
@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) NSMutableArray       * listArray; //评论数据
@property (nonatomic, strong) ZKDetailHeaderView   * headerView;
@property (nonatomic, strong) ZKVideoPlayView      * videoPlayView;
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
    
#warning - 返回事件需要自定义,需要判断播放是否完成
    
}

- (void)setType:(detailType)type {
    _type = type;
    if (type == typeVideo) {
        self.headerView.type = typeVideo;
        self.headerView.videoModel = self.videoModel;
    }else if (type == typePicture) {
        self.headerView.type = typePicture;
    }
    self.headerFrame = self.headerView.frame = CGRectMake(0, 0, D_WIDTH, self.videoModel.cellHeight);
    self.tableView.tableHeaderView = self.headerView;
}

- (void)loadNewListData{ //加载最新的消息
    if (self.listArray.count) {
        [self.listArray removeAllObjects];
    }
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    NSString * urlString = @"http://api.budejie.com/api/api_open.php";
    if (_type == typeVideo) {
        para[@"a"] = @"dataList";
        para[@"c"] = @"comment";
        para[@"data_id"] = self.videoModel.ID;
        para[@"hot"] = @"1";
    }else if (_type == typePicture) {
        
    }
    [ZKDetailModelManager detailWithURLString:urlString andPara:para success:^(id responsder) {
        if (responsder) {
            if (_type == typeVideo) {
                // 最热评论
                NSArray * hot = [ZKTTVideoComment mj_objectArrayWithKeyValuesArray:responsder[@"hot"]];
                [self.listArray addObjectsFromArray:hot];
            }else if (_type == typePicture) {
                
            }
            self.page = 1;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } failure:^(NSError * error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)refreshLoadMoreListData{ //上拉加载更多的信息
    self.page ++;
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
        
    }
    [ZKDetailModelManager detailWithURLString:urlString andPara:para success:^(id resopnsder) {
        if (resopnsder&&[resopnsder isKindOfClass:[NSDictionary class]]) {
            if (_type == typeVideo) {
                NSArray * array = resopnsder[@"data"];
                if (array.count) {
                    NSArray * newComments = [ZKTTVideoComment mj_objectArrayWithKeyValuesArray:array];
                    [self.listArray addObjectsFromArray:newComments];
                }
            }else if (_type == typePicture) {
                
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
    if (_type==typeVideo) {
        ZKTTVideoComment * comment = self.listArray[indexPath.row];
        ZKDetailTableViewCell *  cell = [tableView dequeueReusableCellWithIdentifier:cellVideoIdentifider forIndexPath:indexPath];
        cell.videoComment = comment;
        return cell;
    }else if (_type==typePicture){
        
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type==typeVideo) {
        ZKTTVideoComment * comment = self.listArray[indexPath.row];
        return comment.cellHeight;
    }else if (_type==typePicture) {
        
    }
    return 0;
}

#pragma mark - ZKDetailHeaderViewDelegate
- (void)startPlayVideo:(NSString *)videoLink {
    CGRect frame = self.headerFrame;
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoLink]];
    ZKVideoPlayView * videoPlayView = [[ZKVideoPlayView alloc] init];
    self.videoPlayView = videoPlayView;
    self.videoPlayView.frame = frame;
    self.videoPlayView.playerItem = item;
    self.videoPlayView.delegate = self;
    self.tableView.tableHeaderView = self.videoPlayView;
}

#pragma mark - ZKVidepPlayViewDelegate
- (void)openFullPlayWindow:(BOOL)full {
    __weak typeof(self)weakSelf = self;
    if (full) {
        self.isVideoFullWindow = full;
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

- (void)videoPlayFinish {
    if (self.isVideoFullWindow) {
        [self.videoFullWindow dismissViewControllerAnimated:YES completion:^{
           
        }];
    }
    if (self.videoPlayView) {
        [self.videoPlayView resetVideoPlay];
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
