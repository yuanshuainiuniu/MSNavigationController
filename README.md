# MSNavigationController

[![CI Status](https://img.shields.io/travis/Marshal/MSNavigationController.svg?style=flat)](https://travis-ci.org/Marshal/MSNavigationController)
[![Version](https://img.shields.io/cocoapods/v/MSNavigationController.svg?style=flat)](https://cocoapods.org/pods/MSNavigationController)
[![License](https://img.shields.io/cocoapods/l/MSNavigationController.svg?style=flat)](https://cocoapods.org/pods/MSNavigationController)
[![Platform](https://img.shields.io/cocoapods/p/MSNavigationController.svg?style=flat)](https://cocoapods.org/pods/MSNavigationController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MSNavigationController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MSNavigationController'
```
## 如何使用   
跟系统导航栏一样，可在vc中控制导航栏
```swift
extension UIViewController {

    ///隐藏导航栏线
    @objc public var ms_hiddenNavigationBarLine: Bool

    ///设置手势返回识别距离屏幕最小距离，默认全屏
    @objc public var ms_interactivePopMaxAllowedInitialDistanceToLeftEdge: CGFloat

    ///禁用手势返回
    @objc public var ms_interactivePopDisabled: Bool

    ///禁用全屏手势返回
    @objc public var ms_disableFullscreenPopGR: Bool
    ///隐藏导航栏
    @objc public var ms_navigationBarHidden: Bool
}
```
## Author

717999274@qq.com, Marshal

## License

MSNavigationController is available under the MIT license. See the LICENSE file for more info.
