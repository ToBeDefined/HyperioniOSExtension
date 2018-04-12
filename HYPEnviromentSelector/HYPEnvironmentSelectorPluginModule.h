//
//  HYPEnvironmentSelectorPluginModule.h
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <HyperioniOS/HYPPluginModule.h>
#import "HYPEnvironmentItem.h"

@interface HYPEnvironmentSelectorPluginModule : HYPPluginModule

- (nonnull instancetype)initWithExtension:(nonnull id<HYPPluginExtension>)extension
                         environmentItems:(NSArray<HYPEnvironmentItem *> *)items;

@end
