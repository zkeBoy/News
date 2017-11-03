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
    [self addGestureRecognizer:tap];
}

- (void)setBottomBarHidden:(BOOL)hidden{
    self.bottomBar.hidden = !self.bottomBar.hidden;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self addPlayLayer];
        [self startloadAnimation]; //开始loadView Animation
        [self addTapGestureRecognizer];
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
    self.bottomBar.hidden = YES;
}

- (void)fireTimer{
    if (!self.playTimer) {
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(updateVideoPlaySpeed) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
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
        [self.delegate videoPlayFinish];
        [self finishPlay];
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
            [self fireTimer]; //开启视频进度计时器
        }
    }
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
        _playButton.backgroundColor = [UIColor clearColor];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"paly_play_btn"] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"paly_pause_btn"] forState:UIControlStateSelected];
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
        [_progressView addTarget:self action:@selector(exchangePlaySpeed:) forControlEvents:UIControlEventValueChanged];
        [_progressView setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
        _progressView.minimumTrackTintColor = [UIColor whiteColor]; //走过的颜色
        _progressView.maximumTrackTintColor = [UIColor redColor]; //剩余的颜色
        //[_progressView setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
        //[_progressView setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
        /*
        _progressView.minimumTrackTintColor = [UIColor redColor]; //走过的颜色
        _progressView.maximumTrackTintColor = [UIColor yellowColor]; //剩余的颜色
        _progressView.thumbTintColor = [UIColor purpleColor]; //圆形颜色
         */
    }
    return _progressView;
}

- (UIButton *)fullButton {
    if (!_fullButton) {
        _fullButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _fullButton.backgroundColor = [UIColor redColor];
        //[_fullButton setBackgroundImage:[UIImage imageNamed:@"paly_full_btn"] forState:UIControlStateNormal];
        //[_fullButton setBackgroundImage:[UIImage imageNamed:@"paly_min_btn"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(clickFullBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
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

    [self.bottomBar addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomBar);
        make.left.equalTo(self.progressView.mas_right).offset(4);
        make.right.equalTo(self.fullButton.mas_left).offset(-4);
        make.height.equalTo(self.timeLabel);
    }];
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

//播放进度改变,快进 快退
- (void)exchangePlaySpeed:(UISlider *)slider{
    
}

- (void)finishPlay{
    [self invalidateTimer];
    [self resumePlayer];
}

- (void)resumePlayer{
    if (self.videoPlayer&&self.videoPlayerLayer) {
        [self.videoPlayer removeObserver:self forKeyPath:videoPlayerStatus]; //移除KVO
        [self.videoPlayerLayer removeFromSuperlayer];
        [self.videoPlayer replaceCurrentItemWithPlayerItem:nil];
        self.videoPlayer = nil;
    }
}

#pragma mark - Out Action
- (void)resumeVideoPlayWhenScroll{
    [self finishPlay];
    [self removeFromSuperview];
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"ZKVideoPlayView dealloc !!!");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
