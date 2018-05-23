//
//  HYPEnvironmentItemManage.h
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYPEnvironmentItemManage : NSObject

// 将item转成NSDictionary
+ (NSDictionary *)dictionaryWithItem:(id)item;

// 根据dict创建item，dict如果为nil，创建一个属性都为空的item
+ (nullable id)itemWithDictionary:(nullable NSDictionary *)dict;

// 新建一个item，值与原来item相同，如果原来的item是字典，转成NSMutableDictionary
+ (nullable id)mutableCopyItem:(nullable id)item;

// 取item的所有key(字典)或者property(对象)
+ (NSArray<NSString *> *)keysForItem:(id)item;

// 取item的对应key存储的值
+ (nullable id)getObjectForKey:(NSString *)key inItem:(id)item;

// 更新item的对应key存储的值，返回旧值
+ (nullable id)updateObject:(id)newObj forKey:(NSString *)key inItem:(id)item;

// item的所有属性和值组成NSString
+ (NSString *)descriptionForItem:(id)item escapeName:(BOOL)escapeName;

@end

NS_ASSUME_NONNULL_END
