//
//  ZKPlayerView.h
//  NewDemo
//
//  Created by Tom on 2017/12/9.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//设置播放完成的动画类型
typedef enum : NSUInteger {
    AnimationCurveEaseInOut
} playerAnimationType;

@protocol ZKPlayerViewDelegate;
@interface ZKPlayerView : UIView
//判断是否是全屏
@property (nonatomic, assign) BOOL isFull;
//设置代理
@property (nonatomic, weak) id <ZKPlayerViewDelegate> delegate;
//设置动画播放的类型
@property (nonatomic, assign) playerAnimationType animationType;

#pragma mark - Out Method
//初始化方法传入需要播放的地址
- (instancetype)initWithStreamURL:(NSString *)stremaURL;
//重置播放器,移除父视图等操作
- (void)resetPlayer;
@end

//播放的相关代理
@protocol ZKPlayerViewDelegate <NSObject>
@required
- (void)playerDidFinish; //完成播放
@optional
- (void)openFullWindow:(BOOL)open; //是否全屏
@end
