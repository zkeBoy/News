//
//  ZKPlayerView.m
//  NewDemo
//
//  Created by Tom on 2017/12/9.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKPlayerView.h"

@interface ZKPlayerView()
@property (nonatomic, strong) AVPlayer      * player;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;

@property (nonatomic, strong) UIImageView   * coverImage;
@property (nonatomic, strong) UIButton      * pauseButton;
@property (nonatomic, strong) UIButton      * fullButton;
@property (nonatomic, strong) UILabel       * timeLabel;
@property (nonatomic, strong) UIView        * bottomBar;
@property (nonatomic, strong) UISlider      * progressView;

@property (nonatomic, strong) NSTimer       * playTimer; //播放计时器
@property (nonatomic, strong) NSString      * streamUrl;
@end

static NSString * const playerStatus = @"status";

@implementation ZKPlayerView

- (void)addTapGestureRecognizer{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(changeBottomBarHiddenStatus)];
    [self addGestureRecognizer:tap];
}

- (void)changeBottomBarHiddenStatus{
    self.bottomBar.hidden = !self.bottomBar.hidden;
}

- (instancetype)initWithStreamURL:(NSString *)stremaURL{
    self = [super init];
    if (self) {
        self.animationType = AnimationCurveEaseInOut; //默认类型
        self.streamUrl = stremaURL;
        self.backgroundColor = [UIColor blackColor];
        [self setUpUI];
        [self addTapGestureRecognizer];
        [self setUpPlayer];
        [self showLoading];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 添加播放器
- (void)setUpPlayer {
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.coverImage.layer addSublayer:self.playerLayer];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.streamUrl]];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player addObserver:self forKeyPath:playerStatus options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 监听Player的播放状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:playerStatus]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) { //开始播放
            [self.player play];
            [self hiddenLoading]; //隐藏 loadView
            self.bottomBar.hidden = YES;
            [self fireTimer];     //开启视频进度计时器
        }
    }
}

#pragma mark - 开启定时器
- (void)fireTimer{
    if (!self.playTimer) {
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateVideoPlaySpeed) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
    }else{//继续
        [self.playTimer setFireDate:[NSDate date]];
    }
}

