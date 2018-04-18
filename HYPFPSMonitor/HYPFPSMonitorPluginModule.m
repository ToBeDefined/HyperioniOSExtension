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
#import <HyperioniOS/HYPPluginExtensionImp.h>
#import "HYPFPSMonitorPluginModule.h"
#import "HYPFPSMonitorManager.h"

@interface HYPFPSMonitorPluginModule() <HYPPluginMenuItemDelegate>

@property (nonatomic, assign) BOOL isShowingHYPFPSMonitorView;
@property (nonatomic, strong) HYPPluginMenuItem *menu;

@end

@implementation HYPFPSMonitorPluginModule

+ (instancetype)sharedInstance {
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HYPPluginExtension *pluginExtension = [[HYPPluginExtension alloc] initWithSnapshotContainer:nil
                                                                                   overlayContainer:nil
                                                                                         hypeWindow:nil
                                                                                     attachedWindow:nil];
        __instance = [[[self class] alloc] initWithExtension:pluginExtension];
    });
    return __instance;
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
    [menu setSelected:self.isShowingHYPFPSMonitorView animated:YES];
    self.menu = menu;
    return menu;
}

#pragma mark - HYPPluginMenuItemDelegate
- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    self.isShowingHYPFPSMonitorView = !self.isShowingHYPFPSMonitorView;
    [[HyperionManager sharedInstance] togglePluginDrawer];
    [self showHYPFPSMonitor:self.isShowingHYPFPSMonitorView];
}

#pragma mark - Private Func
- (void)showHYPFPSMonitor:(BOOL)isShow {
    self.isShowingHYPFPSMonitorView = isShow;
    [HYPFPSMonitorManager showFPSMonitor:isShow];
    [self.menu setSelected:isShow animated:YES];
}

@end
