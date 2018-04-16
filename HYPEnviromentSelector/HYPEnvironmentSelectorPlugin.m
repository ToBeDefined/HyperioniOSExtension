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
#import <objc/runtime.h>

@interface HYPEnvironmentSelectorPlugin()
@property (nonatomic, class, strong) HYPEnvironmentSelectorPluginModule * _Nullable pluginModule;
@end

@implementation HYPEnvironmentSelectorPlugin


#pragma mark - environmentItems
+ (void)setEnvironmentItems:(NSArray *)environmentItems {
    objc_setAssociatedObject(self,
                             @selector(environmentItems),
                             environmentItems,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray *)environmentItems {
    return (NSArray *)objc_getAssociatedObject(self, _cmd);
}


#pragma mark - customEnvironmentItemTemplate
+ (void)setCustomEnvironmentItemTemplate:(id)customEnvironmentItemTemplate {
    objc_setAssociatedObject(self,
                             @selector(customEnvironmentItemTemplate),
                             customEnvironmentItemTemplate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (id)customEnvironmentItemTemplate {
    return objc_getAssociatedObject(self, _cmd);
}


#pragma mark - environmentSelectedBlock
+ (void)setEnvironmentSelectedBlock:(EnvironmentSelectedBlock)environmentSelectedBlock {
    objc_setAssociatedObject(self,
                             @selector(environmentSelectedBlock),
                             environmentSelectedBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (EnvironmentSelectedBlock)environmentSelectedBlock {
    return [objc_getAssociatedObject(self, _cmd) copy];
}


#pragma mark - isShowInSidebarList
+ (void)setIsShowInSidebarList:(BOOL)isShowInSidebarList {
    objc_setAssociatedObject(self,
                             @selector(isShowInSidebarList),
                             @(isShowInSidebarList),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isShowInSidebarList {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}


#pragma mark - isCanEditItemFromListItem
+ (void)setIsCanEditItemFromListItem:(BOOL)isCanEditItemFromListItem {
    objc_setAssociatedObject(self,
                             @selector(isCanEditItemFromListItem),
                             @(isCanEditItemFromListItem),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isCanEditItemFromListItem {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}



#pragma mark - pluginModule
+ (void)setPluginModule:(HYPEnvironmentSelectorPluginModule *)pluginModule {
    objc_setAssociatedObject(self,
                             @selector(pluginModule),
                             pluginModule,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (HYPEnvironmentSelectorPluginModule *)pluginModule {
    HYPEnvironmentSelectorPluginModule *pluginModule = objc_getAssociatedObject(self, _cmd);
    if (pluginModule) {
        return pluginModule;
    }
    HYPEnvironmentSelectorPluginModule *newPluginModule = [self createNewHYPEnvironmentSelectorPluginModule];
    self.pluginModule = newPluginModule;
    return newPluginModule;
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
    if (self.environmentItems.count > 0) {
        return self.environmentItems;
    }
    NSAssert(NO, @"should set `HYPEnvironmentSelectorPlugin.environmentItems` or set `HYPEnvironmentSelectorPlugin.environmentItemsPlistName`, plist should set array in root, array's element is dictionary, and dictionary should have key: `name`, all value is `NSString`");
    return nil;
}


#pragma mark - HYPPlugin
+ (nonnull HYPEnvironmentSelectorPluginModule *)createNewHYPEnvironmentSelectorPluginModule {
    HYPPluginExtension *pluginExtension = [[HYPPluginExtension alloc] initWithSnapshotContainer:nil
                                                                               overlayContainer:nil
                                                                                     hypeWindow:nil
                                                                                 attachedWindow:nil];
    HYPEnvironmentSelectorPluginModule *pluginModule = [[HYPEnvironmentSelectorPluginModule alloc] initWithExtension:pluginExtension];
    return pluginModule;
}

+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    // pluginExtension没使用到，不再重复创建
    return self.pluginModule;
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end


