//
//  ZKNewsViewController.m
//  NNews
//
//  Created by Tom on 2017/10/31.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKNewsViewController.h"
#import "ZKNewsTableViewCell.h"

@interface ZKNewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView    * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

static NSString * const cellIdentifider = @"ZKNewsTableViewCellID";

@implementation ZKNewsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initModels];
    }
    return self;
}

- (void)initModels{
    self.dataArray = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"tab_new", nil);
    [self setUI];
}

- (void)setUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

//下拉刷新
- (void)downloadRefreshData{
    NSString * list = @"http://app3.qdaily.com/app3/homes/index/0.json?";
    [[ZKNetWorkManager shareManager] requestWithType:requestTypeGet
                                           urlString:list
                                       andParameters:nil
                                             success:^(id responsder) {
                                                 NSArray *banner = responsder[@"response"][@"feeds"];
                                                 for (int i=0; i<banner.count; i++) {
                                                     NSDictionary *banners = [banner[i] objectForKey:@"post"];
                                                     ZKNewsModel * model = [[ZKNewsModel alloc] init];
                                                     //链接
                                                     NSString *url = [banners objectForKey:@"appview"];
                                                     if (url) {
                                                         model.link = url;
                                                     }else if(url==nil){
                                                         url = @"http://www.jianshu.com/p/4ea427bab0af";
                                                         model.link = url;
                                                     }
                                                     
                                                     //标题
                                                     NSString *titlel = [banners objectForKey:@"title"];
                                                     if (titlel) {
                                                         [titlel stringByRemovingPercentEncoding];
                                                         model.title = titlel;
                                                     }
                                                     
                                                     //图片
                                                     NSString *img = [banner[i] objectForKey:@"image"];
                                                     if (img) {
                                                         model.image = img;
                                                     }else if(img==nil){
                                                         img = @"http://img.qdaily.com/article/article_show/20161110122926LJBdCEmQtRVzhGji.png?imageMogr2/auto-orient/thumbnail/!640x380r/gravity/Center/crop/640x380/quality/85/format/jpg/ignore-error/1";
                                                         model.image = img;
                                                     }
                                                     //添加数据源
                                                     [self.dataArray addObject:model];
                                                 }
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [self.tableView reloadData];
                                                     [self.tableView.mj_header endRefreshing];
                                                 });
                                             } failure:^(NSError * error) {
                                                 NSLog(@"no more data!");
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [self.tableView.mj_header endRefreshing];
                                                 });
                                             }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZKNewsModel * model = [self.dataArray objectAtIndex:indexPath.row];
    ZKNewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifider forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZKNewsModel * model = [self.dataArray objectAtIndex:indexPath.row];
    NSString * link = model.link;
    ZKWebViewController * webVC = [[ZKWebViewController alloc] initWithLinkURL:link];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//每个cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return N_Cell;
}

#pragma mark - lazy init
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        //_tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10, 0, 0, 0);
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:NSClassFromString(@"ZKNewsTableViewCell") forCellReuseIdentifier:cellIdentifider];
        __weak typeof(self)weakSelf = self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf downloadRefreshData];
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
