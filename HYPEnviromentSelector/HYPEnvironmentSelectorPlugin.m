//
//  HYPEnvironmentSelectorPlugin.m
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentSelectorPluginModule.h"
#import <HyperioniOS/HYPPluginExtensionImp.h>

@interface HYPEnvironmentSelectorPlugin()
@property (nonatomic, class, strong) HYPEnvironmentSelectorPluginModule * _Nullable pluginModule;
@end

@implementation HYPEnvironmentSelectorPlugin


#pragma mark - environmentItems
static NSArray *__HYPEnvironmentSelectorEnvironmentItems = nil;
+ (void)setEnvironmentItems:(NSArray *)environmentItems {
    __HYPEnvironmentSelectorEnvironmentItems = environmentItems;
}

+ (NSArray *)environmentItems {
    return __HYPEnvironmentSelectorEnvironmentItems;
}


#pragma mark - customEnvironmentItemTemplate
static id __HYPEnvironmentSelectorCustomEnvironmentItemTemplate = nil;
+ (void)setCustomEnvironmentItemTemplate:(id)customEnvironmentItemTemplate {
    __HYPEnvironmentSelectorCustomEnvironmentItemTemplate = customEnvironmentItemTemplate;
}

+ (id)customEnvironmentItemTemplate {
    return __HYPEnvironmentSelectorCustomEnvironmentItemTemplate;
}


#pragma mark - environmentSelectedBlock
static __strong EnvironmentSelectedBlock __HYPEnvironmentSelectorEnvironmentSelectedBlock = nil;
+ (void)setEnvironmentSelectedBlock:(EnvironmentSelectedBlock)environmentSelectedBlock {
    __HYPEnvironmentSelectorEnvironmentSelectedBlock = [environmentSelectedBlock copy];
}

+ (EnvironmentSelectedBlock)environmentSelectedBlock {
    return __HYPEnvironmentSelectorEnvironmentSelectedBlock;
}


#pragma mark - isCanEditItemFromListItem
static BOOL __HYPEnvironmentSelectorIsShowInSidebarList = YES;
+ (void)setIsShowInSidebarList:(BOOL)isShowInSidebarList {
    __HYPEnvironmentSelectorIsShowInSidebarList = isShowInSidebarList;
}

+ (BOOL)isShowInSidebarList {
    return __HYPEnvironmentSelectorIsShowInSidebarList;
}


#pragma mark - isCanEditItemFromListItem
static BOOL __HYPEnvironmentSelectorIsCanEditItemFromListItem = NO;
+ (void)setIsCanEditItemFromListItem:(BOOL)isCanEditItemFromListItem {
    __HYPEnvironmentSelectorIsCanEditItemFromListItem = isCanEditItemFromListItem;
}

+ (BOOL)isCanEditItemFromListItem {
    return __HYPEnvironmentSelectorIsCanEditItemFromListItem;
}



#pragma mark - pluginModule
static HYPEnvironmentSelectorPluginModule *__HYPEnvironmentSelectorPluginModule = nil;
+ (void)setPluginModule:(HYPEnvironmentSelectorPluginModule *)pluginModule {
    __HYPEnvironmentSelectorPluginModule = pluginModule;
}

+ (HYPEnvironmentSelectorPluginModule *)pluginModule {
    if (__HYPEnvironmentSelectorPluginModule == nil) {
        HYPPluginExtension *pluginExtension = [[HYPPluginExtension alloc] initWithSnapshotContainer:nil
                                                                                   overlayContainer:nil
                                                                                         hypeWindow:nil
                                                                                     attachedWindow:nil];
        return [self createPluginModule:pluginExtension];
    }
    return __HYPEnvironmentSelectorPluginModule;
}

#pragma mark - Show/Hide Environment Selector
+ (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated completionBlock:(void (^)(void))completion {
    [self.pluginModule showEnvironmentSelectorWindowAnimated:animated completionBlock:completion];
}

+ (void)hideEnvironmentSelectorWindowAnimated:(BOOL)animated completionBlock:(void (^)(void))completion {
    [self.pluginModule hideEnvironmentSelectorWindowAnimated:animated completionBlock:completion];
}


#pragma mark - Private Func
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

+ (NSArray *)getEnvironmentItems {
    if (__HYPEnvironmentSelectorEnvironmentItems.count > 0) {
        return __HYPEnvironmentSelectorEnvironmentItems;
    }
    NSAssert(NO, @"should set `HYPEnvironmentSelectorPlugin.environmentItems` or set `HYPEnvironmentSelectorPlugin.environmentItemsPlistName`, plist should set array in root, array's element is dictionary, and dictionary should have key: `name`, all value is `NSString`");
    return nil;
}


#pragma mark - HYPPlugin
+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    // pluginExtension没使用到，不再重复创建
    if (__HYPEnvironmentSelectorPluginModule) {
        return __HYPEnvironmentSelectorPluginModule;
    }
    HYPEnvironmentSelectorPluginModule *pluginModule = [[HYPEnvironmentSelectorPluginModule alloc] initWithExtension:pluginExtension];
    __HYPEnvironmentSelectorPluginModule = pluginModule;
    return pluginModule;
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end


