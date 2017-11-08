//
//  ZKFunsTableViewCell.m
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKFunsTableViewCell.h"
#define Margin 4

@interface ZKFunsTableViewCell()
@property (nonatomic, strong) UIView      * mainView;     //主View
@property (nonatomic, strong) UIImageView * userIcon;     //用户ICON
@property (nonatomic, strong) UILabel     * userName;    //视频名称
@property (nonatomic, strong) UILabel     * timeTitle;    //视频时间
@property (nonatomic, strong) UILabel     * commentTitle; //评论
@property (nonatomic, strong) UIImageView * coverImage;   //封面
@property (nonatomic, strong) UILabel     * watchNumber;  //观看人数
@property (nonatomic, strong) UIImageView * loadingView;  //video-play
@end

@implementation ZKFunsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [self setUI];
}

- (void)setVideoModel:(ZKTTVideo *)videoModel{
    _videoModel = videoModel;
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:videoModel.profile_image] placeholderImage:[UIImage imageNamed:@"bg_default_image"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.userIcon.layer.cornerRadius = 20.f;
        self.userIcon.layer.masksToBounds = YES;
    }];
    
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:videoModel.image1]];
    
    self.userName.text = videoModel.screen_name;
    self.timeTitle.text = videoModel.created_at;
    self.commentTitle.text = videoModel.text;
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

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor redColor];
        _userName.font = [UIFont systemFontOfSize:14];
        _userName.textAlignment = NSTextAlignmentLeft;
    }
    return _userName;
}

- (UILabel *)timeTitle {
    if (!_timeTitle) {
        _timeTitle = [[UILabel alloc] init];
        _timeTitle.textColor = [UIColor blackColor];
        _timeTitle.backgroundColor = [UIColor clearColor];
        _timeTitle.font = [UIFont systemFontOfSize:12];
        _timeTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _timeTitle;
}

- (UILabel *)commentTitle {
    if (!_commentTitle) {
        _commentTitle = [[UILabel alloc] init];
        _commentTitle.textColor = [UIColor blackColor];
        _commentTitle.backgroundColor = [UIColor clearColor];
        _commentTitle.font = [UIFont systemFontOfSize:14];
        _commentTitle.textAlignment = NSTextAlignmentLeft;
        
        /*用于文字换行自适应*/
        //_commentTitle.numberOfLines = 0;
        //_commentTitle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _commentTitle;
}

- (UIImageView *)coverImage{
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] init];
        _coverImage.backgroundColor = [UIColor clearColor];
        _coverImage.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpInSideCoverImage)];
        [_coverImage addGestureRecognizer:tap];
    }
    return _coverImage;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_play"]];
        _loadingView.backgroundColor = [UIColor clearColor];
        //_loadingView.userInteractionEnabled = YES;
    }
    return _loadingView;
}

- (void)touchUpInSideCoverImage{
    if ([self.delegate respondsToSelector:@selector(clickVideoPlay:)]) {
        [self.delegate clickVideoPlay:self.indexPath];
    }
}

#pragma mark -
#pragma mark SETUI
- (void)setUI{
    [self.contentView addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.mainView addSubview:self.userIcon];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView).offset(0);
        make.left.equalTo(self.mainView).offset(Margin);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.mainView addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView).offset(Margin);
        make.left.equalTo(self.userIcon.mas_right).offset(Margin);
        make.width.equalTo(self.userName);
    }];
    
    [self.mainView addSubview:self.timeTitle];
    [self.timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.bottom.equalTo(self.userIcon.mas_bottom).offset(0);
        make.width.equalTo(self.timeTitle);
    }];
    
    [self.mainView addSubview:self.commentTitle];
    [self.commentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mas_bottom).offset(Margin);
        make.left.equalTo(self.userIcon).offset(Margin);
        make.right.equalTo(self.mainView).offset(-Margin);
        make.height.equalTo(self.commentTitle);
    }];
    
    [self.mainView addSubview:self.coverImage];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentTitle.mas_bottom).offset(Margin);
        make.left.equalTo(self.mainView).offset(Margin);
        make.right.bottom.equalTo(self.mainView).offset(-Margin);
        make.height.equalTo(self.coverImage);
    }];
    
    [self.coverImage addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.coverImage);
        make.width.height.equalTo(self.loadingView);
    }];
}

- (CGRect)videnPlayFrame{
    return self.coverImage.frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
