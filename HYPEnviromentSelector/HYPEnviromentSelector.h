//
//  HYPEnviromentSelector.h
//  HYPEnviromentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<HYPEnviromentSelector/HYPEnviromentSelector.h>)
FOUNDATION_EXPORT double HYPEnviromentSelectorVersionNumber;
FOUNDATION_EXPORT const unsigned char HYPEnviromentSelectorVersionString[];
#import <HYPEnviromentSelector/HYPEnvironmentSelectorPlugin.h>
#import <HYPEnviromentSelector/HYPEnviromentItemProtocol.h>
#import <HYPEnviromentSelector/HYPEnvironmentSelectorPluginModule.h>
#import <HYPEnviromentSelector/HYPEnvironmentSelectorPluginMenuItem.h>
#import <HYPEnviromentSelector/HYPEnvironmentItemManage.h>
#import <HYPEnviromentSelector/HYPEnvironmentSelectorViewController.h>
#import <HYPEnviromentSelector/HYPEnvironmentSelectorEditItemViewController.h>
#import <HYPEnviromentSelector/HYPEnvironmentInfoCell.h>
#import <HYPEnviromentSelector/HYPEnvironmentInfoEditCell.h>
#else
#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnviromentItemProtocol.h"
#import "HYPEnvironmentSelectorPluginModule.h"
#import "HYPEnvironmentSelectorPluginMenuItem.h"
#import "HYPEnvironmentItemManage.h"
#import "HYPEnvironmentSelectorViewController.h"
#import "HYPEnvironmentSelectorEditItemViewController.h"
#import "HYPEnvironmentInfoCell.h"
#import "HYPEnvironmentInfoEditCell.h"
#endif
