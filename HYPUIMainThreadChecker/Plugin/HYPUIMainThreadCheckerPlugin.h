//
//  HYPUIMainThreadCheckerPlugin.h
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyperioniOS/HYPPlugin.h>
#import "HYPUIMainThreadCheckerManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYPUIMainThreadCheckerPlugin : NSObject<HYPPlugin>

@property (class, nonatomic, strong, readonly) HYPUIMainThreadCheckerManager *manager;

@end

NS_ASSUME_NONNULL_END
