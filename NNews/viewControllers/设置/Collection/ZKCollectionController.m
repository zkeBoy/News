//
//  ZKCollectionController.m
//  NNews
//
//  Created by Tom on 2018/1/16.
//  Copyright © 2018年 Tom. All rights reserved.
//

#import "ZKCollectionController.h"
#import "ZKCollectionViewCell.h"
#import "ZKPlayerView.h"

static NSString * const cellIdentifider = @"ZKCollectionViewCell";

@interface ZKCollectionController ()<ZKPlayerViewDelegate>
@property (nonatomic, strong) ZKPlayerView * playView;

@end

@implementation ZKCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarItem];
    [self setUpTableView];
}

- (void)setNavigationBarItem {
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    self.navigationItem.leftBarButtonItem = left;
    left.imageInsets = UIEdgeInsetsMake(3, -4, 3, 0);
}

- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
    [self playerDidFinish];
}

- (void)setUpTableView {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKCollectionViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ZKCollectionManager getAllURLStrings].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * link = [ZKCollectionManager getAllURLStrings][indexPath.row];
    ZKCollectionViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifider forIndexPath:indexPath];
    cell.textLabel.text = link;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * link = [ZKCollectionManager getAllURLStrings][indexPath.row];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"Choice Type!" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * play = [UIAlertAction actionWithTitle:@"Play" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self playVideoWithLink:link];
    }];
    UIAlertAction * share = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ZKShareHelper shareWithType:0 andPresenController:[ZKToolManager shareManager].currentViewController andItems:@[link] completionHandler:^(BOOL completion) {
            
        }];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:play];
    [alertVC addAction:share];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)playVideoWithLink:(NSString *)link {
    [self.playView resetPlayer];
    
    ZKPlayerView * playView = [[ZKPlayerView alloc] initWithStreamURL:link];
    playView.frame = CGRectMake(0, 0, D_WIDTH, D_WIDTH);
    playView.delegate = self;
    self.playView = playView;
    [self.view addSubview:self.playView];
}

- (void)playerDidFinish {
    [self.playView resetPlayer];
}

@end
