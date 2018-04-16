//
//  HYPFPSMonitorPlugin.m
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPFPSMonitorPlugin.h"
#import "HYPFPSMonitorPluginModule.h"
#import <HyperioniOS/HYPPluginExtensionImp.h>

@interface HYPFPSMonitorPlugin()
@property (nonatomic, class, strong) HYPFPSMonitorPluginModule * _Nullable pluginModule;
@end

@implementation HYPFPSMonitorPlugin

#pragma mark - pluginModule
static HYPFPSMonitorPluginModule *__pluginModule = nil;
+ (HYPFPSMonitorPluginModule *)pluginModule {
    if (__pluginModule == nil) {
        HYPPluginExtension *pluginExtension = [[HYPPluginExtension alloc] initWithSnapshotContainer:nil
                                                                                   overlayContainer:nil
                                                                                         hypeWindow:nil
                                                                                     attachedWindow:nil];
        return [self createPluginModule:pluginExtension];
    }
    return __pluginModule;
}

+ (void)setPluginModule:(HYPFPSMonitorPluginModule *)pluginModule {
    __pluginModule = pluginModule;
}


+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    // pluginExtension没使用到，不再重复创建
    if (__pluginModule) {
        return __pluginModule;
    }
    HYPFPSMonitorPluginModule *pluginModule = [[HYPFPSMonitorPluginModule alloc] initWithExtension:pluginExtension];
    __pluginModule = pluginModule;
    return pluginModule;
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end
