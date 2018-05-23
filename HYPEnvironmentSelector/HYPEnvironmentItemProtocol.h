//
//  HYPEnvironmentItemProtocol.h
//  HYPEnvironmentSelector
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

/**
 1️⃣. ObjC 对象定义注意点：
 1. 必须符合 `HYPEnvironmentItemProtocol` 协议
 2. 必须包含 `name` property
 2️⃣. Swift 对象注意点：
 1. 必须继承自 `NSObject`，符合 `HYPEnvironmentItemProtocol` 协议
 2. 类定义时候必须动态化属性(定义前加上 `\@objcMembers`)
 3. 必须包含`var name: String?` 变量
 4. 必须实现`required override init() { super.init() }`方法
 5. 所有属性使用变量`var`，不可使用常量`let`
 
 // ObjC
 @interface <#MyEnvItem#>: NSObject <HYPEnvironmentItemProtocol>
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, copy) NSString *<#otherVariable#>;
 @end
 
 @implementation <#MyEnvItem#>
 @end
 
 // Swift
 @objcMembers
 class <#MyEnvItem#>: NSObject, HYPEnvironmentItemProtocol {
     var name: String?
     <#other variable#>
 
     required override init() {
         super.init()
     }
 }
 */
@protocol HYPEnvironmentItemProtocol <NSObject>

@property (nonatomic, copy) NSString * _Nullable name;

- (instancetype __nonnull)init;

@end

#pragma clang diagnostic pop

