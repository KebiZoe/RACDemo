//
//  ViewController2.m
//  RACDemo
//
//  Created by zoekebi_Mac on 2017/7/18.
//  Copyright © 2017年 zoekebi_Mac. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"第二个控制器消失了");
        [self.delegateSignal sendNext:@"第二个控制器发送过来的数据"];
    }];
}
- (void)dealloc
{
    NSLog(@"控制器被销毁了");
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

