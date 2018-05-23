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

[中文文档](README_CN.md)

</div>

**Before Using, [Pay Attention To The Point](Note.md)**

### HYPEnvironmentSelector

#### Cocoapods Import

in `Podfile`:

```ruby
pod 'HyperioniOSExtension/HYPEnvironmentSelector', :configurations => ['Debug']
```

#### Use

```objc
// Set the environment variable of the environment selection page. 
// The element of `environmentItems` must conform to the `HYPEnvironmentItemProtocol` protocol.
HYPEnvironmentSelectorPlugin.environmentItems = @[envItem1, envItem2, envItem3];

// Actively fill in the template for the environment variable
HYPEnvironmentSelectorPlugin.customEnvironmentItemTemplate = envItem1;

// Set callback after selecting environment
HYPEnvironmentSelectorPlugin.environmentSelectedBlock = ^(NSObject<HYPEnvironmentItemProtocol> * _Nullable obj) {
    // Click on the environment setting and return the corresponding obj.
};

// Whether to show in the column to the right of `HyperioniOS`
HYPEnvironmentSelectorPlugin.isShowInSidebarList = YES/NO;

// Whether to allow editing with the element of `environmentItems` as a template
HYPEnvironmentSelectorPlugin.isCanEditItemFromListItem = YES/NO;

// Actively pop up the environment selection page
[HYPEnvironmentSelectorPlugin showEnvironmentSelectorWindowAnimated:YES isCanCancel:YES completionBlock:^{
    // Callback after popup
}];

// Actively hide the environment selection page
[HYPEnvironmentSelectorPlugin hideEnvironmentSelectorWindowAnimated:YES completionBlock:^{
    // The callback after the hide
}];
```

#### HYPEnvironmentItemProtocol object note

`ObjC` object definition notes:

 1. Must follow the `HYPEnvironmentItemProtocol` protocol
 2. Must include `name` property


```objc
@interface MyEnvItem : NSObject <HYPEnvironmentItemProtocol>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *otherVariable;
@end
 
@implementation MyEnvItem
@end
```

`Swift` object definition notes:

 1. Must inherit from `NSObject`, in line with `HYPEnvironmentItemProtocol` protocol
 2. When the class definition must dynamic properties (`Swift 4+` definition plus `@objcMembers`)
 3. Must contain the `var name: String?` variable
 4. Must implement `required override init() { super.init() }` method
 5. Use the variable `var` for all attributes. Do not use the constant `let`
 6. All attribute types are `String?`(`Optional<String>`)

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

#### Cocoapods Import

in `Podfile`:

```ruby
pod 'HyperioniOSExtension/HYPFPSMonitor', :configurations => ['Debug']
```

#### Use


```objc
// Set whether touch/drag FPS monitoring View is allowed
HYPFPSMonitorPlugin.isCanTouchFPSView = YES/NO;

// Actively display FPS monitoring View
[HYPFPSMonitorPlugin showFPSMonitor];

// Actively hide FPS monitoring View
[HYPFPSMonitorPlugin hideFPSMonitor];
```



### HYPUIMainThreadChecker

#### Cocoapods Import

in `Podfile`:

```ruby
pod 'HyperioniOSExtension/HYPUIMainThreadChecker', :configurations => ['Debug']
```

#### Use


```objc
// Turns on/off UI operation main thread (main_queue) monitoring
HYPUIMainThreadCheckerPlugin.isShouldCheckUIInMainThread = YES/NO;
```

