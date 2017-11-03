//
//  ZKNewsTableViewCell.m
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKNewsTableViewCell.h"

@implementation ZKNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView addSubview:self.mainView];
    [self.mainView addSubview:self.headIcon];
    [self.mainView addSubview:self.detailTitle];
    [self.mainView addSubview:self.separatorView];
}

- (void)layoutSubviews {
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.mainView);
        make.width.equalTo(self.headIcon.mas_height);
    }];
    [self.detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIcon.mas_right).offset(10);
        make.right.equalTo(self.mainView);
        make.height.mas_equalTo(self.detailTitle);
        make.centerY.equalTo(self.mainView);
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headIcon.mas_right).offset(0);
        make.right.equalTo(self.mainView);
        make.bottom.equalTo(self.mainView);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void)setModel:(ZKNewsModel *)model {
    _model = model;
    
    NSString * title = model.title;
    self.detailTitle.text = title;
    
    NSString * image = model.image;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:nil];
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

- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] init];
    }
    return _headIcon;
}

- (UILabel *)detailTitle {
    if (!_detailTitle) {
        _detailTitle = [[UILabel alloc] init];
        _detailTitle.textAlignment = NSTextAlignmentLeft;
        _detailTitle.textColor = [UIColor blackColor];
        _detailTitle.font = [UIFont systemFontOfSize:14];
    }
    return _detailTitle;
}

- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = MainColor;
    }
    return _separatorView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
