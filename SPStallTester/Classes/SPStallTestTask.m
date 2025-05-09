//
//  SPStallTestTask.m
//  SPStallTester
//
//  Created by tzuyangliu on 2025/5/9.
//

#import "SPStallTestTask.h"

@interface SPStallTestTask ()

/// 检测用例
@property (strong, nonatomic, readwrite) SPStallTestCase *testCase;

/// 检测标识
@property (strong, nonatomic, readwrite) NSString *identifier;

/// 是否检测结束，检测结束代表检测过程执行完成，不表示是否成功与失败
@property (assign, atomic, readwrite) BOOL finished;

/// 检测结果
@property (strong, nonatomic, readwrite) SPStallTestResult *testResult;

/// 超时但是最终完成检测的结果（仅当检测结果超时，后续有结果后，才有值）
@property (strong, nonatomic, readwrite) SPStallTestResult *expireButFinishTestResult;

/// 检测执行线程（自动创建和管理，外部无需设置）
/// 线程名同testName
@property (strong, nonatomic, readwrite) NSThread *thread;

/// 结果回调
@property (copy, nonatomic) SPStallTestCompletionBlock completionBlock;

/// 执行超时，但最终还是执行完成的回调
/// 只有当执行结果为 SPStallTestResultTypeTimeout，且最终执行完成的时候，才会回调
@property (copy, nonatomic) SPStallTestCompletionBlock expireButFinishBlock;

@end

@implementation SPStallTestTask

- (instancetype)initWithTestCase:(SPStallTestCase *)testCase
{
    if (self = [super init])
    {
        NSAssert(testCase != nil, @"Test Case is Empty");
        _testCase = testCase;
        _identifier = [NSString stringWithFormat:@"%@-%@-%.0f", NSStringFromClass([self class]), testCase.name, [[NSDate date] timeIntervalSince1970] * 1000];
    }
    return self;
}

- (void)dealloc
{
    [_thread cancel];
    _thread = nil;
}

- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[SPStallTestTask class]])
    {
        return NO;
    }
    SPStallTestTask *task = (SPStallTestTask *)object;
    return [self.identifier isEqual:task.identifier];
}

- (NSUInteger)hash
{
    return self.identifier.hash;
}

#pragma mark - Public

- (void)runTestWithCompletionBlock:(SPStallTestCompletionBlock)completionBlock expireButFinishBlock:(SPStallTestCompletionBlock)expireButFinishBlock
{
    // 准备开始
    self.completionBlock = completionBlock;
    self.expireButFinishBlock = expireButFinishBlock;
    
    // 耗时限制
    NSTimeInterval timeCostLimit = self.testCase.timeCostLimit;
    NSLog(@"测试任务执行准备，name:%@, timeCostLimit:%.2fs", self.identifier, timeCostLimit);
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeCostLimit * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf onReachTimeCostLimit];
    });
    
    // 执行测试线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(runTest) object:nil];
    thread.name = self.identifier;
    thread.qualityOfService = NSQualityOfServiceUtility;
    [thread start];
    self.thread = thread;
}

#pragma mark - Private (RunTest)

/// 测试内容
- (void)runTest
{
    // 记录开始时间
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"测试任务执行开始，name:%@", self.identifier);
    
    // 执行 testBlock
    BOOL ret = NO;
    NSException *exception = nil;
    @try
    {
        if (self.testCase.testBlock)
        {
            ret = self.testCase.testBlock();
        }
    }
    @catch (NSException *e)
    {
        exception = e;
    }
    
    // 记录耗时
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSTimeInterval timeCost = (NSTimeInterval)(endTime - startTime);
    NSLog(@"测试任务执行结束, name:%@, ret:%d, timeCost:%.3fms, exception:%@", self.identifier, ret, timeCost * 1000, exception);

    // 处理结果
    SPStallTestResultType resultType = SPStallTestResultTypeSucceed;
    
    if (NO == self.finished)
    {
        // 如果未超时，就根据执行结果来回调
        self.finished = YES;
        if (exception != nil)
        {
            // 代码产生异常
            NSLog(@"测试任务执行失败（产生异常），name:%@", self.identifier);
            resultType = SPStallTestResultTypeThrowException;
        }
        else
        {
            // 代码未产生异常
            if (ret)
            {
                // testBlock 返回成功
                NSLog(@"测试任务执行成功，name:%@", self.identifier);
                resultType = SPStallTestResultTypeSucceed;
            }
            else
            {
                // testBlock 返回失败
                NSLog(@"测试任务执行失败（测试代码ret=NO），name:%@", self.identifier);
                resultType = SPStallTestResultTypeReturnFalse;
            }
        }
        SPStallTestResult *result = [[SPStallTestResult alloc] initWithType:resultType timeCost:timeCost exception:exception];
        self.testResult = result;
        if (self.completionBlock)
        {
            self.completionBlock(self);
        }
    }
    else
    {
        // 已经超时了，completionBlock 已经在 onReachTimeCostLimit 处理过了，这里只需处理 expireButFinishBlock
        if (exception != nil)
        {
            // 代码产生异常
            resultType = SPStallTestResultTypeThrowException;
        }
        else
        {
            if (ret)
            {
                // testBlock 返回成功
                resultType = SPStallTestResultTypeSucceed;
            }
            else
            {
                // testBlock 返回失败
                resultType = SPStallTestResultTypeReturnFalse;
            }
        }
        SPStallTestResult *result = [[SPStallTestResult alloc] initWithType:resultType timeCost:timeCost exception:exception];
        self.expireButFinishTestResult = result;
        if (self.expireButFinishBlock)
        {
            self.expireButFinishBlock(self);
        }
    }
}

/// 超过耗时限制
- (void)onReachTimeCostLimit
{
    // 如果期间内已经检测完成了，什么都不用做了
    if (self.finished)
    {
        return;
    }
    
    // 标记已经完成（超时）了
    self.finished = YES;
    NSTimeInterval timeCostLimit = self.testCase.timeCostLimit;
    NSLog(@"测试任务执行失败（超时），name:%@, timeCostLimit:%.3fms", self.identifier, timeCostLimit * 1000);
    
    // 取消线程任务
    // cancel 方法只会标记线程为 canceled，但是如果卡死，无法将线程回收
    [self.thread cancel];
    self.thread = nil;
    
    // 处理结果
    SPStallTestResult *result = [[SPStallTestResult alloc] initWithType:SPStallTestResultTypeTimeout timeCost:timeCostLimit exception:nil];
    self.testResult = result;
    if (self.completionBlock)
    {
        // 这里回调的是耗时上限，因为此时测试任务还没有执行完，实际耗时未知
        self.completionBlock(self);
    }
}

@end
