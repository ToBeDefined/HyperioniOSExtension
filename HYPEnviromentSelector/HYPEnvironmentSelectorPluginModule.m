//
//  HYPEnvironmentSelectorPluginModule.m
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <HyperioniOS/HYPPluginMenuItem.h>
#import "HYPEnvironmentSelectorPluginModule.h"
#import "HYPEnvironmentSelectorPluginMenuItem.h"
#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentSelectorViewController.h"

@interface HYPEnvironmentSelectorPluginModule() <HYPEnvironmentSelectorPluginMenuItemDelegate>

@property (nonatomic, class, assign) BOOL isShowingEnvironmentSelectorWindow;
@property (nonatomic, weak) UIWindow *environmentSelectorWindow;
@property (nonatomic, weak) UIWindow *originKeyWindow;

@end

@implementation HYPEnvironmentSelectorPluginModule

static BOOL __isShowingEnvironmentSelectorWindow = NO;
+ (void)setIsShowingEnvironmentSelectorWindow:(BOOL)isShowingEnvironmentSelectorWindow {
    __isShowingEnvironmentSelectorWindow = isShowingEnvironmentSelectorWindow;
}

+ (BOOL)isShowingEnvironmentSelectorWindow {
    return __isShowingEnvironmentSelectorWindow;
}


- (UIView *)pluginMenuItem {
    if (!HYPEnvironmentSelectorPlugin.isShowInSidebarList) {
        return nil;
    }
    HYPEnvironmentSelectorPluginMenuItem *menu = [[HYPEnvironmentSelectorPluginMenuItem alloc] init];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"env"
                                                                           ofType:@"png"];
    [menu bindWithTitle:@"Environment Selector"
                  image:[UIImage imageWithContentsOfFile:imagePath]];
    menu.actionDelegate = self;
    return menu;
}

- (void)environmentSelectorPluginMenuItemAction:(HYPEnvironmentSelectorPluginMenuItem *)menuItem {
    [self showEnvironmentSelectorWindowAnimated:YES completionBlock:nil];
}

- (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated completionBlock:(void (^)(void))completion {
    if ([self class].isShowingEnvironmentSelectorWindow) {
        return;
    }
    [self class].isShowingEnvironmentSelectorWindow = YES;
    if (self.environmentSelectorWindow == nil) {
        UIWindow *environmentSelectorWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        HYPEnvironmentSelectorViewController *selectorVC = [[HYPEnvironmentSelectorViewController alloc] init];
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

- (void)hideEnvironmentSelectorWindowAnimated:(BOOL)animated completionBlock:(void (^)(void))completion {
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
    self.class.isShowingEnvironmentSelectorWindow = NO;
    self.environmentSelectorWindow.hidden = YES;
    self.environmentSelectorWindow = nil;
    [self.originKeyWindow makeKeyWindow];
    self.originKeyWindow = nil;
    if (completion) {
        completion();
    }
}

@end
