//
//  SPStallTestCase.m
//  QQMusic
//
//  Created by tzuyangliu on 05/09/2025.
//  Copyright (c) 2025 tzuyangliu. All rights reserved.
//

#import "SPStallTestCase.h"

/// 默认超时限制，3秒
/// 超时配置优先级：外部传参(self.timeCostLimit) > 默认超时设置(kDefaultTimeCostLimit)
static const NSTimeInterval kDefaultTimeCostLimit = 3.f;

@interface SPStallTestCase ()

/// 检测名称
@property (strong, nonatomic, readwrite) NSString *name;

/// 耗时限制，执行超过这个时间算作失败（秒）
@property (assign, nonatomic, readwrite) NSTimeInterval timeCostLimit;

/// 检测代码
@property (copy, nonatomic, readwrite) SPStallTestBlock testBlock;

@end

@implementation SPStallTestCase

- (instancetype)initWithTestName:(NSString *)testName testBlock:(SPStallTestBlock)testBlock
{
    self = [self initWithTestName:testName testBlock:testBlock timeCostLimit:kDefaultTimeCostLimit];
    return self;
}

- (instancetype)initWithTestName:(NSString *)testName testBlock:(SPStallTestBlock)testBlock timeCostLimit:(NSTimeInterval)timeCostLimit
{
    self = [super init];
    if (self)
    {
        NSAssert(testName != nil, @"Test Name is Empty!");
        NSAssert(testBlock != nil, @"Test Block is Empty!");
        _name = testName;
        _testBlock = testBlock;
        _timeCostLimit = timeCostLimit;
    }
    return self;
}

@end
