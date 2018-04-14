//
//  HYPEnvironmentSelectorPluginMenuItem.m
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPEnvironmentSelectorPluginMenuItem.h"
#import <HyperioniOS/HyperionManager.h>

@interface HYPEnvironmentSelectorPluginMenuItem() <HYPPluginMenuItemDelegate>

@end

@implementation HYPEnvironmentSelectorPluginMenuItem

@synthesize delegate = _delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // 不设置selected
    [super setSelected:NO animated:NO];
}

- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    [[HyperionManager sharedInstance] togglePluginDrawer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.actionDelegate respondsToSelector:@selector(environmentSelectorPluginMenuItemAction:)]) {
            [self.actionDelegate environmentSelectorPluginMenuItemAction:self];
        }
    });
}

@end
