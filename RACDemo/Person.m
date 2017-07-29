//
//  Person.m
//  RACDemo
//
//  Created by zoekebi_Mac on 2017/7/18.
//  Copyright © 2017年 zoekebi_Mac. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (instancetype)personWithDict:(NSDictionary *)dict{
    Person *person = [[Person alloc] init];
    person.name = dict[@"name"];
    if (dict[@"age"]) {
        person.age = [dict[@"age"] unsignedIntegerValue];
    }else{
        person.age = 0;
    }
    person.sex = dict[@"sex"];
    return person;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"class:%@+%p,name:%@,age:%ld,sex:%@",[self class],&self,self.name,self.age,self.sex];
}

@end
