//
//  HYPEnvironmentSelectorPluginMenuItem.m
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPEnvironmentSelectorPluginMenuItem.h"

@interface HYPEnvironmentSelectorPluginMenuItem() <HYPPluginMenuItemDelegate>

@end

@implementation HYPEnvironmentSelectorPluginMenuItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // 不设置selected
    [super setSelected:NO animated:NO];
}
- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    if ([self.actionDelegate respondsToSelector:@selector(environmentSelectorPluginMenuItemAction:)]) {
        [self.actionDelegate environmentSelectorPluginMenuItemAction:self];
    }
}

@end
