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
static NSArray *__environmentItems = nil;
+ (void)setEnvironmentItems:(NSArray *)environmentItems {
    __environmentItems = environmentItems;
}

+ (NSArray *)environmentItems {
    return __environmentItems;
}


#pragma mark - customEnvironmentItemTemplate
static id __customEnvironmentItemTemplate = nil;
+ (void)setCustomEnvironmentItemTemplate:(id)customEnvironmentItemTemplate {
    __customEnvironmentItemTemplate = customEnvironmentItemTemplate;
}

+ (id)customEnvironmentItemTemplate {
    return __customEnvironmentItemTemplate;
}


#pragma mark - environmentSelectedBlock
static __strong EnvironmentSelectedBlock __environmentSelectedBlock = nil;
+ (void)setEnvironmentSelectedBlock:(EnvironmentSelectedBlock)environmentSelectedBlock {
    __environmentSelectedBlock = [environmentSelectedBlock copy];
}

+ (EnvironmentSelectedBlock)environmentSelectedBlock {
    return __environmentSelectedBlock;
}


#pragma mark - isCanEditItemFromListItem
static BOOL __isShowInSidebarList = YES;
+ (void)setIsShowInSidebarList:(BOOL)isShowInSidebarList {
    __isShowInSidebarList = isShowInSidebarList;
}

+ (BOOL)isShowInSidebarList {
    return __isShowInSidebarList;
}


#pragma mark - isCanEditItemFromListItem
static BOOL __isCanEditItemFromListItem = NO;
+ (void)setIsCanEditItemFromListItem:(BOOL)isCanEditItemFromListItem {
    __isCanEditItemFromListItem = isCanEditItemFromListItem;
}

+ (BOOL)isCanEditItemFromListItem {
    return __isCanEditItemFromListItem;
}



#pragma mark - pluginModule
static HYPEnvironmentSelectorPluginModule *__pluginModule = nil;
+ (void)setPluginModule:(HYPEnvironmentSelectorPluginModule *)pluginModule {
    __pluginModule = pluginModule;
}

+ (HYPEnvironmentSelectorPluginModule *)pluginModule {
    if (__pluginModule == nil) {
        HYPPluginExtension *pluginExtension = [[HYPPluginExtension alloc] initWithSnapshotContainer:nil
                                                                                   overlayContainer:nil
                                                                                         hypeWindow:nil
                                                                                     attachedWindow:nil];
        return [self createPluginModule:pluginExtension];
    }
    return __pluginModule;
}

#pragma mark - Show/Hide Environment Selector
+ (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated completionBlock:(void (^)(void))completion {
    HYPEnvironmentSelectorPluginModule *m = self.pluginModule;
    [m showEnvironmentSelectorWindowAnimated:animated completionBlock:completion];
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
    if (__environmentItems.count > 0) {
        return __environmentItems;
    }
    NSAssert(NO, @"should set `HYPEnvironmentSelectorPlugin.environmentItems` or set `HYPEnvironmentSelectorPlugin.environmentItemsPlistName`, plist should set array in root, array's element is dictionary, and dictionary should have key: `name`, all value is `NSString`");
    return nil;
}


#pragma mark - HYPPlugin
+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    // pluginExtension没使用到，不再重复创建
    if (__pluginModule) {
        return __pluginModule;
    }
    HYPEnvironmentSelectorPluginModule *pluginModule = [[HYPEnvironmentSelectorPluginModule alloc] initWithExtension:pluginExtension];
    __pluginModule = pluginModule;
    return pluginModule;
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end


