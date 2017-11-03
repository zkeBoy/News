//
//  ZKVideoPlayView.h
//  NNews
//
//  Created by Tom on 2017/11/2.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKVideoPlayViewDelegate <NSObject>
@optional
- (void)openFullPlayWindow:(BOOL)open;

@end

@interface ZKVideoPlayView : UIView
@property (nonatomic, strong) id <ZKVideoPlayViewDelegate> delegate;

@end
