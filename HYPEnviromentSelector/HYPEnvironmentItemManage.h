//
//  HYPEnvironmentItemManage.h
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYPEnvironmentItemManage : NSObject

+ (NSDictionary *)dictionaryWithItem:(id)item;

+ (id)itemWithDictionary:(NSDictionary *)dict;

+ (id)mutableCopyItem:(id)item;

+ (NSArray<NSString *> *)keysForItem:(id)item;

+ (id)getObjectForKey:(NSString *)key inItem:(id)item;

+ (id)updateObject:(id)newObj forKey:(NSString *)key inItem:(id)item;

+ (NSString *)descriptionForItem:(id)item;

@end
