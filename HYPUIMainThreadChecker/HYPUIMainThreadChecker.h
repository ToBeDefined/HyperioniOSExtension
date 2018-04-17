//
//  HYPUIMainThreadChecker.h
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __has_include(<HYPUIMainThreadChecker/HYPUIMainThreadChecker.h>)
FOUNDATION_EXPORT double HYPUIMainThreadCheckerVersionNumber;
FOUNDATION_EXPORT const unsigned char HYPUIMainThreadCheckerVersionString[];
#import <HYPUIMainThreadChecker/HYPUIMainThreadCheckerPlugin.h>
#import <HYPUIMainThreadChecker/HYPUIMainThreadCheckerPluginModule.h>
#import <HYPUIMainThreadChecker/UIView+HYPUIMainThreadChecker.h>
#else
#import "HYPUIMainThreadCheckerPlugin.h"
#import "HYPUIMainThreadCheckerPluginModule.h"
#import "UIView+HYPUIMainThreadChecker.h"
#endif


