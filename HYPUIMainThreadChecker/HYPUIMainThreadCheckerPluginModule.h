//
//  HYPUIMainThreadCheckerPluginModule.h
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyperioniOS/HYPPluginModule.h>

@interface HYPUIMainThreadCheckerPluginModule : HYPPluginModule

@property (nonatomic, assign) BOOL isShouldCheckMainThread;

+ (instancetype)sharedInstance;

@end
