//
//  HYPEnvironmentSelectorPluginMenuItem.h
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyperioniOS/HYPPluginMenuItem.h>

@class HYPEnvironmentSelectorPluginMenuItem;

@protocol HYPEnvironmentSelectorPluginMenuItemDelegate <NSObject>

- (void)environmentSelectorPluginMenuItemAction:(HYPEnvironmentSelectorPluginMenuItem *)menuItem;

@end

@interface HYPEnvironmentSelectorPluginMenuItem : HYPPluginMenuItem

@property (nonatomic, weak) id <HYPEnvironmentSelectorPluginMenuItemDelegate> actionDelegate;

@end
