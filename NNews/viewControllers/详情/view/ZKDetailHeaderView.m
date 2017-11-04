//
//  ZKDetailHeaderView.m
//  NNews
//
//  Created by Tom on 2017/11/4.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKDetailHeaderView.h"

#define Margin 4 //view 之间的边距

@interface ZKDetailHeaderView ()
@property (nonatomic, strong) UIImageView * userIcon;     //用户ICON
@property (nonatomic, strong) UILabel     * userName;     //用户名称
@property (nonatomic, strong) UILabel     * timeTitle;    //视频时间
@property (nonatomic, strong) UIImageView * coverImage;   //封面

@property (nonatomic, strong) UIImageView * loadIngView;  //video_play
@property (nonatomic, strong) UILabel     * watchNumber;  //观看人数,视频评论有
@property (nonatomic, strong) UILabel     * playTimes;    //播放次数,视频评论有

@property (nonatomic, strong) UILabel     * pictureCommentTitle; //图片评论

@property (nonatomic, strong) UIButton    * moreInfoBtn; //更多详情界面 see-big-picture

@end

@implementation ZKDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setType:(detailType)type {
    _type = type;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setUI];
}

- (void)setVideoModel:(ZKTTVideo *)videoModel {
    _videoModel = videoModel;
    
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:videoModel.profile_image] placeholderImage:[UIImage imageNamed:@"bg_default_image"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.userIcon.layer.cornerRadius = 20.f;
        self.userIcon.layer.masksToBounds = YES;
    }];
    
    self.userName.text = videoModel.screen_name;
    self.timeTitle.text = videoModel.created_at;
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:videoModel.image1]];
}

#pragma mark -
#pragma mark setUI
- (void)setUI{
    [self addSubview:self.userIcon];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(Margin);
        make.width.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.userName];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Margin);
        make.left.equalTo(self.userIcon.mas_right).offset(Margin);
        make.width.equalTo(self.userName);
    }];
    
    [self addSubview:self.timeTitle];
    [self.timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.bottom.equalTo(self.userIcon.mas_bottom).offset(0);
        make.width.equalTo(self.timeTitle);
    }];
    
    [self addSubview:self.coverImage];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Margin);
        make.top.equalTo(self.timeTitle.mas_bottom).offset(Margin);
        make.bottom.right.equalTo(self).offset(-Margin);
    }];
    
    if (self.type==typeVideo) {
        [self.coverImage addSubview:self.loadIngView];
        [self.loadIngView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.coverImage);
            make.width.height.equalTo(self.loadIngView);
        }];
    }else if (self.type==typePicture){
        
    }
    
    
}

#pragma mark - Private Method
- (void)playVideo {
    if (self.type==typeVideo) {
        NSString * videoLink = self.videoModel.videouri;
        [self.delegate startPlayVideo:videoLink];
    }else {
        
    }
}

#pragma mark - Out Action
- (CGRect)coverFrame {
    CGRect frame = self.coverImage.frame;
    return frame;
}

#pragma mark - lazy init
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
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.font = [UIFont systemFontOfSize:14];
        _userName.textColor = [UIColor redColor];
    }
    return _userName;
}

- (UILabel *)timeTitle {
    if (!_timeTitle) {
        _timeTitle = [[UILabel alloc] init];
        _timeTitle.textAlignment = NSTextAlignmentLeft;
        _timeTitle.font = [UIFont systemFontOfSize:14];
        _timeTitle.textColor = [UIColor blackColor];
    }
    return _timeTitle;
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] init];
        _coverImage.backgroundColor = [UIColor clearColor];
        //_coverImage.image = [UIImage imageNamed:@"bg_media_default"];
        _coverImage.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
        [_coverImage addGestureRecognizer:tap];
    }
    return _coverImage;
}

- (UIImageView *)loadIngView {
    if (!_loadIngView) {
        _loadIngView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_play"]];
        _loadIngView.userInteractionEnabled = NO;
    }
    return _loadIngView;
}

- (UILabel *)watchNumber {
    if (!_watchNumber) {
        _watchNumber = [[UILabel alloc] init];
        _watchNumber.textAlignment = NSTextAlignmentLeft;
        _watchNumber.textColor = [UIColor blackColor];
        _watchNumber.font = [UIFont systemFontOfSize:14];
    }
    return _watchNumber;
}

- (UILabel *)playTimes {
    if (!_playTimes) {
        _playTimes = [[UILabel alloc] init];
        _playTimes.textAlignment = NSTextAlignmentLeft;
        _playTimes.textColor = [UIColor blackColor];
        _playTimes.font = [UIFont systemFontOfSize:14];
    }
    return _playTimes;
}

- (UILabel *)pictureCommentTitle {
    if (!_pictureCommentTitle) {
        _pictureCommentTitle = [[UILabel alloc] init];
        _pictureCommentTitle.textColor = [UIColor blackColor];
        _pictureCommentTitle.textAlignment = NSTextAlignmentLeft;
        _pictureCommentTitle.font = [UIFont systemFontOfSize:14];
    }
    return _pictureCommentTitle;
}

- (UIButton *)moreInfoBtn {
    if (!_moreInfoBtn) {
        _moreInfoBtn = [[UIButton alloc] init];
        _moreInfoBtn.backgroundColor = [UIColor clearColor];
        [_moreInfoBtn setImage:[UIImage imageNamed:@"see-big-picture"] forState:UIControlStateNormal];
        [_moreInfoBtn setTitle:@"查看大图" forState:UIControlStateNormal];
        [_moreInfoBtn setBackgroundImage:[UIImage imageNamed:@"see-big-picture-background"] forState:UIControlStateNormal];
    }
    return _moreInfoBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
