//
//  HYPEnvironmentSelector.h
//  HYPEnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<HyperioniOSExtension/HYPEnvironmentSelector.h>)
FOUNDATION_EXPORT double HYPEnvironmentSelectorVersionNumber;
FOUNDATION_EXPORT const unsigned char HYPEnvironmentSelectorVersionString[];
#import <HyperioniOSExtension/HYPEnvironmentSelectorPlugin.h>
#import <HyperioniOSExtension/HYPEnvironmentItemProtocol.h>
#import <HyperioniOSExtension/HYPEnvironmentSelectorPluginModule.h>
#import <HyperioniOSExtension/HYPEnvironmentItemManage.h>
#import <HyperioniOSExtension/HYPEnvironmentSelectorViewController.h>
#import <HyperioniOSExtension/HYPEnvironmentSelectorEditItemViewController.h>
#import <HyperioniOSExtension/HYPEnvironmentInfoEditCell.h>
#else
#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentItemProtocol.h"
#import "HYPEnvironmentSelectorPluginModule.h"
#import "HYPEnvironmentItemManage.h"
#import "HYPEnvironmentSelectorViewController.h"
#import "HYPEnvironmentSelectorEditItemViewController.h"
#import "HYPEnvironmentInfoEditCell.h"
#endif
