//
//  ZKPictureViewController.m
//  NNews
//
//  Created by Tom on 2017/11/8.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKPictureViewController.h"
#import "ZKPictureTableViewCell.h"

@interface ZKPictureViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView     * tableView;
@property (nonatomic, strong) NSMutableArray  * listArray;
@property (nonatomic, assign) NSInteger         page;
@end

static NSString * const cellIdentifider = @"ZKPictureTableViewCell";

@implementation ZKPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.listArray = [NSMutableArray array];
    [self setUI];
}

- (void)loadLastData{ //加载最新的数据
    if (self.listArray.count) {
        [self.listArray removeAllObjects];
    }
    NSString * linkURL = @"http://api.budejie.com/api/api_open.php";
    NSDictionary * para = @{@"a":@"list",
                            @"c":@"data",
                            @"type":@(10),
                            @"page":@(0)};
    [[ZKNetWorkManager shareManager] requestWithType:requestTypePost urlString:linkURL andParameters:para success:^(id responsder) {
        NSArray * array = [ZKTTPicture mj_objectArrayWithKeyValuesArray:responsder[@"list"]];
        [self.listArray addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        self.page++;
    } failure:^(NSError * error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)refreshloadMore{//刷新更新
    if (self.listArray.count) {
        [self.listArray removeAllObjects];
    }
    NSString * linkURL = @"http://api.budejie.com/api/api_open.php";
    NSDictionary * para = @{@"a":@"list",
                            @"c":@"data",
                            @"type":@(10),
                            @"page":@(self.page)};
    [[ZKNetWorkManager shareManager] requestWithType:requestTypePost urlString:linkURL andParameters:para success:^(id responsder) {
        if (responsder&&[responsder isKindOfClass:[NSDictionary class]]) {
            NSArray * array = [ZKTTPicture mj_objectArrayWithKeyValuesArray:responsder[@"list"]];
            [self.listArray addObjectsFromArray:array];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            self.page++;
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError * error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTTPicture * picture = self.listArray[indexPath.section];
    ZKPictureTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifider forIndexPath:indexPath];
    cell.pictureModel = picture;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZKTTPicture * picture = self.listArray[indexPath.section];
    return picture.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark setUI
- (void)setUI {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -
#pragma mark Lazy init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        [_tableView registerClass:NSClassFromString(@"ZKPictureTableViewCell") forCellReuseIdentifier:cellIdentifider];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setSeparatorColor:[UIColor clearColor]];
        __weak typeof(self)weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadLastData];
        }];
        [_tableView.mj_header beginRefreshing];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf refreshloadMore];
        }];
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
