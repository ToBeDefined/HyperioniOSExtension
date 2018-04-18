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

+ (void)load {
    // 防止load时候还未添加方法
    Method setIsCanTouchFPSViewMethod = class_getClassMethod([self class], @selector(setIsCanTouchFPSView:));
    class_addMethod(objc_getMetaClass(object_getClassName([self class])),
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
    [[HYPFPSMonitorPluginModule sharedInstance] setIsCanTouchFPSView:isCanTouchFPSView];
}

+ (BOOL)isCanTouchFPSView {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}


#pragma mark - HYPPlugin
+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    return [HYPFPSMonitorPluginModule sharedInstance];
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

#pragma mark - Function
+ (void)showFPSMonitor {
    [[HYPFPSMonitorPluginModule sharedInstance] showHYPFPSMonitor:YES];
}

+ (void)hideFPSMonitor {
    [[HYPFPSMonitorPluginModule sharedInstance] showHYPFPSMonitor:NO];
}

@end
