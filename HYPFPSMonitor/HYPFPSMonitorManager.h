//
//  HYPFPSMonitorManager.h
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPFPSMonitorManager : NSObject

+ (void)showFPSMonitor:(BOOL)shouldShow;

+ (void)setFPSViewUserInterfaceEnable:(BOOL)enable;

@end
