//
//  HYPFPSMonitorPlugin.h
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyperioniOS/HYPPlugin.h>
#import "HYPFPSMonitorManager.h"

@interface HYPFPSMonitorPlugin : NSObject<HYPPlugin>

// FPSView是否允许接收触摸事件
@property (class, nonatomic, strong, readonly) HYPFPSMonitorManager *manager;

@end
