//
//  HYPEnvironmentItemManage.m
//  EnvironmentSelector
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPEnvironmentItemManage.h"
#import "HYPEnvironmentSelectorPlugin.h"
#import <objc/runtime.h>

@implementation HYPEnvironmentItemManage

+ (BOOL)isSwiftClass:(Class)cls {
    if ([NSStringFromClass(cls) rangeOfString:@"."].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)dictionaryWithItem:(id)item {
    if ([item isKindOfClass:[NSDictionary class]]) {
        return item;
    } else {
        NSArray<NSString *> *keys = [self keysForItem:item];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *key in keys) {
            id value = [self getObjectForKey:key inItem:item];
            [dict setObject:value forKey:key];
        }
        return dict;
    }
}

+ (id)itemWithDictionary:(NSDictionary *)dict {
    Class cls = [HYPEnvironmentSelectorPlugin getEnvironmentItemClass];
    if ([cls isMemberOfClass:[NSNull class]]) {
        return nil;
    }
    if ([cls isMemberOfClass:[NSDictionary class]]) {
        return dict;
    } else {
        NSArray<NSString *> *keys = [self keysForItemClass:cls];
        if (![cls instancesRespondToSelector:@selector(init)]) {
            NSAssert(NO, @"item's class must have `init` function");
            return nil;
        }
        if ([self isSwiftClass:cls]) {
            NSLog(@"\n\n!!!if is swift class, must inherit from `NSObject`, and add `init()` function, and add `@objcMembers` in class define position!!!\n\n");
        }
        id newItem = [[cls alloc] init];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([keys containsObject:key]) {
                NSAssert(obj == nil || [obj isKindOfClass:[NSString class]], @"all property must use NSString type");
                [newItem setValue:obj forKey:key];
            }
        }];
        return newItem;
    }
}

+ (id)mutableCopyItem:(id)item {
    if ([item isKindOfClass:[NSDictionary class]]) {
        return [item mutableCopy];
    } else {
        Class cls = [item class];
        if (![cls instancesRespondToSelector:@selector(init)]) {
            NSAssert(NO, @"item's class must have `init` function");
            return nil;
        }
        if ([self isSwiftClass:cls]) {
            NSLog(@"\n\n!!!if is swift class, must inherit from `NSObject`, and add `init()` function, and add `@objcMembers` in class define position!!!\n\n");
        }
        id newItem = [[cls alloc] init];
        NSArray<NSString *> *keys = [self keysForItem:item];
        for (NSString *key in keys) {
            id value = [self getObjectForKey:key inItem:item];
            NSAssert(value == nil || [value isKindOfClass:[NSString class]], @"all property must use NSString type");
            [newItem setValue:value forKey:key];
        }
        return newItem;
    }
}

+ (NSArray<NSString *> *)keysForItem:(id)item {
    NSArray<NSString *> *keys;
    if ([item isKindOfClass:[NSDictionary class]]) {
        keys = (NSArray<NSString *> *)[(NSDictionary *)item allKeys];
    } else {
        keys = [self keysForItemClass:[item class]];
    }
    
    return [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSCaseInsensitiveSearch];
    }];
}

+ (NSArray<NSString *> *)keysForItemClass:(Class)cls {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    NSMutableArray<NSString *> *propertyArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [propertyArray addObject:name];
    }
    return propertyArray;
}

+ (id)getObjectForKey:(NSString *)key inItem:(id)item {
    if ([item isKindOfClass:[NSDictionary class]]) {
        id value = [(NSDictionary *)item objectForKey:key];
        return value;
    } else {
        NSArray<NSString *>* keys = [HYPEnvironmentItemManage keysForItem:item];
        if ([keys containsObject:key]) {
            id value = [item valueForKey:key];
            NSAssert(value == nil || [value isKindOfClass:[NSString class]], @"all property must use NSString type");
            return value;
        }
    }
    return nil;
}

+ (id)updateObject:(id)newObj forKey:(NSString *)key inItem:(id)item {
    if ([item isKindOfClass:[NSMutableDictionary class]]) {
        id oldValue = [item objectForKey:key];
        [(NSMutableDictionary *)item setObject:newObj forKey:key];
        return oldValue;
    } else {
        NSArray<NSString *>* keys = [HYPEnvironmentItemManage keysForItem:item];
        if ([keys containsObject:key]) {
            id oldValue = [item valueForKey:key];
            [item setValue:newObj forKey:key];
            return oldValue;
        }
        NSAssert(NO, @"JUST Support Property, propertys dosn't contains this key");
    }
    return nil;
}

+ (NSString *)descriptionForItem:(id)item {
    NSArray<NSString *> *keys = [self keysForItem:item];
    if ([item isKindOfClass:[NSDictionary class]]) {
        NSMutableString *description = [NSMutableString stringWithString:@""];
        for (NSString *key in keys) {
            id obj = [(NSDictionary *)item objectForKey:key];
            [description appendFormat:@"\n%@ => %@", key, obj];
        }
        return description;
    } else {
        NSMutableString *description = [NSMutableString stringWithString:@""];
        for (NSString *property in keys) {
            id value = [item valueForKey:property];
            NSAssert(value == nil || [value isKindOfClass:[NSString class]], @"all property must use NSString type");
            [description appendFormat:@"\n%@ => %@", property, value];
        }
        return description;
    }
}

@end
