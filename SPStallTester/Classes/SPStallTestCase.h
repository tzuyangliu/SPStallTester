//
//  SPStallTestCase.h
//  QQMusic
//
//  Created by sheepliu(刘子洋) on 2020/1/7.
//  Copyright © 2020 Tencent. All rights reserved.
//
//  代码执行卡死检测 - 检测用例

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 检测代码block
typedef BOOL (^SPStallTestBlock)(void);

@interface SPStallTestCase : NSObject

/// 检测名称
/// 用来跟其他检测做上报区分的，需要设置非空值
@property (strong, nonatomic, readonly) NSString *name;

/// 耗时限制，执行超过这个时间算作失败（秒）
@property (assign, nonatomic, readonly) NSTimeInterval timeCostLimit;

/// 检测代码
/// testBlock有BOOL的返回值，如果返回NO，认为执行失败
@property (copy, nonatomic, readonly) SPStallTestBlock testBlock;

/// 初始化一个检测用例，使用默认超时上限
/// @param testName 测试名称，不要传空，用来做上报区分的
/// @param testBlock 检测代码
- (instancetype)initWithTestName:(NSString *)testName testBlock:(SPStallTestBlock)testBlock;

/// 初始化一个检测用例，并设置超时上限
/// @param testName 测试名称，不要传空，用来做上报区分的
/// @param testBlock 检测代码
/// @param timeCostLimit 耗时限制。如果传入0，则按照默认超时处理
- (instancetype)initWithTestName:(NSString *)testName testBlock:(SPStallTestBlock)testBlock timeCostLimit:(NSTimeInterval)timeCostLimit;

@end

NS_ASSUME_NONNULL_END
