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
//    [self showAlertVC];
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
    [self.originKeyWindow makeKeyAndVisible];
    self.originKeyWindow = nil;
    if (completion) {
        completion();
    }
}

//- (void)showAlertVC {
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"环境选择"
//                                                                             message:@"\n\n\n\n"
//                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
//    UILabel *alertControllerMessageLabel = [self findeMessageLabelInAlertController:alertController];
//    UIView *insertView = [self getInsertView];
//    insertView.backgroundColor = [UIColor clearColor];
//    insertView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 35);
//    [alertControllerMessageLabel addSubview:insertView];
//    insertView.translatesAutoresizingMaskIntoConstraints = NO;
//    UIView *superView = insertView.superview;
//    while (superView) {
//        superView.userInteractionEnabled = YES;
//        superView = superView.superview;
//    }
//    [insertView addConstraint:[NSLayoutConstraint constraintWithItem:insertView
//                                                           attribute:NSLayoutAttributeHeight
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:nil
//                                                           attribute:NSLayoutAttributeNotAnAttribute
//                                                          multiplier:1.0
//                                                            constant:35]];
//    [alertControllerMessageLabel addConstraint:[NSLayoutConstraint constraintWithItem:insertView
//                                                                            attribute:NSLayoutAttributeTop
//                                                                            relatedBy:NSLayoutRelationEqual
//                                                                               toItem:insertView.superview
//                                                                            attribute:NSLayoutAttributeTop
//                                                                           multiplier:1.0
//                                                                             constant:10]];
//    [alertControllerMessageLabel addConstraint:[NSLayoutConstraint constraintWithItem:insertView
//                                                                            attribute:NSLayoutAttributeBottom
//                                                                            relatedBy:NSLayoutRelationEqual
//                                                                               toItem:insertView.superview
//                                                                            attribute:NSLayoutAttributeBottom
//                                                                           multiplier:1.0
//                                                                             constant:-10]];
//    [alertControllerMessageLabel addConstraint:[NSLayoutConstraint constraintWithItem:insertView
//                                                                            attribute:NSLayoutAttributeLeft
//                                                                            relatedBy:NSLayoutRelationEqual
//                                                                               toItem:insertView.superview
//                                                                            attribute:NSLayoutAttributeLeft
//                                                                           multiplier:1.0
//                                                                             constant:0]];
//    [alertControllerMessageLabel addConstraint:[NSLayoutConstraint constraintWithItem:insertView
//                                                                            attribute:NSLayoutAttributeRight
//                                                                            relatedBy:NSLayoutRelationEqual
//                                                                               toItem:insertView.superview
//                                                                            attribute:NSLayoutAttributeRight
//                                                                           multiplier:1.0
//                                                                             constant:0]];
//
//    NSArray *items = [self getEnvironmentItems];
//    for (NSObject *item in items) {
//        NSString *title;
//        if ([item isKindOfClass:[HYPEnvironmentItemManage class]]) {
//            title = ((HYPEnvironmentItemManage *)item).name;
//        } else if ([item isKindOfClass:[NSDictionary class]]) {
//            title = [(NSDictionary *)item objectForKey:@"name"];
//        }
//
//        if (title == nil) {
//            title = @"Don't Have Name";
//        }
//
//        UIAlertAction *action = [UIAlertAction actionWithTitle:title
//                                                         style:UIAlertActionStyleDefault
//                                                       handler:^(UIAlertAction * _Nonnull action) {
//                                                           [self hideEnvironmentSelectorWindow];
//                                                           [self callBlockWithObject:item];
//                                                       }];
//        [alertController addAction:action];
//    }
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction * _Nonnull action) {
//                                                             [self hideEnvironmentSelectorWindow];
//                                                         }];
//    [alertController addAction:cancelAction];
//
//    [self.environmentSelectorWindow.rootViewController presentViewController:alertController
//                                                                    animated:YES
//                                                                  completion:nil];
//}
//
//- (UIView *)getInsertView {
//    UIView *insertView = [[UIView alloc] init];
//    insertView.translatesAutoresizingMaskIntoConstraints = NO;
//    UILabel *label = [[UILabel alloc] init];
//    label.numberOfLines = 0;
//    label.textAlignment = NSTextAlignmentLeft;
//    label.text = @"如果需要在选择环境为基础进行编辑\n需要开启按钮才可以点选后编辑";
//    label.textColor = [UIColor grayColor];
//    label.font = [UIFont systemFontOfSize:12];
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    [insertView addSubview:label];
//    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 49, 31)];
//    switchView.tintColor = [UIColor grayColor];
//    switchView.onTintColor = [UIColor grayColor];
//    switchView.thumbTintColor = [UIColor darkGrayColor];
//    switchView.translatesAutoresizingMaskIntoConstraints = NO;
//    [insertView addSubview:switchView];
//
//    // label Layout
//    [insertView addConstraint:[NSLayoutConstraint constraintWithItem:label
//                                                      attribute:NSLayoutAttributeTop
//                                                      relatedBy:NSLayoutRelationEqual
//                                                         toItem:insertView
//                                                      attribute:NSLayoutAttributeTop
//                                                     multiplier:1.0
//                                                       constant:0]];
//    [insertView addConstraint:[NSLayoutConstraint constraintWithItem:label
//                                                      attribute:NSLayoutAttributeBottom
//                                                      relatedBy:NSLayoutRelationEqual
//                                                         toItem:insertView
//                                                      attribute:NSLayoutAttributeBottom
//                                                     multiplier:1.0
//                                                       constant:0]];
//    [insertView addConstraint:[NSLayoutConstraint constraintWithItem:label
//                                                      attribute:NSLayoutAttributeCenterX
//                                                      relatedBy:NSLayoutRelationEqual
//                                                         toItem:insertView
//                                                      attribute:NSLayoutAttributeCenterX
//                                                     multiplier:1.0
//                                                       constant:-40]];
//    // 宽度不设置，自动适应宽度
//    [label addConstraint:[NSLayoutConstraint constraintWithItem:label
//                                                      attribute:NSLayoutAttributeWidth
//                                                      relatedBy:NSLayoutRelationLessThanOrEqual
//                                                         toItem:nil
//                                                      attribute:NSLayoutAttributeNotAnAttribute
//                                                     multiplier:1.0
//                                                       constant:200]];
//    // switchView Layout
//    [insertView addConstraint:[NSLayoutConstraint constraintWithItem:switchView
//                                                           attribute:NSLayoutAttributeLeft
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:label
//                                                           attribute:NSLayoutAttributeRight
//                                                          multiplier:1.0
//                                                            constant:10]];
//    [insertView addConstraint:[NSLayoutConstraint constraintWithItem:switchView
//                                                           attribute:NSLayoutAttributeCenterY
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:insertView
//                                                           attribute:NSLayoutAttributeCenterY
//                                                          multiplier:1.0
//                                                            constant:0]];
//    [switchView addConstraint:[NSLayoutConstraint constraintWithItem:switchView
//                                                           attribute:NSLayoutAttributeWidth
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:nil
//                                                           attribute:NSLayoutAttributeNotAnAttribute
//                                                          multiplier:1.0
//                                                            constant:49]];
//    [switchView addConstraint:[NSLayoutConstraint constraintWithItem:switchView
//                                                           attribute:NSLayoutAttributeHeight
//                                                           relatedBy:NSLayoutRelationEqual
//                                                              toItem:nil
//                                                           attribute:NSLayoutAttributeNotAnAttribute
//                                                          multiplier:1.0
//                                                            constant:31]];
//    return insertView;
//}
//
//- (UILabel *)findLabelInView:(UIView *)view labelText:(NSString *)text {
//    for (UIView *subView in view.subviews) {
//        if ([subView isKindOfClass:[UILabel class]]) {
//            UILabel *label = (UILabel *)subView;
//            if ([label.text isEqualToString:text]) {
//                return label;
//            }
//        }
//        UILabel *label = [self findLabelInView:subView labelText:text];
//        if (label) {
//            return label;
//        }
//    }
//    return nil;
//}
//
//- (UILabel *)findeMessageLabelInAlertController:(UIAlertController *)alertController {
//    return [self findLabelInView:alertController.view labelText:alertController.message];
//}


@end
