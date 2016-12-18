//
//  HALoginViewController.m
//  HelloAsk
//
//  Created by ZYVincent on 15-9-4.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "HALoginViewController.h"
#import "HARegistViewController.h"

#define mainSize    [UIScreen mainScreen].bounds.size

#define offsetLeftHand      42

#define rectLeftHand        CGRectMake(61*0.6-offsetLeftHand, 66, 40*0.6, 65*0.6)
#define rectLeftHandGone    CGRectMake(mainSize.width / 2 - 70, vLogin.gjcf_top, 40*0.7, 40*0.7)

#define rectRightHand       CGRectMake(imgLogin.frame.size.width / 2 + 53, 66, 40*0.6, 65*0.6)
#define rectRightHandGone   CGRectMake(mainSize.width / 2 + 45, vLogin.gjcf_top, 40*0.7, 40*0.7)

@interface HALoginViewController ()<UITextFieldDelegate>
{
    UITextField* txtUser;
    UITextField* txtPwd;
    
    UIImageView* imgLeftHand;
    UIImageView* imgRightHand;
    
    UIImageView* imgLeftHandGone;
    UIImageView* imgRightHandGone;
    
    JxbLoginShowType showType;
    
    BOOL isMoved;
}
@end

@implementation HALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backView.image = [UIImage imageWithContentsOfFile:GJCFMainBundlePath(@"default.jpg")];
    [self.view addSubview:backView];
    UIImageView *maskView = [[UIImageView alloc]initWithFrame:backView.bounds];
    maskView.backgroundColor = [UIColor colorWithRed:97/255.f green:60/255.f blue:140/255.f alpha:0.6];
    [backView addSubview:maskView];
    
    UIImageView* imgLogin = [[UIImageView alloc] initWithFrame:CGRectMake(mainSize.width / 2 - 211*0.6 / 2, 34, 211*0.6, 109*0.6)];
    imgLogin.image = [UIImage imageNamed:@"owl-login"];
    imgLogin.layer.masksToBounds = YES;
    [self.view addSubview:imgLogin];
    
    imgLeftHand = [[UIImageView alloc] initWithFrame:rectLeftHand];
    imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [imgLogin addSubview:imgLeftHand];
    
    imgRightHand = [[UIImageView alloc] initWithFrame:rectRightHand];
    imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [imgLogin addSubview:imgRightHand];
    
    UIView* vLogin = [[UIView alloc] initWithFrame:CGRectMake(20, imgLogin.gjcf_bottom-5, mainSize.width - 40, 110)];
    vLogin.layer.borderWidth = 0.5;
    vLogin.layer.borderColor = [[GJGCCommonFontColorStyle mainThemeColor] CGColor];
    vLogin.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vLogin];
    
    imgLeftHandGone = [[UIImageView alloc] initWithFrame:rectLeftHandGone];
    imgLeftHandGone.image = [UIImage imageNamed:@"icon_hand"];
    imgLeftHandGone.gjcf_centerY = vLogin.gjcf_top;
    [self.view addSubview:imgLeftHandGone];
    
    imgRightHandGone = [[UIImageView alloc] initWithFrame:rectRightHandGone];
    imgRightHandGone.image = [UIImage imageNamed:@"icon_hand"];
    imgRightHandGone.gjcf_centerY = vLogin.gjcf_top;
    [self.view addSubview:imgRightHandGone];
    
    txtUser = [[UITextField alloc] initWithFrame:CGRectMake(15, 15, vLogin.frame.size.width - 30, 36)];
    txtUser.delegate = self;
    txtUser.layer.cornerRadius = 5;
    txtUser.layer.borderColor = [[GJGCCommonFontColorStyle mainThemeColor] CGColor];
    txtUser.layer.borderWidth = 0.5;
    txtUser.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    txtUser.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [txtUser.leftView addSubview:imgUser];
    [vLogin addSubview:txtUser];
    
    txtPwd = [[UITextField alloc] initWithFrame:CGRectMake(15, 61, vLogin.frame.size.width - 30, 36)];
    txtPwd.delegate = self;
    txtPwd.layer.cornerRadius = 5;
    txtPwd.layer.borderColor = [[GJGCCommonFontColorStyle mainThemeColor] CGColor];
    txtPwd.layer.borderWidth = 0.5;
    txtPwd.secureTextEntry = YES;
    txtPwd.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    txtPwd.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 22, 22)];
    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
    [txtPwd.leftView addSubview:imgPwd];
    [vLogin addSubview:txtPwd];
    
    CGFloat buttonMargin = (imgLogin.gjcf_width -  (2*2/7*GJCFSystemScreenWidth))/3;
    
    UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registButton.gjcf_width = GJCFSystemScreenWidth * 2/7;
    registButton.gjcf_height = registButton.gjcf_width * 2/7 +3;
    [registButton setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], registButton.gjcf_size) forState:UIControlStateNormal];
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registButton.layer.cornerRadius = 4.f;
    registButton.layer.masksToBounds = YES;
    [registButton setTitle:@"注     册" forState:UIControlStateNormal];
    registButton.gjcf_top = vLogin.gjcf_bottom + 20.f;
    registButton.gjcf_left = vLogin.gjcf_left + buttonMargin - 6;
    [registButton addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registButton];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.gjcf_width = GJCFSystemScreenWidth * 2/7;
    loginButton.gjcf_height = loginButton.gjcf_width * 2/7 +3;
    [loginButton setBackgroundImage:GJCFQuickImageByColorWithSize([GJGCCommonFontColorStyle mainThemeColor], loginButton.gjcf_size) forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 4.f;
    loginButton.layer.masksToBounds = YES;
    [loginButton setTitle:@"登     录" forState:UIControlStateNormal];
    loginButton.gjcf_top = vLogin.gjcf_bottom + 20.f;
    loginButton.gjcf_left = registButton.gjcf_right + buttonMargin;
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    if ([[ZYUserCenter shareCenter] isLogin]) {
        
        txtUser.text = [[ZYUserCenter shareCenter] currentLoginUser].mobile;
        txtPwd.text = [[ZYUserCenter shareCenter] getLastUserPassword];
        
        [self.statusHUD showWithStatusText:@"自动登录..."];
        [[ZYUserCenter shareCenter] LoginUserWithMobile:txtUser.text withPassword:txtPwd.text withSuccess:^(NSString *message) {
            
            [self.statusHUD dismiss];
            
        } withFaild:^(NSError *error) {
            
            [self.statusHUD dismiss];
            
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (GJCFSystemiPhone4) {
        [self.navigationController.navigationBar setHidden:YES];
    }else{
        [self setStrNavTitle:@"王者荣耀－约战"];
    }
}

- (void)registAction
{
    [txtPwd resignFirstResponder];
    [txtUser resignFirstResponder];
    
    HARegistViewController *registVC = [[HARegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:txtUser]) {
        if (showType != JxbLoginShowType_PASS)
        {
            showType = JxbLoginShowType_USER;
            return;
        }
        showType = JxbLoginShowType_USER;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - offsetLeftHand, imgLeftHand.frame.origin.y + 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48, imgRightHand.frame.origin.y + 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
            
            
            imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x - 70, imgLeftHandGone.frame.origin.y, 40*0.7, 40*0.7);
            
            imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x + 30, imgRightHandGone.frame.origin.y, 40*0.7, 40*0.7);
            
            
        } completion:^(BOOL b) {
        }];
        
    }
    else if ([textField isEqual:txtPwd]) {
        if (showType == JxbLoginShowType_PASS)
        {
            showType = JxbLoginShowType_PASS;
            return;
        }
        showType = JxbLoginShowType_PASS;
        [UIView animateWithDuration:0.5 animations:^{
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + offsetLeftHand, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
            
            
            imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
            
            imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);
            
        } completion:^(BOOL b) {
        }];
    }
}

- (void)rightNavigationBarItemPressed
{
    HARegistViewController *registVC = [[HARegistViewController alloc]init];
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)loginAction
{
    [txtPwd resignFirstResponder];
    [txtUser resignFirstResponder];
    
    if (GJCFStringIsNull(txtUser.text)) {
        [self showErrorMessage:@"用户名不能为空"];
        return;
    }
    
    if (GJCFStringIsNull(txtPwd.text)) {
        [self showErrorMessage:@"密码不能为空"];
        return;
    }
    
    [self.statusHUD showWithStatusText:@"正在登录..."];
    [[ZYUserCenter shareCenter] LoginUserWithMobile:txtUser.text withPassword:txtPwd.text withSuccess:^(NSString *message) {
        
        [self.statusHUD dismiss];
        
    } withFaild:^(NSError *error) {
        
        [self.statusHUD dismiss];

    }];
}

@end
