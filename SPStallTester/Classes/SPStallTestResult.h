//
//  SPStallTestResult.h
//  SPStallTester
//
//  Created by tzuyangliu on 2025/5/9.
//
//  代码执行卡死检测 - 检测结果

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 检测返回结果类型
typedef NS_ENUM(NSUInteger, SPStallTestResultType)
{
    SPStallTestResultTypeSucceed        = 0,    // 成功
    SPStallTestResultTypeReturnFalse    = 1,    // 检测代码返回失败
    SPStallTestResultTypeTimeout        = 2,    // 检测代码执行超时
    SPStallTestResultTypeThrowException = 3,    // 检测代码抛出异常
};

@interface SPStallTestResult : NSObject

/// 是否检测成功
/// 成功的条件是以下几点全部满足：
/// 1. testBlock执行结束并返回YES
/// 2. testBlock执行过程未产生异常
/// 3. testBlock执行耗时在timeCostLimit范围内
@property (assign, nonatomic, readonly) BOOL succeed;

/// 结果类型
@property (assign, nonatomic, readonly) SPStallTestResultType type;

/// 耗时
@property (assign, nonatomic, readonly) NSTimeInterval timeCost;

/// 异常（如果有产生）
@property (strong, nonatomic, readonly) NSException *exception;

- (instancetype)initWithType:(SPStallTestResultType)type timeCost:(NSTimeInterval)timeCost exception:(nullable NSException *)exception;

@end

NS_ASSUME_NONNULL_END
