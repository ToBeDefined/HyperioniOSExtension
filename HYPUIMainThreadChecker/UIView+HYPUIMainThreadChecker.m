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

BOOL isMainQueue(void) {
    static const void *mainQueueKey = @"__T_MainQueue_T__";
    static void *mainQueueContext = @"__T_MainQueue_T__";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_set_specific(dispatch_get_main_queue(), mainQueueKey, mainQueueContext, nil);
    });
    
    return dispatch_get_specific(mainQueueKey) == mainQueueContext;
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
        __t_main_thread_checker_safe_swizzling_exchange_instance_method(self,
                                                                        @selector(addSubview:),
                                                                        @selector(__t_addSubview:));
        __t_main_thread_checker_safe_swizzling_exchange_instance_method(self,
                                                                        @selector(removeFromSuperview),
                                                                        @selector(__t_removeFromSuperview));
    });
}

- (void)__t_setNeedsLayout {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        [self operationIsInMainQueue];
    }
    [self __t_setNeedsLayout];
}

- (void)__t_setNeedsDisplay {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        [self operationIsInMainQueue];
    }
    [self __t_setNeedsDisplay];
}

- (void)__t_setNeedsDisplayInRect:(CGRect)rect {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        [self operationIsInMainQueue];
    }
    [self __t_setNeedsDisplayInRect:rect];
}

- (void)__t_layoutSubviews {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        [self operationIsInMainQueue];
    }
    [self __t_layoutSubviews];
}

- (void)__t_addSubview:(UIView *)view {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        // 使用断言，debug模式下崩溃看栈信息上一步，切换为主线程操作
        NSAssert(isMainQueue(), @"not in main queue, type 'cmd + 7', see call stark");
    }
    [self __t_addSubview:view];
}

- (void)__t_removeFromSuperview {
    if (HYPUIMainThreadCheckerPluginModule.isShouldCheckMainThread) {
        // 使用断言，debug模式下崩溃看栈信息上一步，切换为主线程操作
        NSAssert(isMainQueue(), @"not in main queue, type 'cmd + 7', see call stark");
    }
    [self __t_removeFromSuperview];
}

- (BOOL)operationIsInMainQueue {
    // 修改检测是否为main_queue, http://ios.jobbole.com/87535/
    if (isMainQueue()) {
        return YES;
    }
    NSArray<NSString *> *symbols = [NSThread callStackSymbols];
    
    NSString *logTips = @"1. 'layoutSubviews' error maybe is 'removeFormSupperView' or 'addSubView:' in child thread.\n2. other error maybe create UI in child thread. \n3. '__t_addSubview:' or '__t_removeFromSuperview' see call stack symbols(before this func)";
    NSString *logMessage = [NSString stringWithFormat:@"Class: %@, Instance: %@\n\nTips:\n%@\n\nsymbols:\n%@", [self class], self, logTips, symbols];
    [self showAlertControllerWithMessage:logMessage];
    return NO;
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
