//
//  ZKNetWorkManager.m
//  NNews
//
//  Created by Tom on 2017/10/31.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKNetWorkManager.h"

@interface ZKNetWorkManager()
@property (nonatomic, strong) AFHTTPSessionManager         * sessionManager;
@property (nonatomic, strong) AFNetworkReachabilityManager * reachabilityManager;
@end

@implementation ZKNetWorkManager

+ (ZKNetWorkManager *)shareManager {
    static ZKNetWorkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZKNetWorkManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionManager      = [AFHTTPSessionManager manager];
        self.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    }
    return self;
}

- (void)startMonitoring{ //开启网络监听
    [self.reachabilityManager startMonitoring];
    [GLobalRealReachability startNotifier];
}

- (BOOL)canLinkInternetConnection{ //判断是否有网络
    BOOL isLink = NO;
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status != RealStatusNotReachable){
        isLink = YES;
    }
    return isLink;
}

- (NSURLSessionDataTask *)requestWithType:(requestType)type urlString:(NSString *)urlString andParameters:(NSDictionary *)para success:(successBlock)sblock failure:(failureBlock)fblock{
    [[UIApplication sharedApplication] isNetworkActivityIndicatorVisible];
    if (type==requestTypeGet) {
        NSURLSessionDataTask * task = [self getWithUrlString:urlString andParameters:para success:sblock failure:fblock];
        [task resume];
        return task;
    }else{
        NSURLSessionDataTask * task = [self PostWithUrlString:urlString andParameters:para success:sblock failure:fblock];
        [task resume];
        return task;
    }
}

- (NSURLSessionDataTask *)getWithUrlString:(NSString *)urlString andParameters:(NSDictionary *)para success:(successBlock)sblock failure:(failureBlock)fblock{
    NSURLSessionDataTask * task = [self.sessionManager GET:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sblock) {
            sblock (responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fblock) {
            fblock (error);
        }
    }];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)PostWithUrlString:(NSString *)urlString andParameters:(NSDictionary *)para success:(successBlock)sblock failure:(failureBlock)fblock{
    NSURLSessionDataTask * task = [self.sessionManager POST:urlString parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sblock) {
            sblock (responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fblock) {
            fblock (error);
        }
    }];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)uploadWithURLString:(NSString *)urlString source:(UIImage *)image andParameters:(NSDictionary *)para upload:(uploadBlock)uploadBlock success:(successBlock)sBlock failure:(failureBlock)fBlock{
    NSURLSessionDataTask * task = [self.sessionManager POST:urlString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(image);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            double progress = uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            if (uploadBlock) {
                uploadBlock (progress);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sBlock) {
            sBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fBlock) {
            fBlock(error);
        }
    }];
    [task resume];
    return task;
}

@end
