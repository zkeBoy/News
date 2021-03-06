//
//  ZKSettingsViewController.m
//  ZKSport
//
//  Created by Tom on 2017/11/15.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKSettingsViewController.h"
#import "ZKSettingViewCell.h"
#import "ZKSwitchViewCell.h"
#import "ZKAboutViewController.h"
#import "ZKFeedBackViewController.h"
#import "ZKCollectionController.h"

static NSString * const cellIdentifider = @"ZKSettingViewCell";
static NSString * const cellSwitchIdentifider = @"ZKSwitchViewCell";

@interface ZKSettingsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray     * list;
@end

@implementation ZKSettingsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationAboutCleanCachekey" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"设置", nil);
    [self groupArray];
    [self addTableView];
}

- (void)addTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.frame = CGRectMake(0, NavBarH, D_WIDTH, D_HEIGHT-NavBarH-TabBarH);
    self.tableView.backgroundColor = MainColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ZKSettingViewCell class] forCellReuseIdentifier:cellIdentifider];
    [self.tableView registerClass:[ZKSwitchViewCell class] forCellReuseIdentifier:cellSwitchIdentifider];
}

- (void)groupArray{
    ZKSettingModel * model1_1 = [ZKSettingModel initWithIcon:@"" title:@"" clean:NO header:YES];
    NSArray * group1 = @[model1_1];
    
    ZKSettingModel * model2_1 = [ZKSettingModel initWithIcon:@"icon_clean" title:@"清除缓存" clean:YES header:NO];
    ZKSettingModel * model2_2 = [ZKSettingModel initWithIcon:@"icon_about" title:@"关于" clean:NO header:NO];
    //ZKSettingModel * model2_3 = [ZKSettingModel initWithIcon:@"icon_about" title:@"夜间模式" clean:NO header:NO];
    NSArray * group2 = @[model2_1,model2_2];
    
    ZKSettingModel * model3_0 = [ZKSettingModel initWithIcon:@"icon_Collection" title:NSLocalizedString(@"收藏", nil) clean:NO header:NO];
    ZKSettingModel * model3_1 = [ZKSettingModel initWithIcon:@"log_out" title:NSLocalizedString(@"退出登录", nil) clean:NO header:NO];
    NSArray * group3 = @[model3_0,model3_1];
    self.list = @[group1,group2,group3];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * rows = self.list[section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * rows = self.list[indexPath.section];
    ZKSettingModel * model = rows[indexPath.row];
    if (indexPath.section==1&&indexPath.row==2){
        ZKSwitchViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellSwitchIdentifider forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }else{
        ZKSettingViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifider forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0&&indexPath.row==0) {
        [[ZKToolManager shareManager] clipPhotoalbumImage:^(UIImage *image) {
            NSData * data = UIImageJPEGRepresentation(image, 1.0f);
            NSUserDefaults * save = [NSUserDefaults standardUserDefaults];
            [save setObject:data forKey:@"exchangeHeadSuccess"];
            [save synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationExchangeHeaderSuccessKey" object:nil];
            });
        }];
    }else if (indexPath.section==1&&indexPath.row==0) {
        [ZKToolManager showAlertViewWithTitle:NSLocalizedString(@"清理本地图片缓存!", nil) message:NSLocalizedString(@"", nil) other:NSLocalizedString(@"确定", nil) cancel:NSLocalizedString(@"取消", nil) rootViewController:self otherBlock:^{
            [ZKToolManager cleanCache:^{
                [ZKHelperView showAlertMessage:@"清理完成!"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationAboutCleanCachekey" object:nil];
                });
            }];
        } cancelBlock:^{
            
        }];
    }else if (indexPath.section==1&&indexPath.row==1){
        ZKAboutViewController * aboutVC = [[ZKAboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if (indexPath.section==2&&indexPath.row==1){//log out
        [ZKToolManager showAlertViewWithTitle:NSLocalizedString(@"退出登录?", nil) message:NSLocalizedString(@"是否退出登录!", nil) other:NSLocalizedString(@"退出", nil) cancel:NSLocalizedString(@"取消", nil) rootViewController:self otherBlock:^{
            [ZKBmobManager logOut];
            ZKNavigationController *loginNav = [ZKLoginViewController defaultLoginVC];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNav animated:YES completion:nil];
        } cancelBlock:^{
            
        }];
    }else if (indexPath.section==2&&indexPath.row==0) {
        ZKCollectionController * collection = [[ZKCollectionController alloc] init];
        [self.navigationController pushViewController:collection animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray * rows = self.list[indexPath.section];
    ZKSettingModel * model = rows[indexPath.row];
    if (model.isHeader) {
        return 100;
    }
    return 44;
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
