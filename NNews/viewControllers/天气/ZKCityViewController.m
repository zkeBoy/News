//
//  ZKCityViewController.m
//  NNews
//
//  Created by Tom on 2017/11/14.
//  Copyright © 2017年 Tom. All rights reserved.
//  

#import "ZKCityViewController.h"

static NSString * const cellIdentifider = @"identifider";

@interface ZKCityViewController ()
@property (nonatomic, strong) NSMutableArray     * listArray;
@property (nonatomic, strong) UISearchBar        * searchBar;
@property (nonatomic, strong) UISearchController * searchController;

@end

@implementation ZKCityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifider];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZKCityModel * cityModel = self.listArray[section];
    return cityModel.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKCityModel * cityModel = self.listArray[indexPath.section];
    NSString * cityName = cityModel.cities[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifider forIndexPath:indexPath];
    cell.textLabel.text = cityName;
    return cell;
}

#pragma mark - UITableViewDelegate
//返回tableViewIndex数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //方式一
    NSMutableArray * titleMutablArray = [NSMutableArray array];
    for (ZKCityModel * cityModel in self.listArray) {
        [titleMutablArray addObject:cityModel.title];
    }
    return [titleMutablArray copy];
}

//返回section头Title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    ZKCityModel * cityModel = self.listArray[section];
    return cityModel.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZKCityModel * cityModel = self.listArray[indexPath.section];
    NSString * cityName = cityModel.cities[indexPath.row];
    [self.delegate didSelectCityName:cityName];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy init
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
        NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
        NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
        for (NSDictionary * dic in array) {
            ZKCityModel * cityModel = [[ZKCityModel alloc] init];
            [cityModel setValuesForKeysWithDictionary:dic];
            [_listArray addObject:cityModel];
        }
    }
    return _listArray;
}

#pragma mark - Private Method
- (void)dealloc {
    NSLog(@"ZKCityViewController dealloc !!!!!!");
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
