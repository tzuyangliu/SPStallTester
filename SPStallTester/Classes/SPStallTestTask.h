//
//  SPStallTestTask.h
//  SPStallTester
//
//  Created by tzuyangliu on 2025/5/9.
//
//  代码执行卡死检测 - 检测任务

#import <Foundation/Foundation.h>
#import "SPStallTestCase.h"
#import "SPStallTestResult.h"
@class SPStallTestTask;

NS_ASSUME_NONNULL_BEGIN

/// 检测结果回调block
/// @param task 检测任务
typedef void (^SPStallTestCompletionBlock)(SPStallTestTask *task);


@interface SPStallTestTask : NSObject

// 输入

/// 检测用例
@property (strong, nonatomic, readonly) SPStallTestCase *testCase;

/// 检测任务标识符，唯一（自动生成）
/// 格式：类名-name-时间戳
@property (strong, nonatomic, readonly) NSString *identifier;

// 输出

/// 是否检测结束，检测结束代表检测过程执行完成，不表示是否成功与失败
@property (assign, atomic, readonly) BOOL finished;

/// 检测结果
@property (strong, nonatomic, readonly) SPStallTestResult *testResult;

/// 超时但是最终完成检测的结果（仅当检测结果超时，后续有结果后，才有值）
@property (strong, nonatomic, readonly) SPStallTestResult *expireButFinishTestResult;

/// 初始化
/// @param testCase 检测用例
- (instancetype)initWithTestCase:(SPStallTestCase *)testCase;

/// 执行检测
/// 可以在任意线程调用
/// @param completionBlock 结果回调
/// @param expireButFinishBlock 超时但最终完成的回调
- (void)runTestWithCompletionBlock:(SPStallTestCompletionBlock)completionBlock expireButFinishBlock:(SPStallTestCompletionBlock)expireButFinishBlock;

@end

NS_ASSUME_NONNULL_END
