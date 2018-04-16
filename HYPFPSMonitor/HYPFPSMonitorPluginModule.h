//
//  HYPFPSMonitorPluginModule.h
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyperioniOS/HYPPluginModule.h>

@interface HYPFPSMonitorPluginModule : HYPPluginModule

// FPSView是否允许接收触摸事件
- (void)setIsCanTouchFPSView:(BOOL)isCanTouchFPSView;

- (void)showHYPFPSMonitor:(BOOL)isShow;

@end
