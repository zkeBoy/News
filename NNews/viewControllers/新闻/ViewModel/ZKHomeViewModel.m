//
//  ZKHomeViewModel.m
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKHomeViewModel.h"

@implementation ZKHomeViewModel

- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
    }
    return _listArray;
}

- (NSInteger)rowNum {
    return self.listArray.count;
}

- (ZKHomeModel *)modelWithIndexPath:(NSIndexPath *)indexPath{
    return self.listArray[indexPath.row];
}

- (NSInteger)cellTypeWithIndexPath:(NSIndexPath *)indexPath{
    ZKHomeModel * model = [self modelWithIndexPath:indexPath];
    if (model.hasHead && model.photosetID) {
        return cellTypeImgCell;
    }else if (model.hasHead){
        return cellTypeTexCell;
    }else if (model.imgType){
        return cellTypeBigImgC;
    }else if (model.imgextra){
        return cellTypeImgsCel;
    }else{
        return cellTypeDefault;
    }
}

- (CGFloat)cellheightWithIndexPath:(NSIndexPath *)indexPath{
    cellType type = [self cellTypeWithIndexPath:indexPath];
    if (type==cellTypeTexCell) {
        return 200;
    }else if (type==cellTypeImgsCel) {
        return 120;
    }else if (type==cellTypeBigImgC) {
        return 180;
    }else if (type==cellTypeDefault) {
        return 80;
    }else if (type==cellTypeImgCell) {
        return 80;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cellType type = [self cellTypeWithIndexPath:indexPath];
    ZKHomeModel * model = [self modelWithIndexPath:indexPath];
    if (type==cellTypeDefault) {
        ZKHomeDefaultCell * defaultCell = [tableView dequeueReusableCellWithIdentifier:CellDefaultIdentifider forIndexPath:indexPath];
        defaultCell.model = model;
        return defaultCell;
    }else if (type==cellTypeImgCell) {
        ZKHomeDefaultCell * defaultCell = [tableView dequeueReusableCellWithIdentifier:CellDefaultIdentifider forIndexPath:indexPath];
        defaultCell.model = model;
        return defaultCell;
    }else if (type==cellTypeTexCell) {
        ZKHomeTextCell * textCell = [tableView dequeueReusableCellWithIdentifier:CellTextIdentifider forIndexPath:indexPath];
        textCell.model = model;
        return textCell;
    }else if (type==cellTypeImgsCel) {
        ZKHomeImgsCell * imgsCell = [tableView dequeueReusableCellWithIdentifier:CellImagesIdentifider forIndexPath:indexPath];
        imgsCell.model = model;
        return imgsCell;
    }else if (type==cellTypeBigImgC) {
        ZKHomeBigImgCell * bigImgCell = [tableView dequeueReusableCellWithIdentifier:CellBigImageIdentifider forIndexPath:indexPath];
        bigImgCell.model = model;
        return bigImgCell;
    }
    return nil;
}

- (void)getDataWithCompleteHandler:(completionHandler)completionHandler{
    [ZKHomeNetWork requestWithType:listTypeTec lastTime:nil page:self.page completionHandler:^(id obj, NSError *error) {
        if (!error) {
            if (self.page==0) {
                [self.listArray removeAllObjects];
            }
            [self.listArray addObjectsFromArray:[ZKHomeModel mj_objectArrayWithKeyValuesArray:obj[@"T1348647853363"]]];
        }
        completionHandler (error);
    }];
}

- (void)refreshDataWithCompleteHandler:(completionHandler)completionHandler{
    self.page = 0;
    [self getDataWithCompleteHandler:completionHandler];
}

- (void)getMoreDataWithCompleteHandler:(completionHandler)completionHandler{
    self.page += 20;
    [self getDataWithCompleteHandler:completionHandler];
}

@end
