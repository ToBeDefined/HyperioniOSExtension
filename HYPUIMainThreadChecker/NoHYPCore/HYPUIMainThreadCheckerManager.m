//
//  HYPUIMainThreadCheckerManager.m
//  HYPUIMainThreadChecker
//
//  Created by TBD on 2018/5/23.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPUIMainThreadCheckerManager.h"

@implementation HYPUIMainThreadCheckerManager

static HYPUIMainThreadCheckerManager *sharedHYPUIMainThreadCheckerManager = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYPUIMainThreadCheckerManager = [super allocWithZone:zone];
    });
    return sharedHYPUIMainThreadCheckerManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return sharedHYPUIMainThreadCheckerManager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return sharedHYPUIMainThreadCheckerManager;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYPUIMainThreadCheckerManager = [super init];
        [sharedHYPUIMainThreadCheckerManager open];
    });
    return sharedHYPUIMainThreadCheckerManager;
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYPUIMainThreadCheckerManager = [[[self class] alloc] init];
    });
    return sharedHYPUIMainThreadCheckerManager;
}

+ (instancetype)shared {
    return [self sharedManager];
}

- (void)open {
    [self willChangeValueForKey:NSStringFromSelector(@selector(isOpen))];
    self->_isOpen = YES;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isOpen))];
}

- (void)close {
    [self willChangeValueForKey:NSStringFromSelector(@selector(isOpen))];
    self->_isOpen = NO;
    [self didChangeValueForKey:NSStringFromSelector(@selector(isOpen))];
}


@end
