//
//  HYPUIMainThreadCheckerPlugin.m
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import <HyperioniOS/HYPPluginExtensionImp.h>
#import "HYPUIMainThreadCheckerPlugin.h"
#import "HYPUIMainThreadCheckerPluginModule.h"

@interface HYPUIMainThreadCheckerPlugin()
@property (nonatomic, class, strong) HYPUIMainThreadCheckerPluginModule * _Nullable pluginModule;
@end

@implementation HYPUIMainThreadCheckerPlugin

+ (void)load {
    // 防止load时候还未添加方法
    Method setIsShouldCheckUIInMainThreadMethod = class_getClassMethod([self class], @selector(setIsShouldCheckUIInMainThread:));
    class_addMethod(objc_getMetaClass(object_getClassName([self class])),
                    @selector(setIsShouldCheckUIInMainThread:),
                    method_getImplementation(setIsShouldCheckUIInMainThreadMethod),
                    method_getTypeEncoding(setIsShouldCheckUIInMainThreadMethod));
    self.isShouldCheckUIInMainThread = YES;
}

#pragma mark - isShouldCheckUIInMainThread
+ (void)setIsShouldCheckUIInMainThread:(BOOL)isShouldCheckUIInMainThread {
    objc_setAssociatedObject(self,
                             @selector(isShouldCheckUIInMainThread),
                             @(isShouldCheckUIInMainThread),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread = isShouldCheckUIInMainThread;
}

+ (BOOL)isShouldCheckUIInMainThread {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}


#pragma mark - pluginModule
+ (void)setPluginModule:(HYPUIMainThreadCheckerPluginModule *)pluginModule {
    objc_setAssociatedObject(self,
                             @selector(pluginModule),
                             pluginModule,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (HYPUIMainThreadCheckerPluginModule *)pluginModule {
    HYPUIMainThreadCheckerPluginModule *pluginModule = objc_getAssociatedObject(self, _cmd);
    if (pluginModule) {
        return pluginModule;
    }
    HYPUIMainThreadCheckerPluginModule *newPluginModule = [self createNewHYPUIMainThreadCheckerPluginModule];
    self.pluginModule = newPluginModule;
    return newPluginModule;
}


#pragma mark - HYPPlugin

+ (HYPUIMainThreadCheckerPluginModule *)createNewHYPUIMainThreadCheckerPluginModule {
    HYPPluginExtension *pluginExtension = [[HYPPluginExtension alloc] initWithSnapshotContainer:nil
                                                                               overlayContainer:nil
                                                                                     hypeWindow:nil
                                                                                 attachedWindow:nil];
    HYPUIMainThreadCheckerPluginModule *pluginModule = [[HYPUIMainThreadCheckerPluginModule alloc] initWithExtension:pluginExtension];
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

@end
