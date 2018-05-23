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

@property (nonatomic, weak) UIWindow *environmentSelectorWindow;
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
    self->_isShowingEnvironmentSelectorWindow = YES;
    if (self.environmentSelectorWindow == nil) {
        UIWindow *environmentSelectorWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        HYPEnvironmentSelectorViewController *selectorVC = [[HYPEnvironmentSelectorViewController alloc] init];
        selectorVC.canCancel = isCanCancel;
        UINavigationController *rootNavigatonController = [[UINavigationController alloc] initWithRootViewController:selectorVC];
        environmentSelectorWindow.rootViewController = rootNavigatonController;
        self.environmentSelectorWindow = environmentSelectorWindow;
    }
    [(UINavigationController *)self.environmentSelectorWindow.rootViewController popToRootViewControllerAnimated:NO];
    self.environmentSelectorWindow.alpha = 0;
    self.environmentSelectorWindow.hidden = NO;
    self.originKeyWindow = [UIApplication sharedApplication].keyWindow;
    [self.environmentSelectorWindow makeKeyWindow];
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
    self->_isShowingEnvironmentSelectorWindow = NO;
    self.environmentSelectorWindow.hidden = YES;
    self.environmentSelectorWindow = nil;
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
