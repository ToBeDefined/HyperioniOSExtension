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
@property (nonatomic, class, weak) HYPEnvironmentSelectorPluginModule * _Nullable pluginModule;
@end

@implementation HYPEnvironmentSelectorPlugin

#pragma mark - environmentItems
static NSArray *__environmentItems = nil;
+ (void)setEnvironmentItems:(NSArray *)environmentItems {
    __environmentItems = environmentItems;
}

+ (NSArray *)environmentItems {
    return __environmentItems;
}

#pragma mark - environmentItemsPlistName
static NSString *__environmentItemsPlistName = nil;
+ (void)setEnvironmentItemsPlistName:(NSString *)environmentItemsPlistName {
    __environmentItemsPlistName = environmentItemsPlistName;
}

+ (NSString *)environmentItemsPlistName {
    return __environmentItemsPlistName;
}

+ (Class)getEnvironmentItemClass {
    id item = [self getEnvironmentItems].firstObject;
    if (item == nil) {
        return [NSNull class];
    }
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary class];
    } else {
        return [item class];
    }
}

#pragma mark - environmentSelectedBlock
static __strong EnvironmentSelectedBlock __environmentSelectedBlock = nil;
+ (void)setEnvironmentSelectedBlock:(EnvironmentSelectedBlock)environmentSelectedBlock {
    __environmentSelectedBlock = [environmentSelectedBlock copy];
}

+ (EnvironmentSelectedBlock)environmentSelectedBlock {
    return __environmentSelectedBlock;
}

#pragma mark - pluginModule
static __weak HYPEnvironmentSelectorPluginModule *__pluginModule = nil;
+ (void)setPluginModule:(HYPEnvironmentSelectorPluginModule *)pluginModule {
    __pluginModule = pluginModule;
}

+ (HYPEnvironmentSelectorPluginModule *)pluginModule {
    return __pluginModule;
}


+ (NSArray *)getEnvironmentItems {
    if (self.environmentItems.count > 0) {
        return self.environmentItems;
    }
    
    if (self.environmentItemsPlistName) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.environmentItemsPlistName
                                                              ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
        if (array) {
            return array;
        }
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (dict) {
            return @[dict];
        }
    }
    NSAssert(NO, @"should set `HYPEnvironmentSelectorPlugin.environmentItems` or set `HYPEnvironmentSelectorPlugin.environmentItemsPlistName`, plist should set array in root, array's element is dictionary, and dictionary should have key: `name`, all value is `NSString`");
    return nil;
}

+ (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated completionBlock:(void (^)(void))completion {
    [self.pluginModule showEnvironmentSelectorWindowAnimated:animated completionBlock:completion];
}

+ (void)hideEnvironmentSelectorWindowAnimated:(BOOL)animated completionBlock:(void (^)(void))completion {
    [self.pluginModule hideEnvironmentSelectorWindowAnimated:animated completionBlock:completion];
}


#pragma mark - HYPPlugin
+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    if (self.pluginModule) {
        return self.pluginModule;
    }
    HYPEnvironmentSelectorPluginModule *pluginModule = [[HYPEnvironmentSelectorPluginModule alloc] initWithExtension:pluginExtension];
    self.pluginModule = pluginModule;
    return pluginModule;
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end


