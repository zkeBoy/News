//
//  ZKVideoPlayView.h
//  NNews
//
//  Created by Tom on 2017/11/2.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol ZKVideoPlayViewDelegate <NSObject>
@optional
- (void)openFullPlayWindow:(BOOL)full;

- (void)videoPlayFinish; //播放结束
@end

@interface ZKVideoPlayView : UIView
@property (nonatomic, strong) id <ZKVideoPlayViewDelegate> delegate;
@property (nonatomic, strong) AVPlayerItem * playerItem;


- (void)resetVideoPlay;

@end
