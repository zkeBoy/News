//
//  ZKFunsTableViewCell.h
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTTVideo.h"

@protocol ZKFunsTableViewCellDelegate <NSObject>

@optional
- (void)clickVideoPlay:(NSIndexPath *)indexPath;

@end

@interface ZKFunsTableViewCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath                    * indexPath;
@property (nonatomic,   weak) id <ZKFunsTableViewCellDelegate> delegate;
@property (nonatomic, strong) ZKTTVideo                      * videoModel;
@property (nonatomic, assign) CGRect                           videnPlayFrame;
@property (nonatomic, strong) UIButton                       * shareButton;
@end
