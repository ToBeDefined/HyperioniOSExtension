//
//  HYPFPSMonitor.h
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<HYPEnvironmentSelector/HYPEnviromentSelector.h>)
FOUNDATION_EXPORT double HYPFPSMonitorVersionNumber;
FOUNDATION_EXPORT const unsigned char HYPFPSMonitorVersionString[];
#import <HYPFPSMonitor/HYPFPSMonitorPlugin.h>
#import <HYPFPSMonitor/HYPFPSMonitorPluginModule.h>
#import <HYPFPSMonitor/HYPFPSMonitorManager.h>
#else
#import "HYPFPSMonitorPlugin.h"
#import "HYPFPSMonitorPluginModule.h"
#import "HYPFPSMonitorManager.h"
#endif

