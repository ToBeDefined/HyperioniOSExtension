//
//  HYPEnvironmentSelector.h
//  HYPEnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<HYPEnvironmentSelector/HYPEnvironmentSelector.h>)
FOUNDATION_EXPORT double HYPEnvironmentSelectorVersionNumber;
FOUNDATION_EXPORT const unsigned char HYPEnvironmentSelectorVersionString[];
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorPlugin.h>
#import <HYPEnvironmentSelector/HYPEnvironmentItemProtocol.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorPluginModule.h>
#import <HYPEnvironmentSelector/HYPEnvironmentItemManage.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorViewController.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorEditItemViewController.h>
#import <HYPEnvironmentSelector/HYPEnvironmentInfoCell.h>
#import <HYPEnvironmentSelector/HYPEnvironmentInfoEditCell.h>
#else
#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentItemProtocol.h"
#import "HYPEnvironmentSelectorPluginModule.h"
#import "HYPEnvironmentItemManage.h"
#import "HYPEnvironmentSelectorViewController.h"
#import "HYPEnvironmentSelectorEditItemViewController.h"
#import "HYPEnvironmentInfoCell.h"
#import "HYPEnvironmentInfoEditCell.h"
#endif
