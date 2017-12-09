//
//  ZKHomeDefaultCell.m
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKHomeDefaultCell.h"

@implementation ZKHomeDefaultCell

- (void)setModel:(ZKHomeModel *)model {
    _model = model;
    
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]];
    self.titleLabel.text = model.title;
    self.sourceLabel.text = model.source;
    
    CGFloat count =  [model.replyCount intValue];
    NSString *displayCount;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f跟帖",count];
    }
    self.replayLabel.text = displayCount;
    CGRect frame = [displayCount boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil];
    CGFloat width = CGRectGetWidth(frame)+4;
    CGFloat height = CGRectGetHeight(frame)+4;
    self.replayLabel.frame = CGRectMake(D_WIDTH-width-8, 72-height, width, height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView addSubview:self.imgIcon];
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.mas_equalTo(80);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.imgIcon.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.contentView addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgIcon.mas_right).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.height.equalTo(self.sourceLabel);
    }];
    
    [self.contentView addSubview:self.replayLabel];
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        _imgIcon = [[UIImageView alloc] init];
        _imgIcon.backgroundColor = [UIColor clearColor];
    }
    return _imgIcon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

- (UILabel *)sourceLabel {
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.backgroundColor = [UIColor clearColor];
        _sourceLabel.textColor = [UIColor grayColor];
        _sourceLabel.textAlignment = NSTextAlignmentLeft;
        _sourceLabel.font = [UIFont systemFontOfSize:10];
    }
    return _sourceLabel;
}

- (UILabel *)replayLabel {
    if (!_replayLabel) {
        _replayLabel = [[UILabel alloc] init];
        _replayLabel.backgroundColor = [UIColor clearColor];
        _replayLabel.textColor = [UIColor grayColor];
        _replayLabel.textAlignment = NSTextAlignmentCenter;
        _replayLabel.font = [UIFont systemFontOfSize:10];
        _replayLabel.layer.cornerRadius = 5.0f;
        _replayLabel.layer.borderWidth = 1.0f;
        _replayLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _replayLabel.layer.masksToBounds = YES;
    }
    return _replayLabel;
}

@end
