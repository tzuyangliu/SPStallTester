# SPStallTester

[![Version](https://img.shields.io/cocoapods/v/SPStallTester.svg?style=flat)](https://cocoapods.org/pods/SPStallTester)
[![License](https://img.shields.io/cocoapods/l/SPStallTester.svg?style=flat)](https://cocoapods.org/pods/SPStallTester)
[![Platform](https://img.shields.io/cocoapods/p/SPStallTester.svg?style=flat)](https://cocoapods.org/pods/SPStallTester)

SPStallTester 是一个提供给iOS开发者使用的代码逻辑卡死检测工具，用于解决某些特定的代码逻辑在特定的场景下可能会耗时较久（例如涉及到IPC访问的剪贴板、媒体库、ODR等），直接在主线程执行耗时过长可能会导致watchdog闪退的问题。该工具支持传入一个代码block，自动创建一个独立的子线程执行，并返回执行结果（成功、失败、超时、超时但最终成功），接入方可以基于执行结果来决定后续的流程

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SPStallTester is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SPStallTester'
```

## Usage

1. 创建一个 ``SPStallTestCase`` 实例，例如我需要检查系统剪贴板是否工作正常：

```Objective-C
SPStallTestCase *testCase = [[SPStallTestCase alloc] initWithTestName:@"`Pasteboard`" testBlock:^BOOL{
    // 思路：创建一个剪贴板，看是否可以正常返回，如果卡死的话这个函数就不会返回了
    UIPasteboard *p = [UIPasteboard pasteboardWithName:@"xxx" create:YES];
    // 如果返回的剪贴板为空，认为逻辑失败
    return p != nil;
} timeCostLimit:5];
```

2. 在合适的时机通过 `SPStallTester` 执行检测：

```Objective-C
[SPStallTester.sharedInstance runTestWithTestCase:testCase completion:^(SPStallTestTask * _Nonnull task) {
    // 返回执行结果（成功、失败、超时）
} expireButFinishBlock:^(SPStallTestTask * _Nonnull task) {
    // 超时但最终执行完成（成功、失败）
}];
```

## Author

tzuyangliu, i@zyliu.com

## License

SPStallTester is available under the MIT license. See the LICENSE file for more info.

