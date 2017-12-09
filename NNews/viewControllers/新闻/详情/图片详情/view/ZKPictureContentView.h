//
//  ZKPictureContentView.h
//  ZKSport
//
//  Created by Tom on 2017/11/23.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKPictureModel.h"
@protocol ZKPictureContentViewDelegate;

@interface ZKPictureContentView : UIView
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSArray      * imglinks;
@property (nonatomic,   weak) id <ZKPictureContentViewDelegate> delegate;
@end


@protocol ZKPictureContentViewDelegate <NSObject>

@optional
- (void)contentDidSelectItemAtIndex:(NSInteger)index;

@end
