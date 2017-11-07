//
//  ZKDetailTableViewCell.m
//  NNews
//
//  Created by Tom on 2017/11/4.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKDetailTableViewCell.h"

#define Margin 12

@interface ZKDetailTableViewCell ()
@property (nonatomic, strong) UIView      * mainView;
@property (nonatomic, strong) UIImageView * userIcon; //用户Icon
@property (nonatomic, strong) UIImageView * userSex;  //用户性别
@property (nonatomic, strong) UILabel     * userName; //用户姓名
@property (nonatomic, strong) UILabel     * userComment;
@property (nonatomic, strong) UIButton    * supportButton; //👍
@property (nonatomic, strong) UILabel     * supportNumber; //👍个数
@end

@implementation ZKDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setVideoComment:(ZKTTVideoComment *)videoComment {
    _videoComment = videoComment;
    
}

- (void)layoutSubviews {
    [self setUI];
}

#pragma mark -
#pragma mark lazy init
- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}

- (UIImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [[UIImageView alloc] init];
        _userIcon.backgroundColor = [UIColor clearColor];
    }
    return _userIcon;
}

- (UIImageView *)userSex {
    if (!_userSex) {
        _userSex = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _userSex.backgroundColor = [UIColor clearColor];
    }
    return _userSex;
}

- (UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textColor = [UIColor blackColor];
        _userName.font = [UIFont systemFontOfSize:12];
        _userName.textAlignment = NSTextAlignmentLeft;
    }
    return _userName;
}

- (UIButton *)supportButton {
    if (!_supportButton) {
        _supportButton = [[UIButton alloc] init];
        [_supportButton addTarget:self action:@selector(supportUserComment) forControlEvents:UIControlEventTouchUpInside];
        [_supportButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    return _supportButton;
}

- (UILabel *)supportNumber {
    if (!_supportNumber) {
        _supportNumber = [[UILabel alloc] init];
        _supportNumber.backgroundColor = [UIColor clearColor];
        _supportNumber.textAlignment = NSTextAlignmentRight;
        _supportNumber.textColor = [UIColor blackColor];
    }
    return _supportNumber;
}

#pragma mark - setUI
- (void)setUI{
    [self.contentView addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.mainView addSubview:self.userIcon];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.mainView).offset(Margin);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.mainView addSubview:self.userSex];
    [self.userSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(Margin);
        make.top.equalTo(self.userIcon);
        make.width.height.equalTo(self.userSex);
    }];
}

#pragma mark - Private Method
- (void)supportUserComment{ //👍 评论
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
