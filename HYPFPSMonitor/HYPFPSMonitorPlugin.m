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


@implementation HYPFPSMonitorPlugin

+ (HYPFPSMonitorManager *)manager {
    return [HYPFPSMonitorManager sharedManager];
}

#pragma mark - HYPPlugin
+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    return [HYPFPSMonitorPluginModule sharedInstance];
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end
