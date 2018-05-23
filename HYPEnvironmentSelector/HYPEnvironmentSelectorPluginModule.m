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
#import <HyperioniOS/HYPPluginExtensionImp.h>
#import "HYPEnvironmentSelectorPluginModule.h"
#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentSelectorManager.h"

@interface HYPEnvironmentSelectorPluginModule() <HYPPluginMenuItemDelegate>

@property (nonatomic, strong) HYPPluginMenuItem *menu;
@property (nonatomic, assign, readonly) BOOL isShowingEnvironmentSelectorWindow;

@end

@implementation HYPEnvironmentSelectorPluginModule

+ (instancetype)sharedInstance {
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HYPPluginExtension *pluginExtension = [[HYPPluginExtension alloc] initWithSnapshotContainer:nil
                                                                                   overlayContainer:nil
                                                                                         hypeWindow:nil
                                                                                     attachedWindow:nil];
        __instance = [[[self class] alloc] initWithExtension:pluginExtension];
    });
    return __instance;
}

- (BOOL)isShowingEnvironmentSelectorWindow {
    return [HYPEnvironmentSelectorManager sharedManager].isShowingEnvironmentSelectorWindow;
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
    [menu setSelected:self.isShowingEnvironmentSelectorWindow animated:NO];
    self.menu = menu;
    return menu;
}

- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    [[HyperionManager sharedInstance] togglePluginDrawer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isShowingEnvironmentSelectorWindow) {
            [self hideEnvironmentSelectorWindowAnimated:YES
                                        completionBlock:nil];
        } else {
            [self showEnvironmentSelectorWindowAnimated:YES
                                            isCanCancel:YES
                                        completionBlock:nil];
        }
    });
}

- (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated
                                  isCanCancel:(BOOL)isCanCancel
                              completionBlock:(void (^)(void))completion {
    [self.menu setSelected:YES animated:YES];
    [[HYPEnvironmentSelectorManager sharedManager] showEnvironmentSelectorWindowAnimated:animated
                                                                             isCanCancel:isCanCancel
                                                                         completionBlock:completion];
}

- (void)hideEnvironmentSelectorWindowAnimated:(BOOL)animated
                              completionBlock:(void (^)(void))completion {
    [[HYPEnvironmentSelectorManager sharedManager] hideEnvironmentSelectorWindowAnimated:animated
                                                                         completionBlock:^{
                                                                             [self.menu setSelected:NO animated:YES];
                                                                         }];
    
}

@end
