//
//  ZKSettingModel.h
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKSettingModel : NSObject
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) BOOL cleanMemory;
@property (nonatomic, assign) BOOL isHeader;
+ (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title clean:(BOOL)clean header:(BOOL)header;
@end
