//
//  ZKTabBarViewController.m
//  NNews
//
//  Created by Tom on 2017/10/31.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKTabBarViewController.h"

@interface ZKTabBarViewController()
@property (nonatomic, strong) NSArray * viewControllerNames;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * selectImages;
@property (nonatomic, strong) NSArray * normalImages;
@end

@implementation ZKTabBarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initArrays{
    self.viewControllerNames = @[@"ZKNewsViewController",
                                 @"ZKFunsViewController",
                                 @"ZKStoryViewController",
                                 @"ZKGameViewController",
                                 @"ZKPersonViewController"];
    self.titles = @[@"新闻",@"趣事",@"游戏",@"小说",@"个人"];
    self.selectImages = @[@"",@"",@"",@"",@""];
    self.normalImages = @[@"",@"",@"",@"",@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initArrays];
    [self setTabBarItemVC];
}

- (void)setTabBarItemVC{
    NSMutableArray * viewControllers = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    for (NSInteger index=0; index<self.viewControllerNames.count; index++) {
        NSString * nibName = self.viewControllerNames[index];
        NSString * title = self.titles[index];
        UIImage * image = [UIImage imageNamed:self.normalImages[index]];
        UIImage * selectImage = [UIImage imageNamed:self.selectImages[index]];
        UINavigationController * nav = [self instanceRootViewControllerWithName:nibName andTabBarNormalImage:image selectImage:selectImage title:title];
        [viewControllers addObject:nav];
    }
    self.viewControllers = viewControllers;
}

- (UINavigationController *)instanceRootViewControllerWithName:(NSString *)nibName andTabBarNormalImage:(UIImage *)normal selectImage:(UIImage *)select title:(NSString *)title{
    UIViewController * vc = (UIViewController *)[[NSClassFromString(nibName) alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.selectedImage = select;
    nav.tabBarItem.image = normal;
    nav.title = title;
    NSDictionary * normalDic = @{NSForegroundColorAttributeName:[UIColor orangeColor]};
    [nav.tabBarItem setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    
    NSDictionary * selectDic = @{NSForegroundColorAttributeName:[UIColor purpleColor]};
    [nav.tabBarItem setTitleTextAttributes:selectDic forState:UIControlStateSelected];
    return nav;
}

@end
