//
//  LoginViewController.m
//  MobileLogin
//
//  Created by GQuEen on 15/8/13.
//  Copyright (c) 2015年 GegeChen. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginEntry.h"
#import <UMMobClick/MobClick.h>
#import "MyInfoViewController.h"
#import "MyInfoModel.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) MBProgressHUD *loadHud;

typedef NS_ENUM(NSInteger,LZLoginState){
    LZLackPassword,
    LZLackAccount,
    LZAccountOrPasswordWrong,
    LZNetWrong
};
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whiteView.layer.cornerRadius = 3;
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)login:(UIButton *)sender {
    _loadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _loadHud.labelText = @"正在登录";
    if (_passwordField.text.length == 0) {
        [self alertAnimation:LZLackAccount];
    }else if (_accountField.text.length == 0) {
        [self alertAnimation:LZLackPassword];
    }
    else{
        NSDictionary *parameter = @{@"stuNum":_accountField.text,@"idNum":_passwordField.text};
        [NetWork NetRequestPOSTWithRequestURL:Base_Login
                                WithParameter:parameter
                         WithReturnValeuBlock:^(id returnValue){
                             if (![returnValue[@"info"] isEqualToString:@"success"]) {
                                 [self alertAnimation:LZAccountOrPasswordWrong];
                             }else {
                                 [LoginEntry loginWithParamter:returnValue[@"data"]];
                                [self verifyUserInfo];
                                [MobClick profileSignInWithPUID:[UserDefaultTool getStuNum]];
                             }
                         } WithFailureBlock:^{
                             [self alertAnimation:LZNetWrong];
                             NSLog(@"请求失败");
                         }];
    }
}

- (void)verifyUserInfo {
    [NetWork NetRequestPOSTWithRequestURL:SEARCH_API WithParameter:@{@"stuNum":[UserDefaultTool getStuNum],@"idNum":[UserDefaultTool getIdNum]} WithReturnValeuBlock:^(id returnValue) {
        if (![returnValue[@"data"] isKindOfClass:[NSNull class]]) {
            MyInfoModel *model = [[MyInfoModel alloc]initWithDic:returnValue[@"data"]];
            NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *infoFilePath = [path stringByAppendingPathComponent:@"myinfo"];
            [modelData writeToFile:infoFilePath atomically:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            //没有完善信息,跳转到完善个人的界面
            MyInfoViewController *verifyMyInfoVC = [[MyInfoViewController alloc] init];
            [self presentViewController:verifyMyInfoVC animated:YES completion:nil];
        }
        if (self.loginSuccessHandler) {
            self.loginSuccessHandler(YES);
        }
    } WithFailureBlock:^{
        [self alertAnimation:LZNetWrong];
        NSLog(@"请求失败");
    }];
}


- (void)alertAnimation:(LZLoginState)state {
    [_loadHud hide:YES];
    _loadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _loadHud.mode = MBProgressHUDModeText;
    switch (state) {
        case LZAccountOrPasswordWrong:
            _loadHud.labelText = @"请检查账号密码输入是否正确";
            break;
        case LZLackAccount:
            _loadHud.labelText = @"请输入账号";
            break;
        case LZLackPassword:
            _loadHud.labelText = @"请输入密码";
            break;
        case LZNetWrong:
            _loadHud.labelText = @"网络连接失败,请检查网络";
            break;
        default:
            _loadHud.labelText = @"未知情况 请反馈给开发人员";
            break;
    }
    [_loadHud hide:YES afterDelay:1.5];
    if (self.loginSuccessHandler) {
        self.loginSuccessHandler(NO);
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_accountField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

@end
