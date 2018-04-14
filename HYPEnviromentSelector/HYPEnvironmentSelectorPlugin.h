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

NS_ASSUME_NONNULL_BEGIN

@class HYPEnvironmentSelectorPluginModule;

typedef void (^ __nullable EnvironmentSelectedBlock)(id _Nullable obj);

@interface HYPEnvironmentSelectorPlugin : NSObject<HYPPlugin>

@property (nonatomic, class, copy) NSArray * _Nullable environmentItems;
@property (nonatomic, class, copy) EnvironmentSelectedBlock environmentSelectedBlock;

// 是否允许以列表中的item为基础修改（默认为NO）
@property (nonatomic, class, assign) BOOL isCanEditItemFromListItem;

+ (NSArray *_Nullable)getEnvironmentItems;
+ (Class)getEnvironmentItemClass;

+ (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated
                              completionBlock:(void (^_Nullable)(void))completion;
+ (void)hideEnvironmentSelectorWindowAnimated:(BOOL)animated
                              completionBlock:(void (^_Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
