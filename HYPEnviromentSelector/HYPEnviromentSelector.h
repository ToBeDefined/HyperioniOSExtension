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
#import <HYPEnvironmentSelector/HYPEnvironmentItem.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorPlugin.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorPluginMenuItem.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelectorPluginModule.h>
#else
#import "HYPEnvironmentItem.h"
#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentSelectorPluginMenuItem.h"
#import "HYPEnvironmentSelectorPluginModule.h"
#endif
