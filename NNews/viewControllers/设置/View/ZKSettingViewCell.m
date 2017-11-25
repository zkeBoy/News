//
//  ZKSettingViewCell.m
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKSettingViewCell.h"

@implementation ZKSettingViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMemery) name:@"NSNotificationAboutCleanCachekey" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:@"NSNotificationExchangeHeaderSuccessKey" object:nil];
    }
    return self;
}

- (void)updateMemery {
    NSString * memory = [NSString stringWithFormat:@"%f",[ZKToolManager cacheSize]];
    NSString * part1 = [memory componentsSeparatedByString:@"."].firstObject;
    _memoryLabel.text = [part1 stringByAppendingString:@".0M"];
}

- (void)updateUserInfo {
    NSUserDefaults * defaules = [NSUserDefaults standardUserDefaults];
    NSData * data = [defaules objectForKey:@"exchangeHeadSuccess"];
    UIImage * image = [UIImage imageWithData:data];
    [defaules synchronize];
    if (!data.length) {
        return;
    }
    self.headerView.image = image;
    self.headerView.layer.cornerRadius = 30;
    self.headerView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    if (_model.isHeader) {
        [self setUI1];
    }else{
        [self setUI2];
    }
    [self updateUserInfo];
}

#pragma mark - setUI
- (void)setUI1 {
    [self.mainView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.mainView).offset(Margin*2);
        make.bottom.equalTo(self.mainView).offset(-Margin*2);
        make.width.equalTo(self.headerView.mas_height);
    }];
    
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView);
        make.left.equalTo(self.headerView.mas_right).offset(Margin);
        make.width.height.equalTo(self.titleLabel);
    }];
    
    self.titleLabel.text = NSLocalizedString(@"这家伙很懒，什么也没有留下", nil);
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setUI2 {
    [self.mainView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainView);
        make.left.equalTo(self.mainView).offset(Margin);
        make.width.height.mas_equalTo(20);
    }];
    self.iconView.image = [UIImage imageNamed:_model.icon];
    
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainView);
        make.left.equalTo(self.iconView.mas_right).offset(Margin);
        make.width.height.equalTo(self.titleLabel);
    }];
    self.titleLabel.text = _model.title;
    
    if (_model.cleanMemory) {
        [self.mainView addSubview:self.memoryLabel];
        [self.memoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mainView);
            make.width.height.equalTo(self.memoryLabel);
            make.right.equalTo(self.mainView).offset(-Margin);
        }];
    }else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

#pragma mark - lazy init
- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}

- (UIImageView *)headerView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.image = [UIImage imageNamed:@"user_default"];
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.layer.cornerRadius = 30.f;
        _headerView.layer.masksToBounds = YES;
    }
    return _headerView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor clearColor];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)memoryLabel {
    if (!_memoryLabel) {
        _memoryLabel = [[UILabel alloc] init];
        _memoryLabel.backgroundColor = [UIColor clearColor];
        _memoryLabel.font = [UIFont systemFontOfSize:12];
        _memoryLabel.textColor = [UIColor blackColor];
        _memoryLabel.textAlignment = NSTextAlignmentLeft;
        NSString * memory = [NSString stringWithFormat:@"%f",[ZKToolManager cacheSize]];
        NSString * part1 = [memory componentsSeparatedByString:@"."].firstObject;
        _memoryLabel.text = [part1 stringByAppendingString:@".0M"];
    }
    return _memoryLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
