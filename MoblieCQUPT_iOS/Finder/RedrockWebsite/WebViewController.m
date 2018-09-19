//
//  WebViewController.m
//  MoblieCQUPT_iOS
//
//  Created by 张润峰 on 15/8/24.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于红岩";
    _webView.delegate = self;
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H);
    [_indicatorView setCenter:CGPointMake(MAIN_SCREEN_W/2, MAIN_SCREEN_H/2)];
    [self.view addSubview:_indicatorView];
    [_indicatorView startAnimating];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://wx.idsbllp.cn/aboutus/"]]];
    
    _webView.scalesPageToFit = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_indicatorView stopAnimating];
}

@end
