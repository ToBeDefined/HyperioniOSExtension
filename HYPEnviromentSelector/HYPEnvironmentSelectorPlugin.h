//
//  HYPEnvironmentSelectorPlugin.h
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyperioniOS/HYPPlugin.h>
#import "HYPEnvironmentItem.h"

/**
 when select environment, call block, `obj` is `HYPEnvironmentItem` or subclass instance or NSDictionary

 @param obj `HYPEnvironmentItem` or subclass instance or NSDictionary
 */
typedef void (^ __nullable EnvironmentSelectedBlock)(id obj);

@interface HYPEnvironmentSelectorPlugin : NSObject<HYPPlugin>

@property (class, nonatomic, copy) NSArray<HYPEnvironmentItem *> *environmentItems;
@property (class, nonatomic, copy) EnvironmentSelectedBlock environmentSelectedBlock;
@end
