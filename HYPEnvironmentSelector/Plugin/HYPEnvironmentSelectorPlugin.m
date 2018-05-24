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


@implementation HYPEnvironmentSelectorPlugin

+ (void)load {
    // 防止load时候还未添加方法
    Method setIsShowInSidebarListMethod = class_getClassMethod([self class], @selector(setIsShowInSidebarList:));
    class_addMethod(objc_getMetaClass(object_getClassName([self class])),
                    @selector(setIsShowInSidebarList:),
                    method_getImplementation(setIsShowInSidebarListMethod),
                    method_getTypeEncoding(setIsShowInSidebarListMethod));
    [self setIsShowInSidebarList:YES];
}

+ (HYPEnvironmentSelectorManager *)manager {
    return [HYPEnvironmentSelectorManager sharedManager];
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


#pragma mark - HYPPlugin
+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    return [HYPEnvironmentSelectorPluginModule sharedInstance];
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end


