//
//  ZKRegisterViewController.m
//  NNews
//
//  Created by Tom on 2017/11/28.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKRegisterViewController.h"

@interface ZKRegisterViewController ()
@property (nonatomic, strong) UIView * whiteView, *line1, *line2;
@property (nonatomic, strong) UITextField * userName, *passWord, *surePassWord;
@property (nonatomic, strong) UIButton * registerBtn, *returnBtn;
@end

@implementation ZKRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = MainColor;
    [self setUI];
}

#pragma mark - Private Method
- (void)registerAction:(UIButton *)btn{
    
}

- (void)returnAction:(UIButton *)btn {
    
}

- (void)setUI {
    
}

#pragma mark - lazy init

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
