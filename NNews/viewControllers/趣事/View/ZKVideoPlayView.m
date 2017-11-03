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
@property (nonatomic, strong) AVPlayer                * videoPlayer;
@property (nonatomic, strong) AVPlayerLayer           * videoPlayerLayer;

@property (nonatomic, strong) NSTimer                 * playTimer; //播放计时器
@end

static NSString * const videoPlayerStatus = @"status";

@implementation ZKVideoPlayView

- (void)addTapGestureRecognizer{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(changeBottomBarHiddenStatus)];
    [self addGestureRecognizer:tap];
}

- (void)changeBottomBarHiddenStatus{
    self.bottomBar.hidden = !self.bottomBar.hidden;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self addPlayLayer];
        [self startloadAnimation];      //开始loadView Animation
        [self addTapGestureRecognizer];
        self.bottomBar.hidden = YES;
        self.playButton.selected = YES;
        self.fullButton.selected = YES;
    }
    return self;
}

- (void)addPlayLayer{
    self.videoPlayer = [[AVPlayer alloc] init];
    self.videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    [self.backgroundView.layer addSublayer:self.videoPlayerLayer];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.videoPlayerLayer.frame = self.bounds;
}

- (void)fireTimer{
    if (!self.playTimer) {
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateVideoPlaySpeed) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
    }else{//继续
        [self.playTimer setFireDate:[NSDate date]];
    }
}

- (void)stopTimer{//暂停
    if (self.playTimer) {
        [self.playTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)invalidateTimer{
    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

- (void)updateVideoPlaySpeed{ //更新播放进度
    NSTimeInterval currentTime = CMTimeGetSeconds(self.videoPlayer.currentTime);
    NSTimeInterval duration = CMTimeGetSeconds(self.videoPlayer.currentItem.duration);
    if (currentTime>=duration) {//播放结束
        [self finishPlay];
        [self.delegate videoPlayFinish];
    }else{ //更新进度
        NSString * text = [NSString stringWithCurrentTime:currentTime duration:duration];
        self.timeLabel.text = text;
        
        //更新进度条
        self.progressView.value = currentTime/duration;
    }
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    _playerItem = playerItem;
    [self.videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self.videoPlayer addObserver:self forKeyPath:videoPlayerStatus options:NSKeyValueObservingOptionNew context:nil];
    [self.videoPlayer play];
}

//监听播放器的状态变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:videoPlayerStatus]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) { //开始播放
            [self stoploadAnimation]; //隐藏 loadView
            [self fireTimer];         //开启视频进度计时器
        }
    }
}


#pragma mark - Private Method
- (void)startloadAnimation{
    if (!self.loadingView.isAnimating) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView startAnimating];
        });
    }
}

- (void)stoploadAnimation{
    if (self.loadingView.isAnimating) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView stopAnimating];
        });
    }
}

//播放与暂停
- (void)clickPlayBtn:(UIButton *)btn{
    if (btn.selected) {
        NSLog(@"pause");
        [self stopTimer];
        [self.videoPlayer pause];
    }else {
        NSLog(@"play");
        [self fireTimer];
        [self.videoPlayer play];
    }
    self.playButton.selected = !btn.selected;
}

//点击全屏
- (void)clickFullBtn:(UIButton *)btn{
    if (btn.selected) {//max
        [self.delegate openFullPlayWindow:YES];
    }else {//min
        [self.delegate openFullPlayWindow:NO];
    }
    self.fullButton.selected = !btn.selected;
}

#pragma mark - 快进与快退
//开始滑动
- (void)startExchangePlaySpeed:(UISlider *)slider{
    [self invalidateTimer];
    self.playButton.selected = NO;
    [self.videoPlayer pause];
}

//播放进度改变,快进 快退
- (void)exchangePlaySpeed:(UISlider *)slider{
    NSTimeInterval currentTime = CMTimeGetSeconds(self.videoPlayer.currentItem.duration) * self.progressView.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.videoPlayer.currentItem.duration);
    self.timeLabel.text = [NSString stringWithCurrentTime:currentTime duration:duration];
}

//停止滑动
- (void)endExchangePlaySpeed:(UISlider *)slider{
    [self fireTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.videoPlayer.currentItem.duration) * self.progressView.value;
    // 设置当前播放时间
    [self.videoPlayer seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.videoPlayer play];
    self.playButton.selected = YES;
}

#pragma mark - 完成播放
- (void)finishPlay{
    [self invalidateTimer]; //关闭Timer
    [self clearPlayer];     //清理播放器相关的属性与代理
    [self removeFromSuperview];
}

#pragma mark - 清理播放的相关属性
- (void)clearPlayer{
    if (self.videoPlayer&&self.videoPlayerLayer) {
        [self.videoPlayer removeObserver:self forKeyPath:videoPlayerStatus]; //移除KVO
        [self.videoPlayerLayer removeFromSuperlayer];
        [self.videoPlayer replaceCurrentItemWithPlayerItem:nil];
        self.videoPlayer = nil;
    }
}

#pragma mark - Out Action
- (void)resetVideoPlay{ //重置播放器
    [self finishPlay];
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"ZKVideoPlayView dealloc !!!");
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
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
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
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play_play_btn"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play_pause_btn"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
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
        [_fullButton setBackgroundImage:[UIImage imageNamed:@"player_min_btn"] forState:UIControlStateNormal];
        [_fullButton setBackgroundImage:[UIImage imageNamed:@"player_full_btn"] forState:UIControlStateSelected];
        [_fullButton addTarget:self action:@selector(clickFullBtn:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - SETUI
- (void) setUI{
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@22);
    }];
    
    [self addSubview:self.bottomBar];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.backgroundView).offset(0);
        make.height.mas_equalTo(@50);
    }];
    
    [self.bottomBar addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.bottomBar);
        make.width.equalTo(self.playButton.mas_height);
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
        make.left.equalTo(self.playButton.mas_right).offset(4);
        make.centerY.equalTo(self.playButton);
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
