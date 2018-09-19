//
//  SuggestionViewController.m
//  MoblieCQUPT_iOS
//
//  Created by user on 15/9/3.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "SuggestionViewController.h"
#import "ORWInputTextView.h"

@interface SuggestionViewController ()<UITextViewDelegate>
@property (strong, nonatomic) ORWInputTextView *suggestTextView;
@property (strong, nonatomic) UIBarButtonItem *send;

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGBColor(243, 244, 245, 1);
    
    _suggestTextView = [[ORWInputTextView alloc] initWithFrame:CGRectMake(0, HEADERHEIGHT+10, MAIN_SCREEN_W, 250)];
    _suggestTextView.contentSize = CGSizeMake(0, _suggestTextView.contentSize.height);
    [_suggestTextView setPlaceHolder:@"请描述一下您所遇到的程序错误,非常感谢您对掌上重邮成长的帮助。您还可以加入掌上重邮反馈群: 570919844进行反馈哦~"];
    _suggestTextView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_suggestTextView];
    self.navigationItem.rightBarButtonItem = self.send;
    self.navigationItem.title = @"意见反馈";
    self.send.enabled = NO;

}


- (UIBarButtonItem *)send{
    if (!_send) {
        _send = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sendSuggest)];
        _send.tintColor = [UIColor whiteColor];
    }
    return _send;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_suggestTextView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (_suggestTextView.text.length <= 0) {
        [_suggestTextView setPlaceHolder:@"请描述一下您所遇到的程序错误,非常感谢您对掌上重邮成长的帮助。您还可以加入掌上重邮反馈群: 570919844进行反馈哦~"];
        self.send.enabled   = NO;
    }else{
        self.send.enabled   = YES;
        [_suggestTextView setPlaceHolder:@""];
    }
}

- (BOOL)textView:(UITextView *)textView didChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_suggestTextView.text.length <= 0) {
        [_suggestTextView setPlaceHolder:@"请描述一下您所遇到的程序错误,非常感谢您对掌上重邮成长的帮助。您还可以加入掌上重邮反馈群: 570919844进行反馈哦~"];
        self.send.enabled   = NO;
    }
    else{
        self.send.enabled   = YES;
        [_suggestTextView setPlaceHolder:@""];
    }
    return YES;
}

-(void)sendSuggest{
    NSString *deviceInfo = [NSString stringWithFormat:@"iOS:%@+H:%f+W:%f",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],MAIN_SCREEN_H,MAIN_SCREEN_W];
    NSDictionary *dic = @{
                        @"paw":@"cyxbs_suggestion",
                        @"deviceInfo":deviceInfo,
                        @"content":_suggestTextView.text,
                        };
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"反馈中";
    [HttpClient requestWithPath:SUGGESTION_API method:HttpRequestPost parameters:dic prepareExecute:^{
        
    } progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"反馈成功";
        [hud hide:YES afterDelay:1];
        _suggestTextView.text = @"";
        [_suggestTextView setPlaceHolder:@"请描述一下您所遇到的程序错误,非常感谢您对掌上重邮成长的帮助。您还可以加入掌上重邮反馈群: 570919844进行反馈哦~"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"网络故障";
        [hud hide:YES afterDelay:1];
    }];
}

@end
