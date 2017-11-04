//
//  ZKDetailHeaderView.h
//  NNews
//
//  Created by Tom on 2017/11/4.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTTVideo.h"
@protocol ZKDetailHeaderViewDelegate;

typedef NS_ENUM(NSInteger, detailType) {
    typeVideo   = 1,   //视频
    typePicture = 2    //图片
};


@interface ZKDetailHeaderView : UIView
@property (nonatomic, assign) detailType   type;
@property (nonatomic, strong) ZKTTVideo  * videoModel;
@property (nonatomic, weak)   id <ZKDetailHeaderViewDelegate> delegate;
@property (nonatomic, assign) CGRect       coverFrame;
@end

@protocol ZKDetailHeaderViewDelegate <NSObject>
@optional
- (void)startPlayVideo:(NSString *)videoLink;

- (void)watchPicture:(id)date;
@end
