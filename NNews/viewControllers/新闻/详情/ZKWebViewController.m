//
//  ZKWebViewController.m
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKWebViewController.h"
#import "ZKNewsDetailModel.h"
@interface ZKWebViewController ()
@property (nonatomic, strong) UIWebView         * webView;
@property (nonatomic, strong) ZKNewsDetailModel * detailModel;
@end

@implementation ZKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self requestWebData];
}

- (void)setUI {
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.frame = self.view.bounds;
    [self.view addSubview:_webView];
}

- (void)requestWebData {
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.model.docid];
    [ZKBaseNetWork GET:url para:nil progress:nil completionHandler:^(id obj, NSError *error) {
        self.detailModel = [ZKNewsDetailModel mj_objectWithKeyValues:obj[self.model.docid]];
        [self showInWebView];
    }];
}

- (void)showInWebView{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"Detail.css" withExtension:nil]];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendString:[self appendBody]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (NSString *)appendBody {
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.detailModel.ptime];
    if (self.detailModel.body != nil) {
        [body appendString:self.detailModel.body];
    }
    // 遍历img 添加Image
    for (NSDictionary * dic in self.detailModel.img) {
        ZKImageDetailModel * detailImgModel = [ZKImageDetailModel mj_objectWithKeyValues:dic];
        NSMutableString *imgHtml = [NSMutableString string];
        
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        
        // 数组存放被切割的像素
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > maxWidth) {
            height = maxWidth / width * height;
            width = maxWidth;
        }
        
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,detailImgModel.src];
        // 结束标记
        [imgHtml appendString:@"</div>"];
        // 替换标记
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
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
