//
//  UIView+HYPUIMainThreadChecker.m
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import "HYPUIMainThreadCheckerPluginModule.h"
#import "UIView+HYPUIMainThreadChecker.h"

static inline void __t_main_thread_checker_safe_swizzling_exchange_instance_method(Class cls, SEL originalSel, SEL swizzledSel) {
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSel);
    
    BOOL success = class_addMethod(cls,
                                   originalSel,
                                   method_getImplementation(swizzledMethod),
                                   method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(cls,
                            swizzledSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod,
                                       swizzledMethod);
    }
}

@implementation UIView (HYPUIMainThreadChecker)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __t_main_thread_checker_safe_swizzling_exchange_instance_method(self,
                                                                        @selector(setNeedsLayout),
                                                                        @selector(__t_setNeedsLayout));
        __t_main_thread_checker_safe_swizzling_exchange_instance_method(self,
                                                                        @selector(setNeedsDisplay),
                                                                        @selector(__t_setNeedsDisplay));
        __t_main_thread_checker_safe_swizzling_exchange_instance_method(self,
                                                                        @selector(setNeedsDisplayInRect:),
                                                                        @selector(__t_setNeedsDisplayInRect:));
        __t_main_thread_checker_safe_swizzling_exchange_instance_method(self,
                                                                        @selector(layoutSubviews),
                                                                        @selector(__t_layoutSubviews));
    });
}

- (void)__t_setNeedsLayout {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        [self checkUIOperationInMainThread];
    }
    [self __t_setNeedsLayout];
}

- (void)__t_setNeedsDisplay {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        [self checkUIOperationInMainThread];
    }
    [self __t_setNeedsDisplay];
}

- (void)__t_setNeedsDisplayInRect:(CGRect)rect {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        [self checkUIOperationInMainThread];
    }
    [self __t_setNeedsDisplayInRect:rect];
}

- (void)__t_layoutSubviews {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        [self checkUIOperationInMainThread];
    }
    [self __t_layoutSubviews];
}

- (void)checkUIOperationInMainThread {
    if ([NSThread isMainThread]) {
        return;
    }
    NSArray<NSString *> *symbols = [NSThread callStackSymbols];
    
    NSString *logTips = @"1. layoutSubviews error maybe is removeFormSupperView or addSubView in child thread.\n2. other error maybe create UI in child thread.";
    NSString *logMessage = [NSString stringWithFormat:@"Class: %@, Instance: %@\n\nTips:\n%@\n\nsymbols:\n%@", [self class], self, logTips, symbols];
    [self showAlertControllerWithMessage:logMessage];
    
}

- (void)showAlertControllerWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"UI Operation Not In MainThread"
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Log To Console"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSLog(@"%@", message);
                                                          }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController
                                                                                     animated:YES
                                                                                   completion:nil];
    });
}


@end
