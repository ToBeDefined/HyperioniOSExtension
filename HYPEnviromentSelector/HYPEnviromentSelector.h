//
//  HYPEnviromentSelector.h
//  HYPEnviromentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<HYPEnvironmentSelector/HYPEnviromentSelector.h>)
FOUNDATION_EXPORT double HYPEnviromentSelectorVersionNumber;
FOUNDATION_EXPORT const unsigned char HYPEnviromentSelectorVersionString[];
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorPlugin.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorPluginModule.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorPluginMenuItem.h>
#import <HYPEnvironmentSelector/HYPEnvironmentItemManage.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorViewController.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorEditItemViewController.h>
#import <HYPEnvironmentSelector/HYPEnvironmentInfoCell.h>
#import <HYPEnvironmentSelector/HYPEnvironmentInfoEditCell.h>
#else
#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentSelectorPluginModule.h"
#import "HYPEnvironmentSelectorPluginMenuItem.h"
#import "HYPEnvironmentItemManage.h"
#import "HYPEnvironmentSelectorViewController.h"
#import "HYPEnvironmentSelectorEditItemViewController.h"
#import "HYPEnvironmentInfoCell.h"
#import "HYPEnvironmentInfoEditCell.h"
#endif
