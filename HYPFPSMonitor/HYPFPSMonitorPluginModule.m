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

- (void)dealloc {
    // Never Run
    [[HYPFPSMonitorManager sharedManager] removeObserver:self
                                              forKeyPath:NSStringFromSelector(@selector(isShowingFPSMonitorView))];
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
    [menu setSelected:[HYPFPSMonitorManager sharedManager].isShowingFPSMonitorView animated:YES];
    self.menu = menu;
    [[HYPFPSMonitorManager sharedManager] addObserver:self
                                           forKeyPath:NSStringFromSelector(@selector(isShowingFPSMonitorView))
                                              options:NSKeyValueObservingOptionNew
                                              context:nil];
    return menu;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isShowingFPSMonitorView))]
        && object == [HYPFPSMonitorManager sharedManager]) {
        BOOL isShow = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        [self.menu setSelected:isShow animated:NO];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - HYPPluginMenuItemDelegate
- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    [[HyperionManager sharedInstance] togglePluginDrawer];
    [self showHYPFPSMonitor:![HYPFPSMonitorManager sharedManager].isShowingFPSMonitorView];
}

#pragma mark - Private Func
- (void)showHYPFPSMonitor:(BOOL)isShow {
    if (isShow) {
        [[HYPFPSMonitorManager sharedManager] showFPSMonitor];
    } else {
        [[HYPFPSMonitorManager sharedManager] hideFPSMonitor];
    }
}

@end
