//
//  ViewController.m
//  RACDemo
//
//  Created by zoekebi_Mac on 2017/7/17.
//  Copyright © 2017年 zoekebi_Mac. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "LoginViewController.h"
#import <RACReturnSignal.h>
#pragma mark - 模型
#import "Person.h"

@interface ViewController ()

@property(nonatomic, strong) RACSignal *signal;
@property(nonatomic, weak) UIView *testview;
@property(nonatomic, weak) UIButton *button;
@property(nonatomic, weak) UITextField *textField;
@property(nonatomic, copy) NSString *fieldText;
@property(nonatomic, strong) RACSubject *throttlesubject;
@property(nonatomic, strong) NSMutableArray *arrM;
@end

@implementation ViewController{
    RACSubject *_suject;
    int _i;
    NSMutableArray *_arrM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self initSubviews];
    _arrM = [NSMutableArray array];
    
    // 常见的UI用法
    [self setHandleUI];
    // 常用的组合
    [self advancedOperation];
    
    
}

#pragma mark - 初始化子控件
- (void)initSubviews{
    RACSubject *ject = [RACSubject subject];
    RACSignal *replaysubject = [ject replay];
    [ject sendNext:@"先发送数据"];
    [replaysubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    self.testview = view;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitle:@"tap" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapButtonExecuteTask:) forControlEvents:UIControlEventTouchUpInside];
    [self.testview addSubview:button];
    self.button = button;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 1;
    textField.placeholder = @"请输入文字";
    textField.layer.cornerRadius = 4;
    [self.view addSubview:textField];
    self.textField = textField;
}

#pragma mark - 布局子控件
- (void)viewDidLayoutSubviews{
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    self.testview.frame = CGRectMake((width-200)/2, (height-300)/2, 200, 300);
    self.button.frame = CGRectMake(50, 100, 100, 100);
    self.textField.frame = CGRectMake(14, height-44, width-28, 42);
}

#pragma mark - 点击屏幕的时候调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.throttlesubject sendNext:@"throttlesubject"];
}

#pragma mark - 点击按钮的时候执行的方法
- (void)tapButtonExecuteTask:(id)sender{
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:nil];
}

