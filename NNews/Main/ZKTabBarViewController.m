//
//  ZKTabBarViewController.m
//  NNews
//
//  Created by Tom on 2017/10/31.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKTabBarViewController.h"

@interface ZKTabBarViewController()<UITabBarControllerDelegate>
@property (nonatomic, strong) NSArray * viewControllerNames;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * selectImages;
@property (nonatomic, strong) NSArray * normalImages;
@end

@implementation ZKTabBarViewController

- (void)initArrays{
    self.viewControllerNames = @[@"ZKNewsViewController",
                                 @"ZKPictureViewController",
                                 @"ZKFunsViewController",
                                 @"ZKWeatherViewController",
                                 @"ZKPersonViewController"];
    self.titles = @[@"新闻",@"趣图",@"趣事",@"天气",@"个人"];
    self.selectImages = @[@"tabbar_news_select",@"tabbar_picture_select",@"tabbar_video_select",@"",@""];
    self.normalImages = @[@"tabbar_news",@"tabbar_picture",@"tabbar_video",@"",@""];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self initArrays];
    [self setTabBarItemVC];
}

- (void)setTabBarItemVC{
    NSMutableArray * viewControllers = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    for (NSInteger index=0; index<self.viewControllerNames.count; index++) {
        NSString * nibName = self.viewControllerNames[index];
        NSString * title = self.titles[index];
        UIImage * image = [[UIImage imageNamed:self.normalImages[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectImage = [[UIImage imageNamed:self.selectImages[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ZKNavigationController * nav = [self instanceRootViewControllerWithName:nibName andTabBarNormalImage:image selectImage:selectImage title:title];
        [viewControllers addObject:nav];
    }
    self.viewControllers = viewControllers;
}

- (ZKNavigationController *)instanceRootViewControllerWithName:(NSString *)nibName andTabBarNormalImage:(UIImage *)normal selectImage:(UIImage *)select title:(NSString *)title{
    UIViewController * vc = (UIViewController *)[[NSClassFromString(nibName) alloc] init];
    ZKNavigationController * nav = [[ZKNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = normal;
    nav.tabBarItem.selectedImage = select;
    NSDictionary * normalDic = @{NSForegroundColorAttributeName:[UIColor grayColor]};
    NSDictionary * selectDic = @{NSForegroundColorAttributeName:[UIColor redColor]};
    [nav.tabBarItem setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:selectDic forState:UIControlStateSelected];
    return nav;
}

#pragma mark -
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (viewController == [tabBarController.viewControllers objectAtIndex:self.viewControllers.count-2]) {
        UIViewController * viewController = [[NSClassFromString(@"ZKWeatherViewController") alloc] init];
        [self presentViewController:viewController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

@end
