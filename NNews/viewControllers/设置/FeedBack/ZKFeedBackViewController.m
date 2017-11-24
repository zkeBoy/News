//
//  ZKFeedBackViewController.m
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKFeedBackViewController.h"

@interface ZKFeedBackViewController ()

@end

@implementation ZKFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"反馈", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarItem];
}

- (void)setNavigationBarItem {
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    self.navigationItem.leftBarButtonItem = left;
    left.imageInsets = UIEdgeInsetsMake(3, -4, 3, 0);
}

#pragma mark -
- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
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