#pragma mark - 处理UI事件
- (void)setHandleUI{
    /**
     监听对象的方法是否调用
     可以用来代替代理
     */
    [[self rac_signalForSelector:@selector(tapButtonExecuteTask:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"点击了testView里面的按钮:%@",x);
    }];
    /**
     KVO监听一个对象的属性
     */
    [[self.view rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self]subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"%@",x);
    }];
    /**
     监听事件
     */
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了按钮:%@",x);
    }];
    /**
     代替通知
     */
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NSNotificationCenterSignal" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@",x.object);
    }];
    /**
     监听文本框的文字改变
     */
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
#pragma mark - reactiveCocoa
    /**
     给某个对象的某个属性绑定
     */
    RAC(self,fieldText) = self.textField.rac_textSignal;
    /**
     监听某个对象的属性值
     */
    [RACObserve(self.view, subviews) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    /**元组*/
    RACTuple *tuple = RACTuplePack(@"曾祥宪",@20,@"man");
    RACTupleUnpack(NSString *name,NSNumber *age,NSString *sex) = tuple;
    NSLog(@"name:%@,age:%@,sex:%@",name,age,sex);
    
    
}
#pragma mark - advancedOperation
- (void)advancedOperation{
    /**
     bind 底层方法
     */
    [[self.textField.rac_textSignal bind:^RACSignalBindBlock _Nonnull{
        NSLog(@"%@",[NSDate date]);
        return ^RACSignal *(id value,BOOL *stop){
            NSLog(@"%@ -- %@",value,[NSDate date]);
            return [RACReturnSignal return:[NSString stringWithFormat:@"#%@",value]];
        };
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@ -- %@",x,[NSDate date]);
    }];
    
    /**
     flattenMap,map 映射
     FlatternMap中的Block返回信号
     Map中的Block返回对象
     */
    [[self.textField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        NSLog(@"%@",value);
        return [RACReturnSignal return:[NSString stringWithFormat:@"@:%@",value]];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    /**
     字典映射成模型
     */
    NSDictionary *dict_map = @{@"name":@"zoekebi",@"age":@18,@"sex":@"man"};
    Person *person = [Person new];
    id Id = [[dict_map.rac_sequence map:^id _Nullable(RACTuple * _Nullable value) {
        RACTupleUnpack(NSString *key,id val) = value;
        [person setValue:val forKey:key];
        return @"返回什么，head就是什么";
    }] head];
    NSLog(@"Id:%@ person:%@",Id,person);
    /**
     concat 按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号
     */
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"sendData1"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"sendData2"];
        [subscriber sendCompleted];
        return nil;
    }];
    [[signal1 concat:signal2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        NSLog(@"signal1 and signal2 have sended Msg,then goto there");
    }];
    /**
     then 可以用于依赖
     */
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@2];
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    /**
     merge 把多个信号合并为一个信号，任何一个信号有新值的时候就会调用. 这个方法有点类似于concat
     */
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"fuck1"];
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"fuck2"];
        return nil;
    }];
    [[signalA merge:signalB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    /**
     zip 把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。
     */
    [[signalA zipWith:signalB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"zip:%@",x);
    }];
    /**
     combineLatest 将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
     */
    [[RACSignal combineLatest:@[signalA,signalB,signal1,signal2]] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"combineLatest:%@",x);
    }];
    /**
    combineLatestWith 将两个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。和zip有点类似
     */
    
    [[signalB combineLatestWith:signalA] subscribeNext:^(id  _Nullable x) {
        NSLog(@"combineLatestWith:%@",x);
    }];
    /**
     reduce 聚合
     */
    [[RACSignal combineLatest:@[signalA,signalB,signal1,signal2] reduce:^id _Nullable(id v1,id v2,id v3,id v4){
        return [NSString stringWithFormat:@"%@-%@-%@-%@",v1,v2,v3,v4];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    /**
     filter 过滤信号，使用它可以获取满足条件的信号
     */
    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 5;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"filter%@",x);
    }];
    /**
     ignore 忽略完某些值的信号
     */
    [[self.textField.rac_textSignal ignore:@"aaaa"]subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"ignore%@",x);
    }];
    /**
     distinctUntilChanged 当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉
     */
    [[self.textField.rac_textSignal distinctUntilChanged]subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"distinctUntilChanged:%@",x);
    }];
    RACSubject *subject = [RACSubject subject];
    /**
     take 从开始一共取N次的信号
     */
    [[subject take:2]subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject:%@",x);
    }];
    
    /**
     取最后N次的信号,前提条件，订阅者必须调用sendCompleted完成
     */
    [[subject takeLast:2]subscribeNext:^(id  _Nullable x) {
        NSLog(@"takeLast:%@",x);
    }];
    /**
     skip跳过几个信号,不接受
     */
    [[subject skip:1]subscribeNext:^(id  _Nullable x) {
        NSLog(@"skip:%@",x);
    }];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    [subject sendCompleted];
    /**
     switchToLatest 信号的信号
     */
#warning todo
    /**
     timeout 超时
     */
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"请求数据");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber performSelector:@selector(sendNext:) withObject:@"timeout"];
            [subscriber sendCompleted];
        });
        return nil;
    }] timeout:3 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受到了数据%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
    
    /**
     interval 定时
     */
    [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler] withLeeway:1] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"%@",x);
    }];
    /**
     delay 延时发送next
     */
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        return nil;
    }] delay:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"delay:%@",x);
    }];
    /**
     retry 重试
     */
    __block int i = 0;
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (i==5) {
            [subscriber sendNext:@"yes"];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendError:nil];
                i++;
            });
        }
        return nil;
    }]retry]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"eeeee");
    }];
    
    /**
     throttle 节流:当某个信号发送比较频繁时，可以使用节流
     */
    RACSubject *throttlesubject = [RACSubject subject];
    _throttlesubject = throttlesubject;
    [[throttlesubject throttle:3] subscribeNext:^(id  _Nullable x) {
        NSLog(@"throttle:%@",x);
    }];
    
}



#pragma mark - 测试

- (void)dealMoreRequest{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterSignal" object:@"sendNotification"];
    
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    [self rac_liftSelector:@selector(dealResponseWithRequest1:request2:) withSignalsFromArray:@[request1,request2]];
}
- (void)dealResponseWithRequest1:(id)data1 request2:(id)data2{
    NSLog(@"data1%@--data2%@",data1,data2);
}

- (void)commandSignal{
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"执行signalBlock代码块");
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"信号中的信号的订阅者发送请求数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
        
    }];
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        
    }];
    [command execute:@"执行"];
}
- (void)multicastConnection{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"请求网络数据");
        [subscriber sendNext:@"发送数据Data"];
        return nil;
    }];
    
    RACMulticastConnection *connectSignal = [signal publish];
    
    [connectSignal.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅中1接收到:%@",x);
    }];
    [connectSignal.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅中2接收到:%@",x);
    }];
    // 链接信号的时候会把源信号订阅
    [connectSignal connect];
}
- (void)replaySubject{
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject sendNext:@"发送数据a"];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受到数据：%@",x);
    }];
}
- (void)subjectAsDelegate{
    ViewController2 *vc2 = [[ViewController2 alloc] init];
    
    [self presentViewController:vc2 animated:YES completion:^{
        NSLog(@"跳转到第二个控制器成功");
        
        RACSubject *subject = [RACSubject subject];
        [subject subscribeNext:^(id  _Nullable x) {
            NSLog(@"接受到了subject发送过来的数据:%@",x);
        }];
        vc2.delegateSignal = subject;
    }];
}
- (void)subjectTest{
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject被订阅1执行的block接受到的发送值%@",x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subject被订阅2执行的block接受到的发送值%@",x);
    }];
    [subject sendNext:@"subect发送的数据"];
}
- (void)signalTest{
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"发送的数据Data"];
        [subscriber sendError:nil];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被销毁了");
        }];
        return nil;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受到的数据：%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"错误信号：%@",error);
    } completed:^{
        NSLog(@"信号发送完成");
    }];
}

- (void)sequenceAll_Any{
    NSArray *array = @[@1,@2,@3,@4];
    BOOL result = [array.rac_sequence any:^BOOL(id  _Nullable value) {
        return [value integerValue]>5;
    }];
    NSLog(result?@"有元素大于五":@"没有一个元素大于5");
    BOOL result2 = [array.rac_sequence all:^BOOL(id  _Nullable value) {
        return [value integerValue]>0;
    }];
    NSLog(result2?@"所有元素大于0":@"有一个元素小于0");
}

- (void)sequenceTest1{
    NSArray *array = @[@1,@2,@3,@4];
    NSLog(@"%@", array.rac_sequence.tail.array);
    id obj = [array.rac_sequence foldLeftWithStart:@"start" reduce:^id _Nullable(id  _Nullable accumulator, id  _Nullable value) {
        NSLog(@"%@",accumulator);
        NSLog(@"%@",value);
        return [NSString stringWithFormat:@"%@|%@",accumulator,value];
    }];
    id obj2 = [array.rac_sequence foldRightWithStart:@"start" reduce:^id _Nullable(id  _Nullable first, RACSequence * _Nonnull rest) {
        NSLog(@"%@",first);
        NSLog(@"%@",rest);
        return [NSString stringWithFormat:@"%@|%@",rest.head,first];
    }];
    NSLog(@"%@",obj);
    NSLog(@"%@",obj2);
}

#pragma mark - 字典转模型 传统方法加映射
- (void)modelsWithKeyValue_map{
    NSArray *modelArray = @[
                            @{@"name":@"zoekebi",@"age":@18,@"sex":@"man"},
                            @{@"name":@"Jeamls",@"age":@16,@"sex":@"man"},
                            @{@"name":@"haha",@"age":@14,@"sex":@"woman"},
                            ];
    NSArray *persons = [[modelArray.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return [Person personWithDict:value];
    }] array];
    NSLog(@"%@",persons);
}
/// 模型数组 - 字典转模型
- (void)modelsWithKeyValue_nomal{
    NSArray *modelArray = @[
                            @{@"name":@"zoekebi",@"age":@18,@"sex":@"man"},
                            @{@"name":@"Jeamls",@"age":@16,@"sex":@"man"},
                            @{@"name":@"haha",@"age":@14,@"sex":@"woman"},
                            ];
    
    NSMutableArray *persons = [NSMutableArray array];
    [modelArray.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        [persons addObject:[Person personWithDict:x]];
    } completed:^{
        NSLog(@"%@",persons);
    }];
}
/// 字典遍历
- (void)dictsignal{
    NSDictionary *dict = @{@"name":@"zoekebi",@"age":@18,@"sex":@"man"};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [dict.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(NSString *key,id value) = x;
        NSLog(@"key:%@  value:%@",key,value);
    }];
}
/// 数组遍历
- (void)arraysignal{
    NSArray *array = @[@"1",@"2",@"1",@"2",@"1",@"2",@"1",@"2"];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
