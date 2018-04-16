//
//  HYPFPSMonitorManager.h
//  HYPFPSMonitor
//
//  Created by TBD on 2018/4/16.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPFPSMonitorManager : NSObject

@property (nonatomic, class, strong, readonly) UIView *fpsView;

+ (void)showFPSMonitor:(BOOL)shouldShow;

@end
