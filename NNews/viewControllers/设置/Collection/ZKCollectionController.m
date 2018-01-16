//
//  ZKCollectionController.m
//  NNews
//
//  Created by Tom on 2018/1/16.
//  Copyright © 2018年 Tom. All rights reserved.
//

#import "ZKCollectionController.h"

@interface ZKCollectionController ()

@end

@implementation ZKCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarItem];
}

- (void)setNavigationBarItem {
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    self.navigationItem.leftBarButtonItem = left;
    left.imageInsets = UIEdgeInsetsMake(3, -4, 3, 0);
}

- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
