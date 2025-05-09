//
//  SPStallTester.h
//  QQMusic
//
//  Created by sheepliu(刘子洋) on 2020/1/7.
//  Copyright © 2020 Tencent. All rights reserved.
//
//  代码执行卡死检测

#import <Foundation/Foundation.h>
#import "SPStallTestTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPStallTester : NSObject

/// 获取单例
+ (instancetype)sharedInstance;

/// 执行一个卡死检测，指定testCase对象
/// @param testCase 检测对象
/// @param completionBlock 结果回调
/// @param expireButFinishBlock 超时但最终完成的回调
- (void)runTestWithTestCase:(SPStallTestCase *)testCase completion:(SPStallTestCompletionBlock)completionBlock expireButFinishBlock:(SPStallTestCompletionBlock)expireButFinishBlock;

@end

NS_ASSUME_NONNULL_END
