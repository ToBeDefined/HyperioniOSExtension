//
//  HYPUIMainThreadCheckerPluginModule.m
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import <HyperioniOS/HYPPluginMenuItem.h>
#import <HyperioniOS/HyperionManager.h>
#import "HYPUIMainThreadCheckerPluginModule.h"

@interface HYPUIMainThreadCheckerPluginModule() <HYPPluginMenuItemDelegate>
@property (nonatomic, strong) HYPPluginMenuItem *menu;
@end

@implementation HYPUIMainThreadCheckerPluginModule

+ (void)load {
    objc_setAssociatedObject(self,
                             @selector(isShouldCheckMainThread),
                             @(YES),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - isShouldCheckMainThread
+ (void)setIsShouldCheckMainThread:(BOOL)isShouldCheckMainThread {
    objc_setAssociatedObject(self,
                             @selector(isShouldCheckMainThread),
                             @(isShouldCheckMainThread),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (BOOL)isShouldCheckMainThread {
    return [(NSNumber *)objc_getAssociatedObject(self, _cmd) boolValue];
}

#pragma mark - pluginMenuItem
- (UIView *)pluginMenuItem {
    if (self.menu) {
        return self.menu;
    }
    HYPPluginMenuItem *menu = [[HYPPluginMenuItem alloc] init];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"mainThreadCheck"
                                                                           ofType:@"png"];
    menu.delegate = self;
    [menu bindWithTitle:@"UI Main Thread Check"
                  image:[UIImage imageWithContentsOfFile:imagePath]];
    [menu setSelected:self.class.isShouldCheckMainThread animated:YES];
    self.menu = menu;
    return menu;
}

#pragma mark - HYPPluginMenuItemDelegate
- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    self.class.isShouldCheckMainThread = !self.class.isShouldCheckMainThread;
    [[HyperionManager sharedInstance] togglePluginDrawer];
    [self.menu setSelected:self.class.isShouldCheckMainThread animated:YES];
}

@end
