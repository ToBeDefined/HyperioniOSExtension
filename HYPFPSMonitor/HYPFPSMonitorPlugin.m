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
