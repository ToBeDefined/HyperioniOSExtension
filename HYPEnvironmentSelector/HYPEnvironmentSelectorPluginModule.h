//
//  HYPEnvironmentSelectorPluginModule.h
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <HyperioniOS/HYPPluginModule.h>

@interface HYPEnvironmentSelectorPluginModule : HYPPluginModule

+ (instancetype _Nonnull)sharedInstance;

- (void)showEnvironmentSelectorWindowAnimated:(BOOL)animated
                              completionBlock:(void (^_Nullable)(void))completion;
- (void)hideEnvironmentSelectorWindowAnimated:(BOOL)animated
                              completionBlock:(void (^_Nullable)(void))completion;

@end
