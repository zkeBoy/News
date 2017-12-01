//
//  ZKSwitchViewCell.m
//  NNews
//
//  Created by Tom on 2017/12/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKSwitchViewCell.h"

@implementation ZKSwitchViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.switchView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(Margin);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.imgView.mas_right).offset(Margin);
        make.width.height.equalTo(self.titleLabel);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(self.switchView);
        make.right.equalTo(self.contentView).offset(-Margin);
    }];
}

- (void)setModel:(ZKSettingModel *)model{
    _model = model;
    
    self.imgView.image = [UIImage imageNamed:model.icon];
    self.titleLabel.text = model.title;
}

#pragma mark - lazy init
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}

- (void)exchangeTemeStyle{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
