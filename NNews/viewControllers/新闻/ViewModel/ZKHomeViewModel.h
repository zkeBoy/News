//
//  ZKHomeViewModel.h
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKHomeModel.h"
#import "ZKHomeDefaultCell.h"
#import "ZKHomeImgCell.h"
#import "ZKHomeTextCell.h"
#import "ZKHomeImgsCell.h"
#import "ZKHomeBigImgCell.h"

static NSString * const CellDefaultIdentifider  = @"ZKHomeDefaultCell";
static NSString * const CellImageIdentifider    = @"ZKHomeImgCell";
static NSString * const CellTextIdentifider     = @"ZKHomeTextCell";
static NSString * const CellImagesIdentifider   = @"ZKHomeImgsCell";
static NSString * const CellBigImageIdentifider = @"ZKHomeBigImgCell";

typedef NS_ENUM(NSInteger, cellType) {
    cellTypeDefault = 0, //
    cellTypeImgCell = 1,
    cellTypeTexCell = 2,
    cellTypeBigImgC = 3, //Big Image Cell
    cellTypeImgsCel = 4  //Images Cell
};

typedef void(^completionHandler)(NSError * error);

@interface ZKHomeViewModel : NSObject
@property (nonatomic, strong) NSMutableArray <ZKHomeModel *> * listArray;
@property (nonatomic, assign) NSInteger  rowNum;
@property (nonatomic, assign) NSInteger  page;

- (void)refreshDataWithCompleteHandler:(completionHandler)completionHandler;
- (void)getMoreDataWithCompleteHandler:(completionHandler)completionHandler;
- (ZKHomeModel *)modelWithIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)cellTypeWithIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)cellheightWithIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
