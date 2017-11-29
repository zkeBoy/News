//
//  ZKRegisterViewController.m
//  NNews
//
//  Created by Tom on 2017/11/28.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKRegisterViewController.h"

@interface ZKRegisterViewController ()<UITextFieldDelegate>
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
    ZKUser * user = [[ZKUser alloc] init];
    user.userName = self.userName.text;
    user.passWord = self.passWord.text;
    if ([self.passWord.text isEqualToString:self.passWord.text]) {
        [ZKHelperView showWaitingView];
        [ZKBmobManager bmobInsertUser:user result:^(BOOL success, NSError *error) {
            if (success) {
                [ZKHelperView hideWaitingMessage:NSLocalizedString(@"注册成功!", nil)];
                [self returnAction:nil];
                [ZKBmobManager loginSuccess:user];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.delegate registerSuccess];
                });
            }else{
                
            }
        }];
    }else{//密码不相同
        
    }
}

- (void)returnAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUI {
    self.whiteView = [self createView];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(D_WIDTH* 0.92);
        make.height.mas_equalTo(120);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(NavBarH+StatusH);
    }];
    
    self.line1 = [self createView];
    self.line1.backgroundColor = [UIColor colorWithRed:166/255.0 green:166/255.0  blue:166/255.0  alpha:1];
    [self.whiteView addSubview:self.line1];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.whiteView);
        make.height.equalTo(@1);
        make.top.equalTo(self.whiteView).offset(40);
    }];
    
    self.line2 = [self createView];
    self.line2.backgroundColor = [UIColor colorWithRed:166/255.0 green:166/255.0  blue:166/255.0  alpha:1];
    [self.whiteView addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.whiteView);
        make.height.equalTo(@1);
        make.top.equalTo(self.whiteView).offset(80);
    }];
    
    [self.whiteView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView);
        make.left.equalTo(self.whiteView).offset(StatusH);
        make.right.equalTo(self.whiteView).offset(-StatusH);
        make.height.mas_equalTo(40);
    }];
    
    [self.whiteView addSubview:self.passWord];
    [self.passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView).offset(40);
        make.left.equalTo(self.whiteView).offset(StatusH);
        make.right.equalTo(self.whiteView).offset(-StatusH);
        make.height.mas_equalTo(40);
    }];
    
    [self.whiteView addSubview:self.surePassWord];
    [self.surePassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteView).offset(80);
        make.left.equalTo(self.whiteView).offset(StatusH);
        make.right.equalTo(self.whiteView).offset(-StatusH);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(D_WIDTH* 0.92);
        make.height.equalTo(@40);
        make.top.equalTo(self.whiteView.mas_bottom).offset(StatusH);
    }];
    
    [self.view addSubview:self.returnBtn];
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.equalTo(@40);
        make.top.equalTo(self.registerBtn.mas_bottom).offset(StatusH+10);
    }];
}

#pragma mark - lazy init
- (UIView *)createView {
    return [[UIView alloc] init];
}

- (UITextField *)userName {
    if (!_userName) {
        _userName = [[UITextField alloc] initWithFrame:CGRectZero];
        _userName.delegate = self;
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        _userName.font = [UIFont fontWithName:@"Times New Roman" size:12];
        _userName.placeholder = @"请输入用户名";
        _userName.autocorrectionType = UITextAutocorrectionTypeNo;
        _userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _userName;
}

- (UITextField *)passWord {
    if (!_passWord) {
        _passWord = [[UITextField alloc] initWithFrame:CGRectZero];
        _passWord.delegate = self;
        _passWord.backgroundColor = [UIColor clearColor];
        _passWord.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        _passWord.font = [UIFont fontWithName:@"Times New Roman" size:12];
        _passWord.placeholder = @"请输入密码";
        _passWord.secureTextEntry = YES;
        _passWord.autocorrectionType = UITextAutocorrectionTypeNo;
        _passWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _passWord;
}

- (UITextField *)surePassWord {
    if (!_surePassWord) {
        _surePassWord = [[UITextField alloc] initWithFrame:CGRectZero];
        _surePassWord.delegate = self;
        _surePassWord.backgroundColor = [UIColor clearColor];
        _surePassWord.textColor = [UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:1];
        _surePassWord.font = [UIFont fontWithName:@"Times New Roman" size:12];
        _surePassWord.placeholder = @"再次确认密码";
        _surePassWord.secureTextEntry = YES;
        _surePassWord.autocorrectionType = UITextAutocorrectionTypeNo;
        _surePassWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _surePassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _surePassWord;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _registerBtn.layer.cornerRadius = 4;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:118/255.0 alpha:1]];
        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (UIButton *)returnBtn {
    if (!_returnBtn) {
        _returnBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_returnBtn setTitle:@"返回登录" forState:UIControlStateNormal];
        _returnBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_returnBtn setTitleColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:118/255.0 alpha:1] forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
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
