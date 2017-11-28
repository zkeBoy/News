//
//  ZKLoginViewController.m
//  NNews
//
//  Created by Tom on 2017/11/28.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKLoginViewController.h"
#import "ZKRegisterViewController.h"

@interface ZKLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView * userIconView;
@property (nonatomic, strong) UIView      * whiteView, *dividingLine;
@property (nonatomic, strong) UITextField * userName, *passWord;
@property (nonatomic, strong) UIButton    * loginBtn, *registerBtn;

@end

@implementation ZKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = MainColor;
    [self setUI];
}

#pragma mark - Private Method
- (void)loginClicked:(UIButton *)btn {
    
}

- (void)registerClicked:(UIButton *)btn {
    ZKRegisterViewController * registerVC = [[ZKRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = textField.frame;
    //  所加的数字 83   默认为32  因为键盘上方还会出现联想提示文字框，所以多加一些
    int offset = frame.origin.y + 83 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

//简单实现 点击空白 收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userName resignFirstResponder];
    [self.passWord resignFirstResponder];
}

- (void)setUI {
    [self.view addSubview:self.userIconView];
    [self.userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(D_HEIGHT*0.142);
        make.width.height.mas_equalTo(100);
    }];
    
    self.whiteView = [self createView];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(D_WIDTH* 0.92);
        make.height.mas_equalTo(80);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.userIconView.mas_bottom).offset(50);
    }];
    
    self.dividingLine = [self createView];
    self.dividingLine.backgroundColor = [UIColor colorWithRed:166/255.0 green:166/255.0  blue:166/255.0  alpha:1];
    [self.whiteView addSubview:self.dividingLine];
    [self.dividingLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.width.equalTo(self.whiteView);
        make.height.equalTo(@1);
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
        make.bottom.equalTo(self.whiteView);
        make.left.equalTo(self.whiteView).offset(StatusH);
        make.right.equalTo(self.whiteView).offset(-StatusH);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(D_WIDTH* 0.92);
        make.height.equalTo(@40);
        make.top.equalTo(self.whiteView.mas_bottom).offset(StatusH);
    }];
    
    [self.view addSubview:self.registerBtn];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(D_WIDTH* 0.92);
        make.height.equalTo(@40);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(StatusH*2);
    }];
}

#pragma mark - lazy init
- (UIImageView *)userIconView {
    if (!_userIconView) {
        _userIconView = [[UIImageView alloc] init];
        _userIconView.image = [UIImage imageNamed:@"user_default"];
        _userIconView.layer.cornerRadius = 50;
    }
    return _userIconView;
}

- (UIView *)createView {
    UIView * view = [[UIView alloc] init];
    return view;
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

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:118/255.0 alpha:1]];
        [_loginBtn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_registerBtn setTitle:@"没有账号？快来注册" forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_registerBtn setTitleColor:[UIColor colorWithRed:107/255.0 green:107/255.0 blue:118/255.0 alpha:1] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
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
