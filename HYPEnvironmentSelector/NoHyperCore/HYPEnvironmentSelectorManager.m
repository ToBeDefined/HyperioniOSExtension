//
//  HYPEnvironmentSelectorManager.m
//  HYPEnvironmentSelector
//
//  Created by TBD on 2018/5/23.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPEnvironmentSelectorManager.h"
#import "HYPEnvironmentSelectorViewController.h"

@interface HYPEnvironmentSelectorManager() <NSCopying, NSMutableCopying>

@property (nonatomic, strong) UIWindow *environmentSelectorWindow;
@property (nonatomic, strong) HYPEnvironmentSelectorViewController *environmentSelectorWindowRootVC;
@property (nonatomic, weak) UIWindow *originKeyWindow;

@end

@implementation HYPEnvironmentSelectorManager

static HYPEnvironmentSelectorManager *sharedHYPEnvironmentSelectorManager = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYPEnvironmentSelectorManager = [super allocWithZone:zone];
    });
    return sharedHYPEnvironmentSelectorManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return sharedHYPEnvironmentSelectorManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return sharedHYPEnvironmentSelectorManager;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYPEnvironmentSelectorManager = [super init];
    });
    return sharedHYPEnvironmentSelectorManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYPEnvironmentSelectorManager = [[[self class] alloc] init];
    });
    return sharedHYPEnvironmentSelectorManager;
}

+ (instancetype)shared {
    return [self sharedManager];
}

#pragma mark - Show/Hide Environment Selector
- (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated
                                  isCanCancel:(BOOL)isCanCancel
                              completionBlock:(void (^ _Nullable)(void))completion {
    if (self.isShowingEnvironmentSelectorWindow) {
        return;
    }
    self->_isCanCancel = isCanCancel;
    [self willChangeValueForKey:NSStringFromSelector(@selector(isShowingEnvironmentSelectorWindow))];
    self->_isShowingEnvironmentSelectorWindow = YES;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isShowingEnvironmentSelectorWindow))];
    if (self.environmentSelectorWindow == nil) {
        HYPEnvironmentSelectorViewController *selectorVC = [[HYPEnvironmentSelectorViewController alloc] init];
        UINavigationController *rootNavigatonController = [[UINavigationController alloc] initWithRootViewController:selectorVC];
        UIWindow *environmentSelectorWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        environmentSelectorWindow.rootViewController = rootNavigatonController;
        
        self.environmentSelectorWindowRootVC = selectorVC;
        self.environmentSelectorWindow = environmentSelectorWindow;
    }
    [(UINavigationController *)self.environmentSelectorWindow.rootViewController popToRootViewControllerAnimated:NO];
    self.environmentSelectorWindowRootVC.isCanCancel = isCanCancel;
    self.environmentSelectorWindow.alpha = 0;
    self.environmentSelectorWindow.hidden = NO;
    self.originKeyWindow = [UIApplication sharedApplication].keyWindow;
    [self.environmentSelectorWindow makeKeyAndVisible];
    if (animated) {
        [UIView animateWithDuration:0.1 animations:^{
            self.environmentSelectorWindow.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    } else {
        self.environmentSelectorWindow.alpha = 1;
        if (completion) {
            completion();
        }
    }
}

- (void)hideEnvironmentSelectorWindowAnimated:(BOOL)animated
                              completionBlock:(void (^)(void))completion {
    if (self.environmentSelectorWindow) {
        if (animated) {
            [UIView animateWithDuration:0.1 animations:^{
                self.environmentSelectorWindow.alpha = 0;
            } completion:^(BOOL finished) {
                [self afterHideEnvironmentSelectorWindowAnimation:completion];
            }];
        } else {
            [self afterHideEnvironmentSelectorWindowAnimation:completion];
        }
    }
}


- (void)afterHideEnvironmentSelectorWindowAnimation:(void (^)(void))completion {
    self.environmentSelectorWindow.alpha = 0;
    [self willChangeValueForKey:NSStringFromSelector(@selector(isShowingEnvironmentSelectorWindow))];
    self->_isShowingEnvironmentSelectorWindow = NO;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isShowingEnvironmentSelectorWindow))];
    self.environmentSelectorWindow.hidden = YES;
    [self.originKeyWindow makeKeyWindow];
    self.originKeyWindow = nil;
    if (completion) {
        completion();
    }
}

#pragma mark - Private Func
- (Class)getEnvironmentItemClass {
    id item = self.environmentItems.firstObject;
    if (item != nil) {
        return [item class];
    }
    
    id baseItem = self.customEnvironmentItemTemplate;
    if (baseItem != nil) {
        return [baseItem class];
    }
    
    return [NSNull class];
}

@end
