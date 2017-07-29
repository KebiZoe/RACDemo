//
//  LoginViewModel.m
//  RACDemo
//
//  Created by zoekebi_Mac on 2017/7/23.
//  Copyright © 2017年 zoekebi_Mac. All rights reserved.
//

#import "LoginViewModel.h"

@implementation Account

@end

@implementation LoginViewModel
- (Account *)account{
    if (_account == nil) {
        _account = [[Account alloc] init];
    }
    return _account;
}

- (instancetype)init{
    if (self = [super init]) {
        [self initialBind];
    }
    return self;
}
- (void)initialBind{
    _enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self.account, name),RACObserve(self.account, pwd)] reduce:^id _Nullable(NSString *account,NSString *password){
        NSLog(@"%@--%@",account,password);
        return @(account.length>0&&password.length>6);
    }];
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"点击了登入 %@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"登入请求data"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [[_loginCommand.executing skip:1]subscribeNext:^(NSNumber * _Nullable x) {
        if ([x isEqualToNumber:@(YES)]) {
            NSLog(@"登入中...");
        }else{
            NSLog(@"登入成功");
        }
    }];
}
@end
