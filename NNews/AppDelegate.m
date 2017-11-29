//
//  AppDelegate.m
//  NNews
//
//  Created by Tom on 2017/10/31.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "AppDelegate.h"
#import "ZKTabBarViewController.h"
#import "ZKLoginViewController.h"

#define BmobAppID @"766ea543d530b58937454ac7d9f49ea1"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[ZKNetWorkManager shareManager] startMonitoring]; //开启网络监听
    [Bmob registerWithAppKey:BmobAppID];
    [self compareLogin];
    return YES;
}

- (void)compareLogin{
    ZKTabBarViewController * rootVC = [[ZKTabBarViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if (!userInfo){
        ZKLoginViewController *login = [[ZKLoginViewController alloc] init];
        ZKNavigationController *loginNav = [[ZKNavigationController alloc] initWithRootViewController:login];
        loginNav.navigationBar.hidden = YES;
        [self.window.rootViewController presentViewController:loginNav animated:YES completion:NULL];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
