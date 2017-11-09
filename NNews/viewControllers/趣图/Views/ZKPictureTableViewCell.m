//
//  ZKPictureTableViewCell.m
//  NNews
//
//  Created by Tom on 2017/11/8.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKPictureTableViewCell.h"
#import <DACircularProgressView.h>

@interface ZKPictureTableViewCell ()
@property (nonatomic, strong) UIView      * mainView;
@property (nonatomic, strong) UIImageView * headIcon;
@property (nonatomic, strong) UILabel     * userName;
@property (nonatomic, strong) UILabel     * timeLabel;
@property (nonatomic, strong) UILabel     * commentLabel;
@property (nonatomic, strong) FLAnimatedImageView * pictureView;
@property (nonatomic, strong) UIButton    * seePictureBtn;
@property (nonatomic, strong) DALabeledCircularProgressView * progressView;
@property (nonatomic, strong) UIImageView * giftView;
@end

#define Margin 10
#define W_H 24

@implementation ZKPictureTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUI];
}

- (void)setPictureModel:(ZKTTPicture *)pictureModel {
    _pictureModel = pictureModel;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:pictureModel.profile_image] placeholderImage:[UIImage imageNamed:@"user_Default_Icon"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.headIcon.layer.cornerRadius = W_H/2;
            self.headIcon.layer.masksToBounds = YES;
        }
    }];
    
    self.userName.text = pictureModel.screen_name;
    self.timeLabel.text = pictureModel.created_at;
    self.commentLabel.text = pictureModel.text;
    
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:pictureModel.image1] placeholderImage:[UIImage imageNamed:@""] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        CGFloat progress = 1.0*receivedSize/expectedSize;
        NSString *text = [NSString stringWithFormat:@"%.0f%%", 100*progress];
        self.progressView.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [self.progressView setProgress:progress animated:YES];
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.progressView.hidden = YES;
        if (pictureModel.isBigPicture) { //大图
            self.seePictureBtn.hidden = NO;
            //截取上面一截
            CGSize size = CGSizeMake(D_WIDTH, pictureModel.cellHeight);
            UIGraphicsBeginImageContextWithOptions(size, YES, 0);
            CGFloat w = D_WIDTH;
            CGFloat h = w * image.size.height / image.size.width;
            [image drawInRect:CGRectMake(0, 0, w, h)];
            self.pictureView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }else { //小图
            self.seePictureBtn.hidden = YES;
            self.pictureView.contentMode = UIViewContentModeScaleToFill; //适配图片的大小
        }
    }];  
    
    //判断是否是gift图片
    NSString *pathExtension = pictureModel.image1.pathExtension;
    if ([pathExtension.lowercaseString isEqualToString:@"gif"]) {
        self.giftView.hidden = NO;
    }else{
        self.giftView.hidden = YES;
    }
}


#pragma mark -
#pragma mark lazy init
- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectZero];
        _mainView.backgroundColor = [UIColor clearColor];
    }
    return _mainView;
}

- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headIcon.backgroundColor = [UIColor clearColor];
        _headIcon.layer.cornerRadius = W_H;
        _headIcon.layer.masksToBounds = YES;
    }
    return _headIcon;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textColor = [UIColor redColor];
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.font = [UIFont systemFontOfSize:12];
    }
    return _userName;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.textColor = [UIColor blackColor];
        _commentLabel.textAlignment = NSTextAlignmentLeft;
        _commentLabel.font = [UIFont systemFontOfSize:12];
        _commentLabel.numberOfLines = 0;
        _commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _commentLabel;
}

- (FLAnimatedImageView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[FLAnimatedImageView alloc] init];
        _pictureView.backgroundColor = [UIColor clearColor];
        _pictureView.userInteractionEnabled = YES;
        //_pictureView.runLoopMode = NSRunLoopCommonModes;
    }
    return _pictureView;
}

- (DALabeledCircularProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[DALabeledCircularProgressView alloc] init];
        _progressView.roundedCorners = 2;
    }
    return _progressView;
}

- (UIButton *)seePictureBtn {
    if (!_seePictureBtn) {
        _seePictureBtn = [[UIButton alloc] init];
        _seePictureBtn.backgroundColor = [UIColor clearColor];
        [_seePictureBtn setBackgroundImage:[UIImage imageNamed:@"see_big_picture_background"] forState:UIControlStateNormal];
        [_seePictureBtn addTarget:self action:@selector(seeBigPictureAction) forControlEvents:UIControlEventTouchUpInside];
        [_seePictureBtn setImage:[UIImage imageNamed:@"see_big_picture"] forState:UIControlStateNormal];
        [_seePictureBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        //[_seePictureBtn setTitle:@"查看大图" forState:UIControlStateNormal];
    }
    return _seePictureBtn;
}

- (UIImageView *)giftView {
    if (!_giftView) {
        _giftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picture_gif"]];
    }
    return _giftView;
}

#pragma mark - setUI
- (void)setUI{
    [self.contentView addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.mainView addSubview:self.headIcon];
    [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.mainView).offset(Margin);
        make.width.height.mas_equalTo(W_H);
    }];
    
    [self.mainView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headIcon);
        make.left.equalTo(self.headIcon.mas_right).offset(Margin);
        make.width.height.equalTo(self.userName);
    }];
    
    [self.mainView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).offset(4);
        make.left.equalTo(self.userName);
        make.width.height.equalTo(self.timeLabel);
    }];
    
    
    [self.mainView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(Margin);
        make.left.equalTo(self.headIcon);
        make.right.equalTo(self.mainView).offset(-Margin);
        make.width.height.equalTo(self.commentLabel);
    }];
    
    [self.mainView addSubview:self.pictureView];
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.mainView);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(Margin);
        make.bottom.equalTo(self.mainView.mas_bottom).offset(0);
    }];
    
    [self.pictureView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pictureView);
        make.width.height.mas_equalTo (Scale(60));
    }];
    
    [self.pictureView addSubview:self.seePictureBtn];
    [self.seePictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.pictureView);
        make.height.mas_equalTo(40);
    }];
    
    [self.pictureView addSubview:self.giftView];
    [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.pictureView);
        make.width.height.mas_equalTo(36);
    }];
}

#pragma mark - Private Method
- (void)seeBigPictureAction{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