#pragma mark - 暂停定时器
- (void)stopTimer{//暂停
    if (self.playTimer) {
        [self.playTimer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark - 终结定时器
- (void)invalidateTimer{
    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

#pragma mark - 更新播放进度
- (void)updateVideoPlaySpeed{ //更新播放进度
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    if (currentTime>=duration) {//播放结束
        [self finishAnimation];
    }else{ //更新进度
        NSString * text = [NSString stringWithCurrentTime:currentTime duration:duration];
        self.timeLabel.text = text;
        //更新进度条
        self.progressView.value = currentTime/duration;
    }
}

#pragma mark - 播放与暂停
- (void)clickPlayBtn:(UIButton *)btn {
    self.pauseButton.selected = !self.pauseButton.selected;
    if (btn.selected) {
        NSLog(@"pause");
        [self stopTimer];
        [self.player pause];
    }else {
        NSLog(@"play");
        [self fireTimer];
        [self.player play];
    }
}

#pragma mark - 改变播放进度
//start
- (void)startExchangePlaySpeed:(UISlider *)slider{
    [self invalidateTimer];
    self.pauseButton.selected = YES;
    [self.player pause];
}

- (void)exchangePlaySpeed:(UISlider *)slider {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressView.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [NSString stringWithCurrentTime:currentTime duration:duration];
}

//end
- (void)endExchangePlaySpeed:(UISlider *)slider {
    [self fireTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressView.value;
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
    self.pauseButton.selected = NO;
}

#pragma mark - 全屏与缩小
- (void)clickFullButton:(UIButton *)btn {
    if (btn.selected) {
        [self.delegate openFullWindow:NO];
        self.isFull = NO;
    }else {
        [self.delegate openFullWindow:YES];
        self.isFull = YES;
    }
    self.fullButton.selected = !btn.selected;
}

#pragma mark - 重置播放器
- (void)resetPlayer {
    if (self.player&&self.playerLayer) {
        [self.player removeObserver:self forKeyPath:playerStatus]; //移除KVO
        [self.playerLayer removeFromSuperlayer];
        [self.player replaceCurrentItemWithPlayerItem:nil];
        self.player = nil;
        self.playerLayer = nil;
    }
    self.delegate = nil;
    [self invalidateTimer];
    [self removeFromSuperview];
}

#pragma mark - Animation
- (void)finishAnimation {
    [UIView beginAnimations:@"ChangeFrame" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame = CGRectMake(-CGRectGetWidth(self.frame), -CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.delegate playerDidFinish];
    });
}

#pragma mark - Paivate Method
- (void)showLoading{
    [MBProgressHUD showHUDAddedTo:self.coverImage animated:YES];
}

- (void)hiddenLoading{
    [MBProgressHUD hideHUDForView:self.coverImage animated:YES];
}

#pragma mark - lazy init
- (UIImageView *)coverImage {
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc] init];
        _coverImage.image = [UIImage imageNamed:@"bg_media_default.jpg"];
        _coverImage.backgroundColor = [UIColor clearColor];
    }
    return _coverImage;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] init];
        _bottomBar.backgroundColor = [UIColor blackColor];
    }
    return _bottomBar;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_pauseButton setBackgroundImage:[UIImage imageNamed:@"play_pause_btn"] forState:UIControlStateNormal];
        [_pauseButton setBackgroundImage:[UIImage imageNamed:@"play_play_btn"] forState:UIControlStateSelected];
        [_pauseButton addTarget:self action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

- (UISlider *)progressView {
    if (!_progressView) {
        _progressView = [[UISlider alloc] init];
        _progressView.minimumValue = 0;//设置最小值
        _progressView.maximumValue = 1;//设置最大值
        _progressView.value = 0.0;     //设置默认值
        //_progressView.continuous = NO;
        [_progressView addTarget:self action:@selector(startExchangePlaySpeed:) forControlEvents:UIControlEventTouchDown];
        [_progressView addTarget:self action:@selector(exchangePlaySpeed:) forControlEvents:UIControlEventValueChanged];
        [_progressView addTarget:self action:@selector(endExchangePlaySpeed:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView setThumbImage:[UIImage imageNamed:@"video_thumb_Image"] forState:UIControlStateNormal];
        _progressView.minimumTrackTintColor = [UIColor whiteColor]; //走过的颜色
        _progressView.maximumTrackTintColor = [UIColor redColor]; //剩余的颜色
        //[_progressView setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
        //[_progressView setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    }
    return _progressView;
}

- (UIButton *)fullButton {
    if (!_fullButton) {
        _fullButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_fullButton setBackgroundImage:[UIImage imageNamed:@"player_full_btn"] forState:UIControlStateNormal];
        [_fullButton setBackgroundImage:[UIImage imageNamed:@"player_min_btn"] forState:UIControlStateSelected];
        [_fullButton addTarget:self action:@selector(clickFullButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.text = [NSString stringWithCurrentTime:0.f duration:0.f];
    }
    return _timeLabel;
}

#pragma mark - setUI
- (void)setUpUI {
    [self addSubview:self.coverImage];
    [self.coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.coverImage).offset(0);
        make.height.mas_equalTo(@50);
    }];
    
    [self.bottomBar addSubview:self.pauseButton];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.bottomBar);
        make.width.equalTo(self.pauseButton.mas_height);
    }];
    
    [self.bottomBar addSubview:self.fullButton];
    [self.fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomBar);
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.bottomBar);
    }];
    
    [self.bottomBar addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomBar);
        make.right.equalTo(self.fullButton.mas_left).offset(-4);
        make.height.width.equalTo(self.timeLabel);
    }];
    
    [self.bottomBar addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pauseButton.mas_right).offset(4);
        make.centerY.equalTo(self.pauseButton);
        make.right.equalTo(self.timeLabel.mas_left).offset(-4);
        make.height.equalTo(self.progressView);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
