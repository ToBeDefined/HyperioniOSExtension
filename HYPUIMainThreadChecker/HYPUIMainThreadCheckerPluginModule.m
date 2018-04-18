//
//  HYPUIMainThreadCheckerPluginModule.m
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import <HyperioniOS/HYPPluginMenuItem.h>
#import <HyperioniOS/HYPPluginExtensionImp.h>
#import "HYPUIMainThreadCheckerPluginModule.h"

@interface HYPUIMainThreadCheckerPluginModule() <HYPPluginMenuItemDelegate>
@property (nonatomic, strong) HYPPluginMenuItem *menu;
@end

@implementation HYPUIMainThreadCheckerPluginModule

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

#pragma mark - isShouldCheckMainThread
- (void)setIsShouldCheckMainThread:(BOOL)isShouldCheckMainThread {
    _isShouldCheckMainThread = isShouldCheckMainThread;
    [self.menu setSelected:self.isShouldCheckMainThread animated:YES];
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
    [menu setSelected:self.isShouldCheckMainThread animated:YES];
    self.menu = menu;
    return menu;
}

#pragma mark - HYPPluginMenuItemDelegate
- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    self.isShouldCheckMainThread = !self.isShouldCheckMainThread;
}

@end
