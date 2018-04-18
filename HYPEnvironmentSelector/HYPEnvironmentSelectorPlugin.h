//
//  HYPEnvironmentSelectorPlugin.h
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyperioniOS/HYPPlugin.h>
#import "HYPEnvironmentItemManage.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

NS_ASSUME_NONNULL_BEGIN

@class HYPEnvironmentSelectorPluginModule;
@protocol HYPEnvironmentItemProtocol;

typedef void (^ __nullable EnvironmentSelectedBlock)(NSObject <HYPEnvironmentItemProtocol> * _Nullable obj);

@interface HYPEnvironmentSelectorPlugin : NSObject<HYPPlugin>


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
 @property (nonatomic, strong) NSString *name;
 @property (nonatomic, strong) NSString *<#otherVariable#>;
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
@property (nonatomic, class, copy) NSArray <NSObject <HYPEnvironmentItemProtocol>*> * _Nullable environmentItems;
// 自定义URL编辑界面的模板
@property (nonatomic, class, strong) NSObject <HYPEnvironmentItemProtocol> * _Nullable customEnvironmentItemTemplate;
@property (nonatomic, class, copy) EnvironmentSelectedBlock environmentSelectedBlock;
// 是否在侧边栏显示，默认为YES
@property (nonatomic, class, assign) BOOL isShowInSidebarList;
// 是否允许以列表中的item为基础修改（默认为NO）
@property (nonatomic, class, assign) BOOL isCanEditItemFromListItem;

+ (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated
                              completionBlock:(void (^_Nullable)(void))completion;
+ (void)hideEnvironmentSelectorWindowAnimated:(BOOL)animated
                              completionBlock:(void (^_Nullable)(void))completion;

+ (NSArray *_Nullable)getEnvironmentItems;
+ (Class)getEnvironmentItemClass;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop

