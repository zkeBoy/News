//
//  ZKHomeImgsCell.m
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKHomeImgsCell.h"

#define I_W (D_WIDTH-32)/3

@implementation ZKHomeImgsCell

- (void)setModel:(ZKHomeModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.sourceLabel.text = model.source;
    
    [self.imgIcon1 sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.imgIcon2 sd_setImageWithURL:[NSURL URLWithString:model.imgextra[0][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.imgIcon3 sd_setImageWithURL:[NSURL URLWithString:model.imgextra[1][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
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
    CGFloat originY = 100;
    self.replayLabel.frame = CGRectMake(D_WIDTH-width-8, originY, width, height);
    [self.contentView addSubview:self.replayLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.frame = CGRectMake(8, 8, D_WIDTH-16, 12);
    
    [self.contentView addSubview:self.imgIcon1];
    self.imgIcon1.frame = CGRectMake(8, 12+16, I_W, 80-16);
    
    [self.contentView addSubview:self.imgIcon2];
    self.imgIcon2.frame = CGRectMake(16+I_W, 12+16, I_W, 80-16);
    
    [self.contentView addSubview:self.imgIcon3];
    self.imgIcon3.frame = CGRectMake(24+I_W*2, 12+16, I_W, 80-16);
    
    [self.contentView addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.height.equalTo(self.sourceLabel);
    }];
}

#pragma mark - lazy init
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

- (UIImageView *)imgIcon1 {
    if (!_imgIcon1) {
        _imgIcon1 = [[UIImageView alloc] init];
    }
    return _imgIcon1;
}

- (UIImageView *)imgIcon2 {
    if (!_imgIcon2) {
        _imgIcon2 = [[UIImageView alloc] init];
    }
    return _imgIcon2;
}

- (UIImageView *)imgIcon3 {
    if (!_imgIcon3) {
        _imgIcon3 = [[UIImageView alloc] init];
    }
    return _imgIcon3;
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
