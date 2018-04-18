//
//  HYPFPSMonitorPlugin.m
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import <HyperioniOS/HYPPluginExtensionImp.h>
#import "HYPFPSMonitorPlugin.h"
#import "HYPFPSMonitorPluginModule.h"

@interface HYPFPSMonitorPlugin()
@property (nonatomic, class, strong) HYPFPSMonitorPluginModule * _Nullable pluginModule;
@end

@implementation HYPFPSMonitorPlugin

+ (void)load {
    // 防止load时候还未添加方法
    Method setIsCanTouchFPSViewMethod = class_getClassMethod([self class], @selector(setIsCanTouchFPSView:));
    class_addMethod([self class],
                    @selector(setIsCanTouchFPSView:),
                    method_getImplementation(setIsCanTouchFPSViewMethod),
                    method_getTypeEncoding(setIsCanTouchFPSViewMethod));
    [self setIsCanTouchFPSView:YES];
}

#pragma mark - isCanTouchFPSView
+ (void)setIsCanTouchFPSView:(BOOL)isCanTouchFPSView {
    objc_setAssociatedObject(self,
                             @selector(isCanTouchFPSView),
                             @(isCanTouchFPSView),
                             OBJC_ASSOCIATION_RETAIN);
    [self.pluginModule setIsCanTouchFPSView:isCanTouchFPSView];
}

+ (BOOL)isCanTouchFPSView {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - pluginModule
+ (void)setPluginModule:(HYPFPSMonitorPluginModule *)pluginModule {
    objc_setAssociatedObject(self,
                             @selector(pluginModule),
                             pluginModule,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (HYPFPSMonitorPluginModule *)pluginModule {
    HYPFPSMonitorPluginModule *pluginModule = objc_getAssociatedObject(self, _cmd);
    if (pluginModule) {
        return pluginModule;
    }
    HYPFPSMonitorPluginModule *newPluginModule = [self createNewHYPFPSMonitorPluginModule];
    self.pluginModule = newPluginModule;
    return newPluginModule;
}

#pragma mark - HYPPlugin
+ (nonnull HYPFPSMonitorPluginModule *)createNewHYPFPSMonitorPluginModule {
    HYPPluginExtension *pluginExtension = [[HYPPluginExtension alloc] initWithSnapshotContainer:nil
                                                                               overlayContainer:nil
                                                                                     hypeWindow:nil
                                                                                 attachedWindow:nil];
    HYPFPSMonitorPluginModule *pluginModule = [[HYPFPSMonitorPluginModule alloc] initWithExtension:pluginExtension];
    self.pluginModule = pluginModule;
    return pluginModule;
}

+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    // pluginExtension没使用到，不再重复创建
    return self.pluginModule;
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

#pragma mark - Function
+ (void)showFPSMonitor {
    [self.pluginModule showHYPFPSMonitor:YES];
}

+ (void)hideFPSMonitor {
    [self.pluginModule showHYPFPSMonitor:NO];
}

@end
