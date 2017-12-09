//
//  ZKPictureDetailViewController.m
//  ZKSport
//
//  Created by Tom on 2017/11/23.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKPictureDetailViewController.h"
#import "ZKPictureContentView.h"
#import "ZKPictureBottomView.h"

@interface ZKPictureDetailViewController ()<ZKPictureContentViewDelegate>
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) ZKPictureContentView   * contentView;
@property (nonatomic, strong) ZKPictureBottomView * bottomView;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) ZKPictureModel * model;
@property (nonatomic, assign) BOOL islock;
@end

@implementation ZKPictureDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)addTap{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBottomView)];
    [self.view addGestureRecognizer:tap];
}

- (void)hiddenBottomView {
    NSTimeInterval duration = 0.5;
    if (!self.islock) {
        CGFloat h = CGRectGetHeight(self.bottomView.frame);
        [UIView animateWithDuration:duration animations:^{
            self.bottomView.transform = CGAffineTransformMakeTranslation(0, h+StatusH);
            self.backBtn.transform = CGAffineTransformMakeTranslation(0, -60);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:duration animations:^{
            self.bottomView.transform = CGAffineTransformIdentity;
            self.backBtn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }
    self.islock = !self.islock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self addTap];
    [self setUI];
    [self loadlistData];
}

- (void)loadlistData {
    NSString * urlString = [self.jsonString mutableCopy];
    [ZKBaseNetWork GET:urlString para:nil progress:nil completionHandler:^(NSDictionary * responsderObj, NSError *error) {
        if (responsderObj) {
            ZKPictureModel * model = [ZKPictureModel mj_objectWithKeyValues:responsderObj];
            [self updateModel:model];
        }
    }];
}

- (void)updateModel:(ZKPictureModel *)model{
    self.model = model;
    NSMutableArray * linkArray = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    for (NSDictionary * dic in model.photos) {
        NSString * link = dic[@"squareimgurl"];
        NSString * title = dic[@"note"];
        NSString * gif = dic[@"imgurl"];
        NSArray * sp = [gif componentsSeparatedByString:@"."];
        NSString * last = sp.lastObject;
        if ([last isEqualToString:@"gif"]) {
            [linkArray addObject:gif];
        }else{
            [linkArray addObject:link];
        }
        [self.titleArray addObject:title];
    }
    
    self.contentView.imglinks = linkArray;
    
    NSString * title = self.titleArray[0];
    title = [NSString stringWithFormat:@"1/%ld %@",(long)model.photos.count,title];
    CGSize size = CGSizeMake(D_WIDTH-Margin*2, MAXFLOAT);
    CGRect rect = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat h = CGRectGetHeight(rect)+44;
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
        make.left.bottom.right.equalTo(self.view);
    }];
    self.bottomView.pageLabel.text = title;
}

- (void)setUI {
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(StatusH);
        make.left.equalTo(self.view).offset(StatusH);
        make.width.height.mas_equalTo(35);
    }];
}

#pragma mark - ZKPictureContentViewDelegate
- (void)contentDidSelectItemAtIndex:(NSInteger)index {
    NSString * title = self.titleArray[index];
    title = [NSString stringWithFormat:@"%ld/%ld %@",(long)index+1,(long)self.model.photos.count,title];
    CGSize size = CGSizeMake(D_WIDTH-Margin*2, MAXFLOAT);
    CGRect rect = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat h = CGRectGetHeight(rect)+44;
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(h);
        make.left.bottom.right.equalTo(self.view);
    }];
    self.bottomView.pageLabel.text = title;
}

#pragma mark - lazy init
- (ZKPictureContentView *)contentView {
    if (!_contentView) {
        _contentView = [[ZKPictureContentView alloc] init];
        _contentView.delegate = self;
    }
    return _contentView;
}

- (ZKPictureBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ZKPictureBottomView alloc] init];
    }
    return _bottomView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImage:[UIImage imageNamed:@"show_image_back_icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark - Private Method
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"ZKPictureDetailViewController dealloc !!!!!!");
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
