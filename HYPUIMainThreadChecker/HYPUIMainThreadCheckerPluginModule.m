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
#import "HYPUIMainThreadCheckerManager.h"

@interface HYPUIMainThreadCheckerPluginModule() <HYPPluginMenuItemDelegate>
@property (nonatomic, strong) HYPPluginMenuItem *menu;
@end

@implementation HYPUIMainThreadCheckerPluginModule

- (void)dealloc {
    // Never Run
    [[HYPUIMainThreadCheckerManager sharedManager] removeObserver:self
                                                       forKeyPath:NSStringFromSelector(@selector(isOpen))];
}

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
    [menu setSelected:[HYPUIMainThreadCheckerManager sharedManager].isOpen animated:NO];
    self.menu = menu;
    [[HYPUIMainThreadCheckerManager sharedManager] addObserver:self
                                                    forKeyPath:NSStringFromSelector(@selector(isOpen))
                                                       options:NSKeyValueObservingOptionNew
                                                       context:nil];
    return menu;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(isOpen))]
        && object == [HYPUIMainThreadCheckerManager sharedManager]) {
        BOOL isOpen = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        [self.menu setSelected:isOpen animated:NO];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - HYPPluginMenuItemDelegate
- (void)pluginMenuItemSelected:(UIView<HYPPluginMenuItem> *)pluginView {
    if ([HYPUIMainThreadCheckerManager sharedManager].isOpen) {
        [[HYPUIMainThreadCheckerManager sharedManager] close];
    } else {
        [[HYPUIMainThreadCheckerManager sharedManager] open];
    }
}

@end
