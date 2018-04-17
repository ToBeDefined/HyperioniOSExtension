//
//  HYPEnvironmentSelectorPluginModule.m
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import <HyperioniOS/HyperionManager.h>
#import <HyperioniOS/HYPPluginMenuItem.h>
#import "HYPEnvironmentSelectorPluginModule.h"
#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentSelectorViewController.h"

@interface HYPEnvironmentSelectorPluginModule() <HYPPluginMenuItemDelegate>

@property (nonatomic, class, assign) BOOL isShowingEnvironmentSelectorWindow;
@property (nonatomic, weak) UIWindow *environmentSelectorWindow;
@property (nonatomic, weak) UIWindow *originKeyWindow;
@property (nonatomic, strong) HYPPluginMenuItem *menu;

@end

@implementation HYPEnvironmentSelectorPluginModule

+ (void)setIsShowingEnvironmentSelectorWindow:(BOOL)isShowingEnvironmentSelectorWindow {
    objc_setAssociatedObject(self,
                             @selector(isShowingEnvironmentSelectorWindow),
                             @(isShowingEnvironmentSelectorWindow),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isShowingEnvironmentSelectorWindow {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}


- (UIView *)pluginMenuItem {
    if (!HYPEnvironmentSelectorPlugin.isShowInSidebarList) {
        return nil;
    }
    if (self.menu) {
        return self.menu;
    }
    
    HYPPluginMenuItem *menu = [[HYPPluginMenuItem alloc] init];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"env"
                                                                           ofType:@"png"];
    [menu bindWithTitle:@"Environment Selector"
                  image:[UIImage imageWithContentsOfFile:imagePath]];
    menu.delegate = self;
    [menu setSelected:self.class.isShowingEnvironmentSelectorWindow animated:NO];
    self.menu = menu;
    return menu;
}

- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    [[HyperionManager sharedInstance] togglePluginDrawer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.class.isShowingEnvironmentSelectorWindow) {
            [self hideEnvironmentSelectorWindowAnimated:YES completionBlock:nil];
        } else {
            [self showEnvironmentSelectorWindowAnimated:YES completionBlock:nil];
        }
    });
}

- (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated completionBlock:(void (^)(void))completion {
    if (self.class.isShowingEnvironmentSelectorWindow) {
        return;
    }
    self.class.isShowingEnvironmentSelectorWindow = YES;
    [self.menu setSelected:YES animated:YES];
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
    [self.menu setSelected:NO animated:YES];
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
