//
//  HYPEnvironmentSelectorPlugin.h
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyperioniOS/HYPPlugin.h>
#import "HYPEnvironmentSelectorManager.h"

NS_ASSUME_NONNULL_BEGIN

@class HYPEnvironmentSelectorPluginModule;
@protocol HYPEnvironmentItemProtocol;

@interface HYPEnvironmentSelectorPlugin : NSObject<HYPPlugin>

@property (class, nonatomic, strong, readonly) HYPEnvironmentSelectorManager *manager;
// 是否在侧边栏显示，默认为YES
@property (class, nonatomic, assign) BOOL isShowInSidebarList;

@end

NS_ASSUME_NONNULL_END

