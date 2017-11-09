//
//  ZKPictureFullController.m
//  NNews
//
//  Created by Tom on 2017/11/9.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKPictureFullController.h"

@interface ZKPictureFullController ()
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIButton     * backBtn;
@property (nonatomic, strong) UIImageView  * pictureView;

@end

@implementation ZKPictureFullController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setPictureModel:(ZKTTPicture *)pictureModel {
    _pictureModel = pictureModel;
    
    NSString * pictureLink = pictureModel.image1;
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:pictureLink] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    
        /*
        CGSize size = CGSizeMake(D_WIDTH, D_HEIGHT);
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        CGFloat w = D_WIDTH;
        CGFloat h = w * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, w, h)];
        self.pictureView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        */
    }];
    
}

#pragma mark - setUI
- (void)setUI {
    CGFloat imageHeight = D_WIDTH * self.pictureModel.height / self.pictureModel.width;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    self.scrollView.contentSize = CGSizeMake(0, imageHeight+24);
    
    [self.scrollView addSubview:self.pictureView];
    self.pictureView.frame = CGRectMake(0, 24, D_WIDTH, imageHeight);
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(20);
        make.width.height.mas_equalTo(35);
    }];
}

#pragma mark - lazy init

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

- (UIImageView *)pictureView {
    if (!_pictureView) {
        _pictureView = [[UIImageView alloc] init];
        _pictureView.backgroundColor = [UIColor clearColor];
        _pictureView.userInteractionEnabled = YES;
    }
    return _pictureView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImage:[UIImage imageNamed:@"show_image_back_icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark - Private Method
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"ZKPictureFullController dealloc !!!!!!");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
