//
//  ZKPictureTableViewCell.h
//  NNews
//
//  Created by Tom on 2017/11/8.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKTTPicture.h"

@protocol ZKPictureTableViewCellDelegate;

@interface ZKPictureTableViewCell : UITableViewCell
@property (nonatomic, strong) ZKTTPicture * pictureModel;
@property (nonatomic,   weak) id <ZKPictureTableViewCellDelegate> delegate;
@end

@protocol ZKPictureTableViewCellDelegate <NSObject>
@optional
- (void)didClickBigPicture:(ZKTTPicture *)pictureModel;

@end
