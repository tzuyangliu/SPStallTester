#
# Be sure to run `pod lib lint SPStallTester.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SPStallTester'
  s.version          = '1.0.0'
  s.summary          = '提供给iOS开发者使用的代码逻辑卡死检测工具.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SPStallTester 是一个提供给iOS开发者使用的代码逻辑卡死检测工具，用于解决某些特定的代码逻辑在特定的场景下可能会耗时较久（例如涉及到IPC访问的剪贴板、媒体库、ODR等），直接在主线程执行耗时过长可能会导致watchdog闪退的问题。该工具支持传入一个代码block，自动创建一个独立的子线程执行，并返回执行结果（成功、失败、超时、超时但最终成功），接入方可以基于执行结果来决定后续的流程
                       DESC

  s.homepage         = 'https://github.com/tzuyangliu/SPStallTester'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tzuyangliu' => 'i@zyliu.com' }
  s.source           = { :git => 'https://github.com/tzuyangliu/SPStallTester.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'SPStallTester/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SPStallTester' => ['SPStallTester/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
