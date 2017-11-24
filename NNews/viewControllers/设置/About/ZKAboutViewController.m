//
//  ZKAboutViewController.m
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKAboutViewController.h"

@interface ZKAboutViewController ()
@property (nonatomic, strong) UIImageView * iconImgView;
@property (nonatomic, strong) UILabel     * titleLabel;
@property (nonatomic, strong) UILabel     * subTitleLabel;
@property (nonatomic, strong) UILabel     * bottomLabel;
@end

@implementation ZKAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"关于", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarItem];
    [self setUI];
}

- (void)setNavigationBarItem {
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    self.navigationItem.leftBarButtonItem = left;
    left.imageInsets = UIEdgeInsetsMake(3, -4, 3, 0);
}

#pragma mark - Private Method
- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUI {
    [self.view addSubview:self.iconImgView];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(Scale(100));
        make.top.equalTo(self.view).offset(Scale(100+NavBarH));
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(self.titleLabel);
        make.top.equalTo(self.iconImgView.mas_bottom).offset(Margin);
    }];
    
    [self.view addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(self.subTitleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(Margin);
    }];
    
    [self.view addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(self.bottomLabel);
        make.bottom.equalTo(self.view).offset(-Margin*2);
    }];
}

#pragma mark - lazy init
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"bg_default_image"];
        _iconImgView.backgroundColor = [UIColor clearColor];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = NSLocalizedString(@"生活", nil);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.text = NSLocalizedString(@"Please Enjoy Everyday", nil);
    }
    return _subTitleLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.backgroundColor = [UIColor clearColor];
        _bottomLabel.textColor = [UIColor blackColor];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = [UIFont systemFontOfSize:16];
        //_bottomLabel.text = NSLocalizedString(@"Love life, enjoy every day", nil);
        NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"icon_love"];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Love life, enjoy every day", nil)];
        [att appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        _bottomLabel.attributedText = att;
    }
    return _bottomLabel;
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
