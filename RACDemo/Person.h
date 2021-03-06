//
//  Person.h
//  RACDemo
//
//  Created by zoekebi_Mac on 2017/7/18.
//  Copyright © 2017年 zoekebi_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic, copy) NSString *name;

@property(nonatomic, assign) NSUInteger age;

@property(nonatomic, copy) NSString *sex;

+ (instancetype)personWithDict:(NSDictionary *)dict;

@end
