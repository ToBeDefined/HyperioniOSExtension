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

NS_ASSUME_NONNULL_BEGIN

@interface HYPFPSMonitorPlugin : NSObject<HYPPlugin>

@property (class, nonatomic, strong, readonly) HYPFPSMonitorManager *manager;

@end

NS_ASSUME_NONNULL_END
