//
//  ZKVideoPlayView.m
//  NNews
//
//  Created by Tom on 2017/11/2.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKVideoPlayView.h"

@interface ZKVideoPlayView()
@property (nonatomic, strong) UIImageView             * backgroundView;
@property (nonatomic, strong) UIActivityIndicatorView * loadingView;
@property (nonatomic, strong) UIView                  * bottomBar;
@property (nonatomic, strong) UIButton                * playButton;
@property (nonatomic, strong) UISlider                * progressView;
@property (nonatomic, strong) UILabel                 * timeLabel;
@property (nonatomic, strong) UIButton                * fullButton;
@end

@implementation ZKVideoPlayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

#pragma mark -
#pragma mark lazy init
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundView.image = [UIImage imageNamed:@"bg_media_default"];
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}

- (UIActivityIndicatorView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingView.hidesWhenStopped = YES;
    }
    return _loadingView;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] init];
        _bottomBar.backgroundColor = [UIColor blackColor];
    }
    return _bottomBar;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _playButton.backgroundColor = [UIColor clearColor];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"paly_play_btn"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"paly_pause_btn"] forState:UIControlStateSelected];
    }
    return _playButton;
}

- (UISlider *)progressView {
    if (!_progressView) {
        _progressView = [[UISlider alloc] init];
        _progressView.minimumValue = 0;//设置最小值
        _progressView.maximumValue = 1;//设置最大值
        _progressView.value = 0.0;     //设置默认值
        [_progressView addTarget:self action:@selector(exchangePlaySpeed:) forControlEvents:UIControlEventValueChanged];
        /*
        _progressView.minimumTrackTintColor = [UIColor redColor]; //走过的颜色
        _progressView.maximumTrackTintColor = [UIColor yellowColor]; //剩余的颜色
        _progressView.thumbTintColor = [UIColor purpleColor]; //圆形颜色
         */
    }
    return _progressView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _timeLabel;
}



#pragma mark - SETUI
- (void)setUI{
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.backgroundView).offset(0);
        make.height.mas_equalTo(@50);
    }];
    
    [self.bottomBar addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(4);
        make.centerY.equalTo(self.playButton);
        make.width.equalTo(@120);
        make.height.equalTo(self.progressView);
    }];
    
    [self.bottomBar addSubview:self.fullButton];
    [self.fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.bottomBar);
        make.width.equalTo(self.fullButton.mas_height);
    }];
}

#pragma mark - Private Method
- (void)stoploadAnimation{
    if (!self.loadingView.isAnimating) { //正在动画
        [self.loadingView stopAnimating];
    }
}

- (void)startloadAnimation{
    if (self.loadingView.isAnimating) { //正在动画
        [self.loadingView startAnimating];
    }
}

//播放与暂停
- (void)clickPlayBtn:(UIButton *)btn{
    BOOL select = self.playButton.selected = !btn.isSelected;
    if (select) {//play
        
    }else{//pause
        
    }
}

//点击全屏
- (void)clickFullBtn:(UIButton *)btn{
    BOOL isFull = self.playButton.selected = !btn.isSelected;
    if (isFull) {//max
        
    }else{//min
        
    }
}

//播放进度改变
- (void)exchangePlaySpeed:(UISlider *)slider{
    
}

#pragma mark - Out Action


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
