//
//  HYPFPSMonitorManager.h
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPFPSMonitorManager : NSObject

@property (class, nonatomic, readonly) HYPFPSMonitorManager *shared;

@property (nonatomic, assign) BOOL isCanTouchFPSView;
@property (nonatomic, assign, readonly) BOOL isShowingFPSMonitorView;

+ (instancetype)sharedManager;

- (void)showFPSMonitor;
- (void)hideFPSMonitor;
- (void)setFPSViewUserInterfaceEnable:(BOOL)enable;

@end
