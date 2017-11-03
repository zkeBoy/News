//
//  ZKNetWorkManager.h
//  NNews
//
//  Created by Tom on 2017/10/31.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <RealReachability.h>

typedef void(^successBlock)(id);          //请求成功的回调
typedef void(^failureBlock)(NSError *);   //请求失败的回调
typedef void(^uploadBlock)(double); //上传的进度

typedef NS_ENUM(NSInteger, requestType) {
    requestTypeGet  = 1,
    requestTypePost = 2,
};

@interface ZKNetWorkManager : NSObject

+ (ZKNetWorkManager *)shareManager;

/*开启网络监听*/
- (void)startMonitoring;

/*判断是否有网络*/
- (BOOL)canLinkInternetConnection;

/**
 请求网络接口

 @param type GET or Post
 @param urlString 请求的链接
 @param para 需要上传的参数
 @param sblock 成功的回调
 @param fblock 失败的回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)requestWithType:(requestType)type
                                urlString:(NSString *)urlString
                            andParameters:(NSDictionary *)para
                                  success:(successBlock)sblock
                                  failure:(failureBlock)fblock;


/**
 上传图片

 @param urlString 上传的链接
 @param image 上传的图片
 @param para 上传的参数
 @param uploadBlock 上传进度block
 @param sBlock 成功的回调
 @param fBlock 失败的回调
 @return task 任务
 */
- (NSURLSessionDataTask *)uploadWithURLString:(NSString *)urlString
                                       source:(UIImage *)image
                                andParameters:(NSDictionary *)para
                                       upload:(uploadBlock)uploadBlock
                                      success:(successBlock)sBlock
                                      failure:(failureBlock)fBlock;
@end
