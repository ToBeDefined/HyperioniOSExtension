<div align="center">

HyperioniOSExtension
------

</div>

<div align="center">

![platform](https://img.shields.io/badge/Platform-iOS%E2%89%A59.0-brightgreen.svg)&nbsp;
[![CocoaPods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg?style=flat)](http://cocoapods.org/)&nbsp;
[![Build Status](https://travis-ci.org/ToBeDefined/HyperioniOSExtension.svg?branch=master)](https://travis-ci.org/ToBeDefined/HyperioniOSExtension)&nbsp;
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/tobedefined/HyperioniOSExtension/blob/master/LICENSE)

</div>

<div align="center">

[English Document](README.md)

</div>

**在使用之前，[先看注意点](Note.md)**

### HYPEnvironmentSelector

#### Cocoapods导入

```ruby
pod 'HyperioniOSExtension/EnvironmentSelector', :configurations => ['Debug'] # Not Depend HyperioniOS, iOS Version >= 7.0

or

pod 'HyperioniOSExtension/EnvironmentSelector-Plugin', :configurations => ['Debug'] # Depend HyperioniOS, iOS Version >= 9.0
```

#### 使用


```objc
// 若使用不依赖 HyperioniOS 的版本, 下面的 `HYPEnvironmentSelectorPlugin.manager` 替换成 `[HYPEnvironmentSelectorManager sharedManager]`
// 设置环境选择页面的环境变量，`environmentItems` 的 element 必须符合 `HYPEnvironmentItemProtocol` 协议
HYPEnvironmentSelectorPlugin.manager.environmentItems = @[envItem1, envItem2, envItem3];

// 主动填写环境变量的模板
HYPEnvironmentSelectorPlugin.manager.customEnvironmentItemTemplate = envItem1;

// 设置选择环境之后的回调
HYPEnvironmentSelectorPlugin.manager.environmentSelectedBlock = ^(NSObject<HYPEnvironmentItemProtocol> * _Nullable obj) {
    // 点选环境设置之后返回对应的obj，此处做选择之后的操作
};

// 是否显示在 `HyperioniOS` 右侧的栏目内
HYPEnvironmentSelectorPlugin.manager.isShowInSidebarList = YES/NO;

// 是否显示允许以 `environmentItems` 的 element 为模板进行编辑
HYPEnvironmentSelectorPlugin.manager.isCanEditItemFromListItem = YES/NO;

// 主动弹出环境选择页面
[HYPEnvironmentSelectorPlugin.manager showEnvironmentSelectorWindowAnimated:YES isCanCancel:YES completionBlock:^{
    // 弹出之后的回调
}];

// 主动隐藏环境选择页面
[HYPEnvironmentSelectorPlugin.manager hideEnvironmentSelectorWindowAnimated:YES completionBlock:^{
    // 隐藏之后的回调
}];
```


#### 符合HYPEnvironmentItemProtocol协议的对象注意点

`ObjC` 对象定义注意点：

 1. 必须符合 `HYPEnvironmentItemProtocol` 协议
 2. 必须包含 `name` property

```objc
@interface MyEnvItem : NSObject <HYPEnvironmentItemProtocol>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *otherVariable;
@end
 
@implementation MyEnvItem
@end
```

`Swift` 对象注意点：

 1. 必须继承自 `NSObject`，符合 `HYPEnvironmentItemProtocol` 协议
 2. 类定义时候必须动态化属性(`Swift 4+`定义前加上 `@objcMembers`)
 3. 必须包含`var name: String?` 变量
 4. 必须实现`required override init() { super.init() }`方法
 5. 所有属性使用变量`var`，不可使用常量`let`
 6. 所有属性类型为`Optional`可选型`String`，即`String?`

```swift
@objcMembers
class MyEnvItem: NSObject, HYPEnvironmentItemProtocol {
    var name: String?
    var otherVariable: String?
 
    required override init() {
        super.init()
    }
}
```


### HYPFPSMonitor

#### Cocoapods导入

```ruby
pod 'HyperioniOSExtension/FPSMonitor', :configurations => ['Debug'] # Not Depend HyperioniOS, iOS Version >= 6.0

or

pod 'HyperioniOSExtension/FPSMonitor-Plugin', :configurations => ['Debug'] # Depend HyperioniOS, iOS Version >= 9.0
```

#### 使用


```objc
// 若使用不依赖 HyperioniOS 的版本, 下面的 `HYPFPSMonitorPlugin.manager` 替换成 `[HYPFPSMonitorManager sharedManager]`
// 设置是否允许触摸/拖动FPS监控View
HYPFPSMonitorPlugin.manager.isCanTouchFPSView = YES/NO;

// 主动显示FPS监控View
[HYPFPSMonitorPlugin.manager showFPSMonitor];

// 主动隐藏FPS监控View
[HYPFPSMonitorPlugin.manager hideFPSMonitor];
```



### HYPUIMainThreadChecker

#### Cocoapods导入

```ruby
pod 'HyperioniOSExtension/HYPUIMainThreadChecker', :configurations => ['Debug'] # Not Depend HyperioniOS, iOS Version >= 5.0

or

pod 'HyperioniOSExtension/HYPUIMainThreadChecker-Plugin', :configurations => ['Debug'] # Depend HyperioniOS, iOS Version >= 9.0
```

#### 使用


```objc
// 若使用不依赖 HyperioniOS 的版本, 下面的 `HYPUIMainThreadCheckerPlugin.manager` 替换成 `[HYPUIMainThreadCheckerManager sharedManager]`
// 开启UI操作主队列(main_queue)监控
[HYPUIMainThreadCheckerPlugin.manager open];
// 关闭UI操作主队列(main_queue)监控
[HYPUIMainThreadCheckerPlugin.manager close];
```

