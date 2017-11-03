//
//  ZKFunsViewController.m
//  NNews
//
//  Created by Tom on 2017/10/31.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKFunsViewController.h"
#import "ZKFunsTableViewCell.h"
#import "ZKVideoPlayView.h" //
#import "ZKTTVideo.h"

@interface ZKFunsViewController ()<UITableViewDelegate, UITableViewDataSource, ZKFunsTableViewCellDelegate, ZKVideoPlayViewDelegate>
@property (nonatomic, strong) UITableView     * tableView;
@property (nonatomic, strong) NSMutableArray  * listArray;
@property (nonatomic, assign) NSInteger         page;
@property (nonatomic, strong) ZKVideoPlayView * videoPlayView; //视频播放视图
@end

static NSString * const cellIdentifider = @"ZKFunsTableViewCellID";

@implementation ZKFunsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.listArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"趣事";
    [self setUI];
}

- (void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)refreshLoadMoreList{
    NSString * link = @"http://api.budejie.com/api/api_open.php";
    NSDictionary * para = @{@"a":@"list",
                            @"c":@"data",
                            @"type":@(41),
                            @"page":@(0)};
    [[ZKNetWorkManager shareManager] requestWithType:requestTypePost urlString:link andParameters:para success:^(id responsder) {
        NSArray  * array = [ZKTTVideo mj_objectArrayWithKeyValuesArray:responsder[@"list"]];
        NSString * maxTime = responsder[@"info"][@"maxtime"];
        for (ZKTTVideo *video in array) {
            video.maxtime = maxTime;
        }
        [self.listArray addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        });
    } failure:^(NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
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
    ZKFunsTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifider forIndexPath:indexPath];
    
    ZKTTVideo * video = self.listArray[indexPath.section];
    NSString * videoLink = video.videouri;
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoLink]];
    
    ZKVideoPlayView * videoPlayView = [[ZKVideoPlayView alloc] init];
    self.videoPlayView = videoPlayView;
    self.videoPlayView.frame = CGRectMake(0, NavBarH, D_WIDTH, CGRectGetHeight(cell.bounds));
    self.videoPlayView.delegate = self;
    self.videoPlayView.playerItem = item;
    
    [self.view addSubview:self.videoPlayView];
}

#pragma mark - ZKVideoPlayViewDelegate
- (void)openFullPlayWindow:(BOOL)full{ //是否全屏
    if(full){
        
    }else{
        
    }
}

- (void)videoPlayFinish {
    if (self.videoPlayView) {
        [self.videoPlayView removeFromSuperview];
        self.videoPlayView = nil;
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
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshLoadMoreList];
        }];
        [_tableView.mj_header beginRefreshing];
    }
    return _tableView;
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
