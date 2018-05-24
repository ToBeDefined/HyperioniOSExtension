//
//  HYPEnvironmentSelectorManager.h
//  HYPEnvironmentSelector
//
//  Created by TBD on 2018/5/23.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HYPEnvironmentItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ __nullable EnvironmentSelectedBlock)(NSObject <HYPEnvironmentItemProtocol> * _Nullable obj);

@interface HYPEnvironmentSelectorManager : NSObject

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
#pragma clang diagnostic pop

@property (class, nonatomic, readonly) HYPEnvironmentSelectorManager *shared;

@property (nonatomic, copy) NSArray <NSObject <HYPEnvironmentItemProtocol>*> * _Nullable environmentItems;
// 自定义URL编辑界面的模板
@property (nonatomic, strong) NSObject <HYPEnvironmentItemProtocol> * _Nullable customEnvironmentItemTemplate;
@property ( nonatomic, copy) EnvironmentSelectedBlock environmentSelectedBlock;
// 是否允许以列表中的item为基础修改（默认为NO）
@property (nonatomic, assign) BOOL isCanEditItemFromListItem;
// 是否正在显示
@property (nonatomic, assign, readonly) BOOL isShowingEnvironmentSelectorWindow;

- (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated
                                  isCanCancel:(BOOL)isCanCancel
                              completionBlock:(void (^_Nullable)(void))completion;
- (void)hideEnvironmentSelectorWindowAnimated:(BOOL)animated
                              completionBlock:(void (^_Nullable)(void))completion;

- (Class)getEnvironmentItemClass;


+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
