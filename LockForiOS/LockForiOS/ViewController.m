//
//  ViewController.m
//  LockForiOS
//
//  Created by mewe on 2018/3/8.
//  Copyright © 2018年 zenon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (atomic,strong) NSArray *arr;
@property (nonatomic,assign) NSUInteger count;

@property (strong, nonatomic) NSCondition *condition;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

#pragma mark NSConditionLock 多线程依赖
- (IBAction)tapConditionLock:(id)sender {
    //根据条件固定执行 2 / 1 / 3
    NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:2];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [conditionLock lockWhenCondition:1];
        
        NSLog(@"线程 1");
        [conditionLock unlockWithCondition:0];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [conditionLock lockWhenCondition:2];
        
        NSLog(@"线程 2");
        
        [conditionLock unlockWithCondition:1];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [conditionLock lockWhenCondition:0];
        
        NSLog(@"线程 3");
        
        [conditionLock unlock];
    });

}

#pragma mark NSCondition 生产-消费问题
- (IBAction)tapCondition:(id)sender {
    self.condition = [[NSCondition alloc] init];
    self.count  = 0;
    
    //创建生产-消费者
    for (int i=0; i<50; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self producer];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self consumer];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self consumer];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self producer];
        });
      
    }
    
 
}

- (void)producer{
    [self.condition lock];
    self.count = self.count + 1;
    NSLog(@"生产 count %zd",self.count);
    [self.condition signal];
    [self.condition unlock];
}

- (void)consumer{
    [self.condition lock];

    while (self.count == 0) {//注意使用 while 判断二次确认， if 不能保证安全
        NSLog(@"等待 count %zd",self.count);
        [self.condition wait];
    }
 
    //注意消费行为，要在等待条件判断之后
    self.count = self.count - 1;
    NSLog(@"消费 count %zd",self.count);
    
    [self.condition unlock];
}

#pragma mark @Synchonized 递归
- (IBAction)tapSynchonized:(id)sender {
   
    id obj = [[NSObject alloc] init];
    self.count = 1000;
    [self testRecursionForSynchonized:obj];

}

// mutex 递归死锁
- (IBAction)tapMutexCrashForRecursion:(id)sender {
    
    self.count = 1000;
    
    NSLock *lock = [[NSLock alloc] init];
    [self testRecursionForMutex:lock];
}

//@Synchonized
- (void)testRecursionForSynchonized:(id)obj{
    if(self.count>0){
        NSLog(@"count:%zd \n", self.count);
        @synchronized (obj) {
            self.count = self.count - 1;
            [self testRecursionForSynchonized:obj];
        }
    }
}

//递归死锁
- (void)testRecursionForMutex:(NSLock *)lock{
    if(self.count>0){
        NSLog(@"count:%zd \n", self.count);
        [lock lock];
        self.count = self.count - 1;
        [self testRecursionForMutex:lock];
        [lock unlock];
    }
}

#pragma mark Semaphore 多线程并发
- (IBAction)tapSemaphore:(id)sender {
    
    long threadLimitNum = 2;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(threadLimitNum);
    
    for (int i = 0; i < 2000; i ++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"Thread A:%@ \n", [NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"Thread B:%@ \n", [NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"Thread C:%@ \n", [NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
    }
}



#pragma mark atomic 线程安全
- (IBAction)tapLockForAtomic:(id)sender {
    
    NSLock *arrLock = [[NSLock alloc] init];
    //thread A
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
   
        for (int i = 0; i < 2000; i ++) {
            [arrLock lock];
            if (i % 2 == 0) {
                self.arr = @[@"1", @"2", @"3"];
            }
            else {
                self.arr = @[@"1"];
            }
            NSLog(@"Thread A:%@ %@\n", [NSThread currentThread],self.arr);
            [arrLock unlock];
        }
    });
    //thread B
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
  
        for (int i = 0; i < 2000; i ++) {
            [arrLock lock];
            if (self.arr.count >= 2) {
                NSLog(@"Thread B:%@ %@\n", [NSThread currentThread],self.arr);
                [self.arr objectAtIndex:1];
            }
            [arrLock unlock];
        }
    });
}

- (IBAction)tapAtomicCrash:(id)sender {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //thread A
        for (int i = 0; i < 2000; i ++) {
            if (i % 2 == 0) {
                self.arr = @[@"1", @"2", @"3"];
            }
            else {
                self.arr = @[@"1"];
            }
            NSLog(@"Thread A:%@ %@\n", [NSThread currentThread],self.arr);
        }
    });
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //thread B
        for (int i = 0; i < 2000; i ++) {
            if (self.arr.count >= 2) {
                NSLog(@"Thread B:%@ %@\n", [NSThread currentThread],self.arr);
                [self.arr objectAtIndex:1];
            }
        }
    });
}

@end
