//
//  UIView+HYPUIMainThreadChecker.m
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+HYPUIMainThreadChecker.h"
#import "HYPUIMainThreadCheckerManager.h"

#pragma mark - Safe Exchange Method & isMainQueue Check Func
#pragma mark -

static inline
void __t_main_thread_checker_safe_swizzling_exchange_instance_method(Class cls, SEL originalSel, SEL swizzledSel) {
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSel);
    
    // 交换实现进行添加函数
    BOOL addOriginSELSuccess = class_addMethod(cls,
                                               originalSel,
                                               method_getImplementation(swizzledMethod),
                                               method_getTypeEncoding(swizzledMethod));
    BOOL addSwizzlSELSuccess = class_addMethod(cls,
                                               swizzledSel,
                                               method_getImplementation(originalMethod),
                                               method_getTypeEncoding(originalMethod));
    // 全都添加成功，返回
    if (addOriginSELSuccess && addSwizzlSELSuccess) {
        return;
    }
    // 全都添加失败，已经添加过了方法，交换
    if (!addOriginSELSuccess && !addSwizzlSELSuccess) {
        method_exchangeImplementations(originalMethod,
                                       swizzledMethod);
        return;
    }
    // addOriginSELSuccess 成功，addSwizzlSELSuccess 失败，replace SwizzlSel
    if (addOriginSELSuccess && !addSwizzlSELSuccess) {
        class_replaceMethod(cls,
                            swizzledSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        return;
    }
    // addSwizzlSELSuccess 成功，addOriginSELSuccess 失败，replace originSEL
    if (!addOriginSELSuccess && addSwizzlSELSuccess) {
        class_replaceMethod(cls,
                            originalSel,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
        return;
    }
}

static inline
BOOL isMainQueue(void) {
    static const void *mainQueueKey = @"__T_MainQueue_T__";
    static void *mainQueueContext = @"__T_MainQueue_T__";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_set_specific(dispatch_get_main_queue(), mainQueueKey, mainQueueContext, nil);
    });
    
    return dispatch_get_specific(mainQueueKey) == mainQueueContext;
}


#pragma mark - Implementation Replace
#pragma mark -

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
    if ([HYPUIMainThreadCheckerManager sharedManager].isOpen) {
        [self operationIsInMainQueue];
    }
    [self __t_setNeedsLayout];
}

- (void)__t_setNeedsDisplay {
    if ([HYPUIMainThreadCheckerManager sharedManager].isOpen) {
        [self operationIsInMainQueue];
    }
    [self __t_setNeedsDisplay];
}

- (void)__t_setNeedsDisplayInRect:(CGRect)rect {
    if ([HYPUIMainThreadCheckerManager sharedManager].isOpen) {
        [self operationIsInMainQueue];
    }
    [self __t_setNeedsDisplayInRect:rect];
}

- (void)__t_layoutSubviews {
    if ([HYPUIMainThreadCheckerManager sharedManager].isOpen) {
        [self operationIsInMainQueue];
    }
    [self __t_layoutSubviews];
}

- (void)__t_addSubview:(UIView *)view {
    if ([HYPUIMainThreadCheckerManager sharedManager].isOpen) {
        // 使用断言，debug模式下崩溃看栈信息上一步，切换为主线程操作
        NSAssert(isMainQueue(), @"not in main queue, type 'cmd + 7', see call stark");
    }
    [self __t_addSubview:view];
}

- (void)__t_removeFromSuperview {
    if ([HYPUIMainThreadCheckerManager sharedManager].isOpen) {
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
