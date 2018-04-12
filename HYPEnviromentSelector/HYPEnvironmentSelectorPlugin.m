//
//  HYPEnvironmentSelectorPlugin.m
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentSelectorPluginModule.h"

@interface HYPEnvironmentSelectorPlugin()

@property (nonatomic, class, weak) HYPEnvironmentSelectorPluginModule *pluginModule;

@end

@implementation HYPEnvironmentSelectorPlugin

#pragma mark - environmentItems
static NSArray<HYPEnvironmentItem *> *__environmentItems = nil;
+ (void)setEnvironmentItems:(NSArray<HYPEnvironmentItem *> *)environmentItems {
    __environmentItems = environmentItems;
}

+ (NSArray<HYPEnvironmentItem *> *)environmentItems {
    return __environmentItems;
}

#pragma mark - pluginModule
static HYPEnvironmentSelectorPluginModule *__pluginModule = nil;
+ (void)setPluginModule:(HYPEnvironmentSelectorPluginModule *)pluginModule {
    __pluginModule = pluginModule;
}

+ (HYPEnvironmentSelectorPluginModule *)pluginModule {
    return __pluginModule;
}

#pragma mark -
static __strong EnvironmentSelectedBlock __environmentSelectedBlock = nil;
+ (void)setEnvironmentSelectedBlock:(EnvironmentSelectedBlock)environmentSelectedBlock {
    __environmentSelectedBlock = [environmentSelectedBlock copy];
}

+ (EnvironmentSelectedBlock)environmentSelectedBlock {
    return __environmentSelectedBlock;
}


#pragma mark - HYPPlugin
+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    HYPEnvironmentSelectorPluginModule *pluginModule = [[HYPEnvironmentSelectorPluginModule alloc]
                                                        initWithExtension:pluginExtension
                                                        environmentItems:self.environmentItems];
    self.pluginModule = pluginModule;
    return pluginModule;
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end


