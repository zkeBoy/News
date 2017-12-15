//
//  ZKFunsViewController.m
//  NNews
//
//  Created by Tom on 2017/10/31.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKFunsViewController.h"
#import "ZKFunsTableViewCell.h"
#import "ZKPlayerView.h"
#import "ZKFullViewController.h"
#import "ZKDetailViewController.h"
#import "ZKTTVideo.h"

@interface ZKFunsViewController ()<UITableViewDelegate, UITableViewDataSource, ZKFunsTableViewCellDelegate, ZKPlayerViewDelegate>
@property (nonatomic, strong) UITableView          * tableView;
@property (nonatomic, strong) NSMutableArray       * listArray;
@property (nonatomic, assign) NSInteger              page;
@property (nonatomic, strong) ZKPlayerView         * videoPlayView; //视频播放视图
@property (nonatomic, strong) ZKFullViewController * fullWindow; //全屏
@property (nonatomic, strong) ZKFunsTableViewCell  * currentSelectCell; //当前选中的cell
@property (nonatomic, assign) BOOL                   isFullWindow;
@end

static NSString * const cellIdentifider = @"ZKFunsTableViewCellID";

@implementation ZKFunsViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"tab_video", nil);
    self.listArray = [NSMutableArray array];
    [self setUI];
}

- (void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadLastData{ //加载最新的数据
    NSString * link = @"http://api.budejie.com/api/api_open.php";
    NSDictionary * para = @{@"a":@"list",
                            @"c":@"data",
                            @"type":@(41),
                            @"page":@(0)};
    [[ZKNetWorkManager shareManager] requestWithType:requestTypePost urlString:link andParameters:para success:^(id responsder) {
        if (responsder && [responsder isKindOfClass:[NSDictionary class]]) {
            NSArray  * array = [ZKTTVideo mj_objectArrayWithKeyValuesArray:responsder[@"list"]];
            NSString * maxTime = responsder[@"info"][@"maxtime"];
            for (ZKTTVideo *video in array) {
                video.maxtime = maxTime;
            }
            if (self.listArray.count) {
                [self.listArray removeAllObjects];
            }
            [self.listArray addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            });
            self.page = 1;
        }
    } failure:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
}

- (void)refreshLoadMoreList{
    ZKTTVideo * videoModel = self.listArray.lastObject;
    NSString * maxtime = videoModel.maxtime;
    NSString * link = @"http://api.budejie.com/api/api_open.php";
    NSDictionary * para = @{@"a":@"list",
                            @"c":@"data",
                            @"type":@(41),
                            @"page":@(self.page),
                            @"maxtime":maxtime?maxtime:@""};
    [[ZKNetWorkManager shareManager] requestWithType:requestTypePost urlString:link andParameters:para success:^(id responsder) {
        if (responsder&&[responsder isKindOfClass:[NSDictionary class]]) {
            NSArray  * array = [ZKTTVideo mj_objectArrayWithKeyValuesArray:responsder[@"list"]];
            NSString * maxTime = responsder[@"info"][@"maxtime"];
            for (ZKTTVideo *video in array) {
                video.maxtime = maxTime;
            }
            [self.listArray addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            });
            NSString * page = responsder[@"info"][@"page"];
            self.page = page.integerValue;
        }else {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.listArray.count) {
        return 0;
    }
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //每个Section里面只有一个
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZKFunsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifider];
    cell.videoModel = self.listArray[indexPath.section];
    cell.delegate   = self;
    cell.indexPath  = indexPath;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //关闭播放
    [self.videoPlayView resetPlayer];
    self.videoPlayView = nil;
    
    ZKDetailViewController * detailVC = [[ZKDetailViewController alloc] init];
    detailVC.videoModel = self.listArray[indexPath.section];
    detailVC.type = typeVideo;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZKTTVideo * video = self.listArray[indexPath.section];
    CGFloat height = video.cellHeight;
    return height;
}

//section 之间的间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }
    return 5;//section头部高度
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerSection = [[UIView alloc] init];
    headerSection.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0);
    headerSection.backgroundColor = MainColor;
    return headerSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //设置这个高度才有效
    if (section==self.listArray.count-1) {
        return 10;
    }
    return 5;//section底部间距
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerSection = [[UIView alloc] init];
    footerSection.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0);
    footerSection.backgroundColor = MainColor;
    return footerSection;
}


#pragma mark - ZKFunsTableViewCellDelegate
- (void)clickVideoPlay:(NSIndexPath *)indexPath{
    [self.videoPlayView resetPlayer];
    
    ZKFunsTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.currentSelectCell = cell;
    
    ZKTTVideo * videoModel = self.listArray[indexPath.section];
    NSString * videoLink = videoModel.videouri;
    ZKPlayerView * videoPlayView = [[ZKPlayerView alloc] initWithStreamURL:videoLink];
    self.videoPlayView = videoPlayView;
    self.videoPlayView.frame = cell.videnPlayFrame;
    self.videoPlayView.delegate = self;
    [cell addSubview:videoPlayView];
}

#pragma mark -
- (void)playerDidFinish {
    if (self.videoPlayView.isFull) {
        [self.fullWindow dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    [self.videoPlayView resetPlayer];
    self.videoPlayView = nil;
}

- (void)openFullWindow:(BOOL)open {
    __weak typeof(self)weakSelf = self;
    if (open) {
        [self presentViewController:self.fullWindow animated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.videoPlayView.frame = weakSelf.fullWindow.view.bounds;
                [weakSelf.fullWindow.view addSubview:weakSelf.videoPlayView];
            });
        }];
    }else {
        [self.fullWindow dismissViewControllerAnimated:YES completion:^{
            
        }];
        self.videoPlayView.frame = self.currentSelectCell.videnPlayFrame;
        [self.currentSelectCell addSubview:self.videoPlayView];
    }
}

#pragma mark - 当播放的Cell隐藏了 要停止播放
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //判断播放的Cell是否还在 可见的cell列表中
    if (!self.isFullWindow) {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:self.currentSelectCell];
        if (![self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
            [self.videoPlayView resetPlayer]; //移除
            self.videoPlayView = nil;
        }
    }
}

#pragma mark -
#pragma mark lazy init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor grayColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_tableView registerClass:NSClassFromString(@"ZKFunsTableViewCell") forCellReuseIdentifier:cellIdentifider];
        __weak typeof(self)weakSelf = self;
        _tableView.mj_header = [ZKRefreshGiftHeader headerWithRefreshingBlock:^{
            [weakSelf loadLastData];
        }];
        [_tableView.mj_header beginRefreshing];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf refreshLoadMoreList];
        }];
    }
    return _tableView;
}

- (ZKFullViewController *)fullWindow {
    if (!_fullWindow) {
        _fullWindow = [[ZKFullViewController alloc] init];
    }
    return _fullWindow;
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
