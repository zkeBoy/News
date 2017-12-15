//
//  ZKShareHelper.h
//  NNews
//
//  Created by Tom on 2017/12/14.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>

typedef NS_ENUM(NSInteger, ZKShareHelperShareType) {
    ZKShareHelperShareTypeDefault = 0, //默认系统分享,通过面板分享
    ZKShareHelperShareTypeQQ      = 1, //腾讯QQ
    ZKShareHelperShareTypeWeChat  = 2, //微信
    ZKShareHelperShareTypeSina    = 3  //新浪微博
};


/**
 判断是否确认分享
 @param completion YES:确定分享, NO:取消分享
 */
typedef void(^shareCompletionHandler)(BOOL completion);

typedef void(^permissionBlock)(ZKShareHelperShareType type);

@interface ZKShareHelper : NSObject

+ (void)shareWithType:(ZKShareHelperShareType)type andPresenController:(UIViewController *)viewController andFilePath:(NSString *)path completionHandler:(shareCompletionHandler)complete;

+ (void)shareWithType:(ZKShareHelperShareType)type andPresenController:(UIViewController *)viewController andURL:(NSURL *)url completionHandler:(shareCompletionHandler)complete;

+ (void)shareWithType:(ZKShareHelperShareType)type andPresenController:(UIViewController *)viewController andItems:(NSArray *)items completionHandler:(shareCompletionHandler)complete;

@end
