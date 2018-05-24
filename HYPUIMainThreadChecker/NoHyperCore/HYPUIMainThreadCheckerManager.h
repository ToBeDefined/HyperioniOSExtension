//
//  HYPUIMainThreadCheckerManager.h
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/5/23.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYPUIMainThreadCheckerManager : NSObject

@property (class, nonatomic, readonly) HYPUIMainThreadCheckerManager *shared;

@property (nonatomic, assign, readonly) BOOL isOpen;

+ (instancetype)sharedManager;

- (void)open;
- (void)close;

@end

NS_ASSUME_NONNULL_END
