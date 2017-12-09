//
//  ZKHomeTexCell.m
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKHomeTextCell.h"

@implementation ZKHomeTextCell

- (void)setModel:(ZKHomeModel *)model {
    _model = model;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]];
    self.subTitleLabel.text = model.title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:self.imgIcon];
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
    
    [self.contentView addSubview:self.defaultIcon];
    [self.defaultIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.top.equalTo(self.imgIcon.mas_bottom).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.mas_equalTo(14);
    }];
    
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.defaultIcon.mas_centerY);
        make.left.equalTo(self.defaultIcon.mas_right).offset(8);
        make.height.equalTo(self.subTitleLabel);
        make.right.equalTo(self.contentView).offset(-8);
    }];
}

#pragma mark - lazy init
- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
    }
    return _imgIcon;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textColor = [UIColor blackColor];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.font = [UIFont systemFontOfSize:16];
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _subTitleLabel;
}

- (UIImageView *)defaultIcon {
    if (!_defaultIcon) {
        _defaultIcon = [[UIImageView alloc] init];
        _defaultIcon.image = [UIImage imageNamed:@""];
    }
    return _defaultIcon;
}

@end
