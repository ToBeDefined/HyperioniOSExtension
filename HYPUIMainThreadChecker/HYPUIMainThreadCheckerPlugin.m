//
//  HYPUIMainThreadCheckerPlugin.m
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import "HYPUIMainThreadCheckerPlugin.h"
#import "HYPUIMainThreadCheckerPluginModule.h"

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
    [HYPUIMainThreadCheckerPluginModule sharedInstance].isShouldCheckMainThread = isShouldCheckUIInMainThread;
}

+ (BOOL)isShouldCheckUIInMainThread {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}


#pragma mark - HYPPlugin
+ (nonnull id<HYPPluginModule>)createPluginModule:(id<HYPPluginExtension> _Nonnull)pluginExtension {
    return [HYPUIMainThreadCheckerPluginModule sharedInstance];
}

+ (nonnull NSString *)pluginVersion {
    return [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end
