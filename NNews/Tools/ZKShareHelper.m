//
//  ZKShareHelper.m
//  NNews
//
//  Created by Tom on 2017/12/14.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKShareHelper.h"

@implementation ZKShareHelper

+ (ZKShareHelper *)shareHelper {
    static ZKShareHelper * helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ZKShareHelper alloc] init];
    });
    return helper;
}

+ (void)shareWithType:(ZKShareHelperShareType)type andPresenController:(UIViewController *)viewController andFilePath:(NSString *)path completionHandler:(shareCompletionHandler)complete{
    [self shareWithType:type andPresenController:viewController andURL:[NSURL URLWithString:path] completionHandler:complete];
}

+ (void)shareWithType:(ZKShareHelperShareType)type andPresenController:(UIViewController *)viewController andURL:(NSURL *)url completionHandler:(shareCompletionHandler)complete{
    [self shareWithType:type andPresenController:viewController andItems:@[url] completionHandler:complete];
}


+ (void)shareWithType:(ZKShareHelperShareType)type andPresenController:(UIViewController *)viewController andItems:(NSArray *)items completionHandler:(shareCompletionHandler)complete{
    if (type==ZKShareHelperShareTypeDefault) {
        NSMutableArray * arr = [NSMutableArray array];
        for (id obj in items) {
            if ([obj isKindOfClass:[NSString class]]) {
                [arr addObject:[NSURL URLWithString:obj]];
            }else {
                [arr addObject:obj];
            }
        }
        UIActivityViewController * shareMoreVC = [[UIActivityViewController alloc] initWithActivityItems:arr applicationActivities:nil];
        //忽略的列表
        //shareMoreVC.excludedActivityTypes = @[];
        [viewController presentViewController:shareMoreVC animated:YES completion:nil];
        [shareMoreVC setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completed&&complete) {
                complete (YES);
            }else if(!completed&&complete){
                complete (NO);
            }
        }];
        return;
    }
    NSString * serviceType = [[ZKShareHelper shareHelper] serviceTypeWithType:type];
    SLComposeViewController * shareVC = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    for (id obj in items) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [shareVC addImage:obj];
        }else if ([obj isKindOfClass:[NSURL class]]){
            [shareVC addURL:obj];
        }
    }
    [shareVC setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (complete) {
            if (result == SLComposeViewControllerResultDone) {
                NSLog(@"点击了发送");
                complete (YES);
            }else if (result == SLComposeViewControllerResultCancelled){
                NSLog(@"点击了取消");
                complete (NO);
            }
        }
    }];
    @try{
        [viewController presentViewController:shareVC animated:YES completion:nil];
    } @catch(NSException *exception) {
        
    } @finally {
        
    }
}

- (BOOL)permissionFaceBook{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController * FaceBook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if (!FaceBook) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL)permissionTwitter{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController * twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if (!twitter) {
            return NO;
        }
        return YES;
    }
    return NO;
}

#pragma mark - Private
- (NSString *)serviceTypeWithType:(ZKShareHelperShareType)type{
    //这个方法不再进行校验,传入就不等于0.这里做一个转换
    NSString * serviceType;
    if ( type!= 0){
        switch (type){
            case ZKShareHelperShareTypeWeChat:
                serviceType = @"com.tencent.xin.sharetimeline";
                break;
            case ZKShareHelperShareTypeQQ:
                serviceType = @"com.tencent.mqq.ShareExtension";
                break;
            case ZKShareHelperShareTypeSina:
                serviceType = @"com.apple.share.SinaWeibo.post";
                break;
            default:
                break;
        }
    }
    return serviceType;
}

/*
  <NSExtension: 0x1741735c0> {id = com.apple.share.Flickr.post}",
 "<NSExtension: 0x174173740> {id = com.taobao.taobao4iphone.ShareExtension}",
 "<NSExtension: 0x174173a40> {id = com.apple.reminders.RemindersEditorExtension}",
 "<NSExtension: 0x174173bc0> {id = com.apple.share.Vimeo.post}",
 "<NSExtension: 0x174173ec0> {id = com.apple.share.Twitter.post}",
 "<NSExtension: 0x174174040> {id = com.apple.mobileslideshow.StreamShareService}",
 "<NSExtension: 0x1741741c0> {id = com.apple.Health.HealthShareExtension}",
 "<NSExtension: 0x1741744c0> {id = com.apple.mobilenotes.SharingExtension}",
 "<NSExtension: 0x174174640> {id = com.alipay.iphoneclient.ExtensionSchemeShare}",
 "<NSExtension: 0x174174880> {id = com.apple.share.Facebook.post}",
 "<NSExtension: 0x174174a00> {id = com.apple.share.TencentWeibo.post}
 */

/*
 "<NSExtension: 0x174174340> {id = com.tencent.xin.sharetimeline}",  //微信
 "<NSExtension: 0x174173d40> {id = com.tencent.mqq.ShareExtension}", //QQ
 "<NSExtension: 0x1741738c0> {id = com.apple.share.SinaWeibo.post}", //微博
 */

@end
