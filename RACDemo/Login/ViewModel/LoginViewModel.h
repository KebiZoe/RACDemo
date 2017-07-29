//
//  LoginViewModel.h
//  RACDemo
//
//  Created by zoekebi_Mac on 2017/7/23.
//  Copyright © 2017年 zoekebi_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account :NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *pwd;
@end

@interface LoginViewModel : NSObject

@property(nonatomic, strong) Account *account;
@property(nonatomic, strong, readonly) RACSignal *enableLoginSignal;
@property(nonatomic, strong, readonly) RACCommand *loginCommand;

@end
