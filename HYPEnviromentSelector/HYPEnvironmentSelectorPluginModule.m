//
//  HYPEnvironmentSelectorPluginModule.m
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <HyperioniOS/HYPPluginMenuItem.h>
#import "HYPEnvironmentSelectorPluginModule.h"
#import "HYPEnvironmentSelectorPluginMenuItem.h"
#import "HYPEnvironmentSelectorPlugin.h"

@interface HYPEnvironmentSelectorPluginModule() <HYPEnvironmentSelectorPluginMenuItemDelegate>

@property (nonatomic, copy) NSArray<HYPEnvironmentItem *> *items;

@end

@implementation HYPEnvironmentSelectorPluginModule

- (instancetype)initWithExtension:(id<HYPPluginExtension>)extension {
    return [self initWithExtension:extension environmentItems:nil];
}

- (instancetype)initWithExtension:(id)extension environmentItems:(NSArray<HYPEnvironmentItem *> *)items {
    self = [super initWithExtension:extension];
    if (self) {
        self.items = items;
    }
    return self;
}

- (UIView *)pluginMenuItem {
    HYPEnvironmentSelectorPluginMenuItem *menu = [[HYPEnvironmentSelectorPluginMenuItem alloc] init];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"env"
                                                                           ofType:@"png"];
    [menu bindWithTitle:@"Environment Selector"
                  image:[UIImage imageWithContentsOfFile:imagePath]];
    menu.actionDelegate = self;
    return menu;
}

- (void)environmentSelectorPluginMenuItemAction:(HYPEnvironmentSelectorPluginMenuItem *)menuItem {
    NSLog(@"TEST");
    EnvironmentSelectedBlock block = [HYPEnvironmentSelectorPlugin.environmentSelectedBlock copy];
    if (block) {
        block([NSObject new]);
    }
}

@end
