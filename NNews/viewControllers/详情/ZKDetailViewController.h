//
//  ZKDetailViewController.h
//  NNews
//
//  Created by Tom on 2017/11/4.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKDetailHeaderView.h"
#import "ZKTTVideoComment.h"
@interface ZKDetailViewController : UIViewController
@property (nonatomic, assign) detailType    type;
@property (nonatomic, strong) ZKTTVideo   * videoModel;
@property (nonatomic, strong) ZKTTPicture * pictureModel;
@end
