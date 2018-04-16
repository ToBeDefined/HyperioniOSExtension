//
//  HYPFPSMonitorPluginModule.m
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <HyperioniOS/HYPPluginMenuItem.h>
#import <HyperioniOS/HyperionManager.h>
#import "HYPFPSMonitorPluginModule.h"
#import "HYPFPSMonitorManager.h"

@interface HYPFPSMonitorPluginModule() <HYPPluginMenuItemDelegate>

@property (nonatomic, class, assign) BOOL isShowingHYPFPSMonitorView;
@property (nonatomic, strong) HYPPluginMenuItem *menu;

@end

@implementation HYPFPSMonitorPluginModule

static BOOL __HYPFPSMonitorIsShowingHYPFPSMonitorView = NO;
+ (void)setIsShowingHYPFPSMonitorView:(BOOL)isShowingHYPFPSMonitorView {
    __HYPFPSMonitorIsShowingHYPFPSMonitorView = isShowingHYPFPSMonitorView;
}

+ (BOOL)isShowingHYPFPSMonitorView {
    return __HYPFPSMonitorIsShowingHYPFPSMonitorView;
}

- (UIView *)pluginMenuItem {
    if (self.menu) {
        return self.menu;
    }
    HYPPluginMenuItem *menu = [[HYPPluginMenuItem alloc] init];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"fpsMonitor"
                                                                           ofType:@"png"];
    menu.delegate = self;
    [menu bindWithTitle:@"FPS Monitor"
                  image:[UIImage imageWithContentsOfFile:imagePath]];
    self.menu = menu;
    return menu;
}

- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    self.class.isShowingHYPFPSMonitorView = !self.class.isShowingHYPFPSMonitorView;
    [HYPFPSMonitorManager showFPSMonitor:self.class.isShowingHYPFPSMonitorView];
    [pluginView setSelected:self.class.isShowingHYPFPSMonitorView animated:YES];
    [[HyperionManager sharedInstance] togglePluginDrawer];
}

@end
