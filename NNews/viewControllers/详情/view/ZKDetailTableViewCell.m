//
//  ZKDetailTableViewCell.m
//  NNews
//
//  Created by Tom on 2017/11/4.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKDetailTableViewCell.h"

#define Margin 10
#define I_W 24

@interface ZKDetailTableViewCell ()
@property (nonatomic, strong) UIView      * mainView;
@property (nonatomic, strong) UIImageView * userIcon; //用户Icon
@property (nonatomic, strong) UIImageView * userSex;  //用户性别
@property (nonatomic, strong) UILabel     * userName; //用户姓名
@property (nonatomic, strong) UILabel     * userComment; //用户评论的内容
@property (nonatomic, strong) UIButton    * supportButton; //👍
@property (nonatomic, strong) UILabel     * supportNumber; //👍个数
@end

@implementation ZKDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setVideoComment:(ZKTTVideoComment *)videoComment {
    _videoComment = videoComment;
    NSString * headURL = videoComment.user.profile_image;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.userIcon.layer.cornerRadius = I_W/2;
        self.userIcon.layer.masksToBounds = YES;
    }];
    
    self.userName.text = videoComment.user.username;
    
    self.userComment.text = videoComment.content;
    
    self.supportNumber.text = [NSString stringWithFormat:@"%ld",(long)videoComment.like_count];
    
    NSString * sex = videoComment.user.sex;
    if ([sex isEqualToString:@"m"]) {
        self.userSex.image = [UIImage imageNamed:@"user_sex_man"];
    }else {
        self.userSex.image = [UIImage imageNamed:@"user_sex_woman"];
    }
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
        _userSex = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_sex_man"]];
        _userSex.backgroundColor = [UIColor clearColor];
    }
    return _userSex;
}

- (UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textColor = [UIColor redColor];
        _userName.font = [UIFont systemFontOfSize:12];
        _userName.textAlignment = NSTextAlignmentLeft;
    }
    return _userName;
}

- (UILabel *)userComment {
    if (!_userComment) {
        _userComment = [[UILabel alloc] init];
        _userComment.backgroundColor = [UIColor clearColor];
        _userComment.textColor = [UIColor blackColor];
        _userComment.font = [UIFont systemFontOfSize:12];
        _userComment.textAlignment = NSTextAlignmentLeft;
        _userComment.numberOfLines = 0;
        _userComment.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _userComment;
}

- (UIButton *)supportButton {
    if (!_supportButton) {
        _supportButton = [[UIButton alloc] init];
        [_supportButton addTarget:self action:@selector(supportUserComment) forControlEvents:UIControlEventTouchUpInside];
        [_supportButton setBackgroundImage:[UIImage imageNamed:@"user_support"] forState:UIControlStateNormal];
        //_supportButton.hidden = YES; // 暂时隐藏掉,没有点赞的接口
    }
    return _supportButton;
}

- (UILabel *)supportNumber {
    if (!_supportNumber) {
        _supportNumber = [[UILabel alloc] init];
        _supportNumber.backgroundColor = [UIColor clearColor];
        _supportNumber.textAlignment = NSTextAlignmentRight;
        _supportNumber.textColor = [UIColor blackColor];
        _supportNumber.font = [UIFont systemFontOfSize:12];
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
        make.width.height.mas_equalTo(I_W);
    }];
    
    [self.mainView addSubview:self.userSex];
    [self.userSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(Margin);
        make.top.equalTo(self.userIcon);
        make.width.height.mas_equalTo(13);
    }];
    
    [self.mainView addSubview:self.supportButton];
    [self.supportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon);
        make.right.equalTo(self.mainView).offset(-Margin);
        make.width.height.equalTo(@(18));
    }];
    
    [self.mainView addSubview:self.supportNumber];
    [self.supportNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.supportButton.mas_bottom).offset(Margin);
        make.right.equalTo(self.supportButton.mas_right).offset(-2);
        make.width.height.equalTo(self.supportNumber);
    }];
    
    [self.mainView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userSex.mas_right).offset(4);
        make.top.equalTo(self.userIcon);
        make.right.equalTo(self.supportButton.mas_left).offset(4);
        make.height.equalTo(self.userName);
    }];
    
    [self.mainView addSubview:self.userComment];
    [self.userComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userSex);
        make.top.equalTo(self.userName.mas_bottom).offset(4);
        make.right.equalTo(self.supportButton.mas_left).offset(-4);
        make.height.equalTo(self.userComment);
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
