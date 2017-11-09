//
//  ZKWebViewController.m
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKWebViewController.h"
#import <WebKit/WebKit.h>

@interface ZKWebViewController ()<WKNavigationDelegate>
@property (nonatomic, copy) NSString * linkString;
@property (nonatomic, strong) WKWebView * webView;
@end

@implementation ZKWebViewController

- (instancetype)initWithLinkURL:(NSString *)link{
    self = [super init];
    if (self) {
        self.linkString = link;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ZKHelperView showWaitingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self startloadHtml];
}

- (void)setUI{
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)startloadHtml{
    NSURL *url = [NSURL URLWithString:self.linkString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate
#pragma mark
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self stoploadHtml];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [self stoploadHtml];
}

- (void)stoploadHtml{
    [self.webView.scrollView.mj_header endRefreshing];
    [ZKHelperView hiddenWaitingView];
}


#pragma mark -
#pragma mark lazy init
- (WKWebView *)webView {
    if (!_webView) {
        __weak typeof(self)weakSelf = self;
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc] init];
        configuration.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        configuration.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf startloadHtml];
        }];
        [_webView.scrollView.mj_header beginRefreshing];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)dealloc {
    if (self.webView) {
        self.webView.navigationDelegate = nil;
        [self.webView removeFromSuperview];
        self.webView = nil;
    }
    NSLog(@"ZKWebViewController dealloc !!!!!!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
