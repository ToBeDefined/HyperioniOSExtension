//
//  HYPFPSMonitorManager.h
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYPFPSMonitorManager : NSObject

@property (class, nonatomic, readonly) HYPFPSMonitorManager *shared;

@property (nonatomic, assign) BOOL isCanTouchFPSView;
@property (nonatomic, assign, readonly) BOOL isShowingFPSMonitorView;

+ (instancetype)sharedManager;

- (void)showFPSMonitor;
- (void)hideFPSMonitor;

@end

NS_ASSUME_NONNULL_END
