//
//  HYPFPSMonitorPluginModule.m
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import <HyperioniOS/HYPPluginMenuItem.h>
#import <HyperioniOS/HyperionManager.h>
#import "HYPFPSMonitorPluginModule.h"
#import "HYPFPSMonitorManager.h"

@interface HYPFPSMonitorPluginModule() <HYPPluginMenuItemDelegate>

@property (nonatomic, class, assign) BOOL isShowingHYPFPSMonitorView;
@property (nonatomic, strong) HYPPluginMenuItem *menu;

@end

@implementation HYPFPSMonitorPluginModule

#pragma mark - isShowingHYPFPSMonitorView
+ (void)setIsShowingHYPFPSMonitorView:(BOOL)isShowingHYPFPSMonitorView {
    objc_setAssociatedObject(self,
                             @selector(isShowingHYPFPSMonitorView),
                             @(isShowingHYPFPSMonitorView),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isShowingHYPFPSMonitorView {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsCanTouchFPSView:(BOOL)isCanTouchFPSView {
    [HYPFPSMonitorManager setFPSViewUserInterfaceEnable:isCanTouchFPSView];
}


#pragma mark - pluginMenuItem
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
    [menu setSelected:self.class.isShowingHYPFPSMonitorView animated:YES];
    self.menu = menu;
    return menu;
}

#pragma mark - HYPPluginMenuItemDelegate
- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    self.class.isShowingHYPFPSMonitorView = !self.class.isShowingHYPFPSMonitorView;
    [[HyperionManager sharedInstance] togglePluginDrawer];
    [self showHYPFPSMonitor:self.class.isShowingHYPFPSMonitorView];
}

#pragma mark - Private Func
- (void)showHYPFPSMonitor:(BOOL)isShow {
    self.class.isShowingHYPFPSMonitorView = isShow;
    [HYPFPSMonitorManager showFPSMonitor:isShow];
    [self.menu setSelected:isShow animated:YES];
}

@end
