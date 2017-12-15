//
//  ZKFunsTableViewCell.h
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTTVideo.h"

typedef NS_ENUM(NSInteger, shareStationType) {
    shareStationTypeDefault = 0,
    shareStationTypeQQ      = 1,
    shareStationTypeWechat  = 2,
    shareStationTypeSina    = 3
};

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
@property (nonatomic, strong) UIButton                       * shareQQ;
@property (nonatomic, strong) UIButton                       * shareWeChat;
@property (nonatomic, strong) UIButton                       * shareSina;
@end
