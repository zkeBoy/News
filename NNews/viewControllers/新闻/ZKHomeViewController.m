//
//  ZKHomeViewController.m
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//  http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html

#import "ZKHomeViewController.h"
#import "ZKPictureDetailViewController.h"
#import "ZKWebViewController.h"
#import "ZKHomeViewModel.h"
#import "ZKBannerModel.h"
#import "ZKHomeNetWork.h"

@interface ZKHomeViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView        * tableView;
@property (nonatomic, strong) NSMutableArray     * imgArray;
@property (nonatomic, strong) NSMutableArray     * titleArray;
@property (nonatomic, strong) NSMutableArray     * bannerArray;
@property (nonatomic, strong) SDCycleScrollView  * headerView;
@property (nonatomic, strong) ZKHomeViewModel    * homeViewModel;
@end

@implementation ZKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"tab_new", nil);
    [self setUpTableView];
}

- (void)setUpTableView {
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource= self;
    tableView.frame = TabFrame;
    [tableView registerClass:[ZKHomeDefaultCell class] forCellReuseIdentifier:CellDefaultIdentifider];
    [tableView registerClass:[ZKHomeImgCell class] forCellReuseIdentifier:CellImageIdentifider];
    [tableView registerClass:[ZKHomeTextCell class] forCellReuseIdentifier:CellTextIdentifider];
    [tableView registerClass:[ZKHomeImgsCell class] forCellReuseIdentifier:CellImagesIdentifider];
    [tableView registerClass:[ZKHomeBigImgCell class] forCellReuseIdentifier:CellBigImageIdentifider];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestBanner];
        [self.homeViewModel refreshDataWithCompleteHandler:^(NSError *error) {
            [tableView reloadData];
            [tableView.mj_header endRefreshing];
        }];
    }];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.homeViewModel getMoreDataWithCompleteHandler:^(NSError *error) {
            [tableView reloadData];
            [tableView.mj_footer endRefreshing];
        }];
    }];
    [tableView.mj_header beginRefreshing];
    tableView.tableHeaderView = self.headerView;
    [self.view addSubview:tableView];
    self.headerView.frame = CGRectMake(0, 0, D_WIDTH, D_WIDTH*0.55);
    self.tableView = tableView;
}

- (void)requestBanner {
    NSString * banner = @"http://c.m.163.com/nc/article/headline/T1348647853363/0-10.html";
    [ZKHomeNetWork GET:banner para:nil progress:nil completionHandler:^(id obj, NSError *error) {
        NSArray * arr = [ZKBannerModel mj_objectArrayWithKeyValuesArray:obj[@"T1348647853363"][0][@"ads"]];
        [self.bannerArray removeAllObjects];
        [self.imgArray removeAllObjects];
        [self.titleArray removeAllObjects];
        for (ZKBannerModel * model in arr) {
            [self.bannerArray addObject:model];
            [self.imgArray addObject:model.imgsrc];
            [self.titleArray addObject:model.title];
        }
        self.headerView.imageURLStringsGroup = self.imgArray;
        self.headerView.titlesGroup = self.titleArray;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeViewModel.rowNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.homeViewModel tableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //cellType type = [self.homeViewModel cellTypeWithIndexPath:indexPath];
    ZKHomeModel * model = [self.homeViewModel modelWithIndexPath:indexPath];
    if (model.photosetID) {
        NSString *url1 = [model.photosetID substringFromIndex:4];
        url1 = [url1 substringToIndex:4];
        NSString *url2 = [model.photosetID substringFromIndex:9];
        url2 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
        ZKPictureDetailViewController * pictureVC = [[ZKPictureDetailViewController alloc] init];
        pictureVC.jsonString = url2;
        [self.navigationController pushViewController:pictureVC animated:YES];
    }else {
        ZKWebViewController * webVC = [[ZKWebViewController alloc] init];
        webVC.model = model;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.homeViewModel cellheightWithIndexPath:indexPath];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ZKBannerModel * data = self.bannerArray[index];
    NSString *url1 = [data.url substringFromIndex:4];
    url1 = [url1 substringToIndex:4];
    NSString *url2 = [data.url substringFromIndex:9];
    url2 = [NSString stringWithFormat:@"http://c.3g.163.com/photo/api/set/%@/%@.json",url1,url2];
    ZKPictureDetailViewController * pictureVC = [[ZKPictureDetailViewController alloc] init];
    pictureVC.jsonString = url2;
    [self.navigationController pushViewController:pictureVC animated:YES];
}

#pragma mark - lazy init
- (NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (NSMutableArray *)titleArray {
    if(!_titleArray){
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (ZKHomeViewModel *)homeViewModel {
    if (!_homeViewModel) {
        _homeViewModel = [[ZKHomeViewModel alloc] init];
    }
    return _homeViewModel;
}

- (SDCycleScrollView *)headerView {
    if (!_headerView) {
        _headerView = [[SDCycleScrollView alloc] init];
        _headerView.delegate = self;
        _headerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _headerView.autoScrollTimeInterval = 3;
        _headerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
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
