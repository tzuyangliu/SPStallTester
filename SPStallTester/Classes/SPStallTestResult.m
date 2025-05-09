//
//  SPStallTestResult.m
//  SPStallTester
//
//  Created by tzuyangliu on 2025/5/9.
//

#import "SPStallTestResult.h"

@interface SPStallTestResult ()

/// 结果类型
@property (assign, nonatomic, readwrite) SPStallTestResultType type;

/// 耗时
@property (assign, nonatomic, readwrite) NSTimeInterval timeCost;

/// 异常（如果有产生）
@property (strong, nonatomic, readwrite) NSException *exception;

@end

@implementation SPStallTestResult

- (instancetype)initWithType:(SPStallTestResultType)type timeCost:(NSTimeInterval)timeCost exception:(NSException *)exception
{
    if (self = [super init])
    {
        _type = type;
        _timeCost = timeCost;
        _exception = exception;
    }
    return self;
}

- (BOOL)succeed
{
    return self.type == SPStallTestResultTypeSucceed;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> type=%@, timeCost=%.3fs, exception=%@", self.class, self, @(self.type), self.timeCost, self.exception];
}

@end
