//
//  LoginViewController.m
//  RACDemo
//
//  Created by zoekebi_Mac on 2017/7/23.
//  Copyright © 2017年 zoekebi_Mac. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
@interface LoginViewController ()
@property(nonatomic, strong) LoginViewModel *loginViewModel;
@property(nonatomic, weak) UITextField *accountTextfield;
@property(nonatomic, weak) UITextField *passwordTextfield;
@property(nonatomic, weak) UIButton *loginButton;

@end

@implementation LoginViewController
-(LoginViewModel *)loginViewModel{
    if (_loginViewModel == nil) {
        _loginViewModel = [[LoginViewModel alloc] init];
    }
    return _loginViewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initsubViews];
    
    [self bindModel];
}
- (void)initsubViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField1 = [[UITextField alloc] init];
    textField1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField1.layer.borderWidth = 1;
    textField1.placeholder = @"请输入用户名";
    textField1.layer.cornerRadius = 4;
    [self.view addSubview:textField1];
    self.accountTextfield = textField1;
    
    UITextField *textField2 = [[UITextField alloc] init];
    textField2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField2.layer.borderWidth = 1;
    textField2.placeholder = @"请输入密码";
    textField2.layer.cornerRadius = 4;
    [self.view addSubview:textField2];
    self.passwordTextfield = textField2;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"登入" forState:UIControlStateNormal];
    [self.view addSubview:button];
    self.loginButton = button;
    
}
- (void)bindModel{
    RAC(self.loginViewModel.account,name) = self.accountTextfield.rac_textSignal;
    RAC(self.loginViewModel.account,pwd) = self.passwordTextfield.rac_textSignal;
    RAC(self.loginButton,enabled) = self.loginViewModel.enableLoginSignal;
    [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.loginViewModel.loginCommand execute:nil];
    }];
}
- (void)viewDidLayoutSubviews{
    CGFloat wirth = self.view.bounds.size.width;
    self.accountTextfield.frame = CGRectMake(50, 200, wirth-100, 44);
    self.passwordTextfield.frame = CGRectMake(50, 250, wirth-100, 44);
    self.loginButton.frame = CGRectMake(50, 300, wirth-100, 44);
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
