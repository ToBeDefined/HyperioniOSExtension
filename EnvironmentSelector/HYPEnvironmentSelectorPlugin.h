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

@interface HYPEnvironmentSelectorPlugin : NSObject<HYPPlugin>

@property (class, nonatomic, copy) NSArray<HYPEnvironmentItem *> *environmentItems;

@end
