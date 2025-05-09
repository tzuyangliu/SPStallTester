//
//  SPStallTester.m
//  QQMusic
//
//  Created by tzuyangliu on 05/09/2025.
//  Copyright (c) 2025 tzuyangliu. All rights reserved.
//

#import "SPStallTester.h"

@interface SPStallTester ()

/// 目的是持有testTask，不让他在执行完之前释放
@property (strong, nonatomic) NSMutableSet<SPStallTestTask *> *taskSet;

@end

@implementation SPStallTester

+ (instancetype)sharedInstance
{
    static SPStallTester *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SPStallTester new];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _taskSet = [NSMutableSet set];
    }
    return self;
}

- (void)runTestWithTestCase:(SPStallTestCase *)testCase completion:(SPStallTestCompletionBlock)completionBlock expireButFinishBlock:(nonnull SPStallTestCompletionBlock)expireButFinishBlock
{
    NSAssert(testCase != nil, @"Test Case is Empty!");
    SPStallTestTask *task = [[SPStallTestTask alloc] initWithTestCase:testCase];
    [self addReference:task];
    __weak typeof(self) weakSelf = self;
    [task runTestWithCompletionBlock:^(SPStallTestTask *bTask) {
        __strong typeof(self) strongSelf = weakSelf;
        if (completionBlock)
        {
            completionBlock(bTask);
        }
        // 如果当前不是超时导致的失败，就说明流程结束可以移除引用了，否则等超时后的结果回调再移除
        if (bTask.testResult.type != SPStallTestResultTypeTimeout)
        {
            [strongSelf removeReference:bTask];
        }
    } expireButFinishBlock:^(SPStallTestTask *bTask) {
        __strong typeof(self) strongSelf = weakSelf;
        if (expireButFinishBlock)
        {
            expireButFinishBlock(bTask);
        }
        [strongSelf removeReference:bTask];
    }];
}

#pragma mark - Private (TaskManage)

- (void)addReference:(SPStallTestTask *)task
{
    if (!task)
    {
        return;
    }
    @synchronized (self.taskSet)
    {
        if (NO == [self.taskSet containsObject:task])
        {
            [self.taskSet addObject:task];
        }
    }
}

- (void)removeReference:(SPStallTestTask *)task
{
    if (!task)
    {
        return;
    }
    @synchronized (self.taskSet)
    {
        if ([self.taskSet containsObject:task])
        {
            [self.taskSet removeObject:task];
        }
    }
}

@end
