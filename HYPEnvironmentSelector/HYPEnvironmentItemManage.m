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

static NSString *swiftErrorLog = @"\n\n !!!if item is swift class!!! \n\n 1. must inherit from `NSObject`, \n 2. add `@objcMembers` in class define position, \n 3. add `init()` function. \n\n";
+ (void)checkIsSwiftClass:(Class)cls {
    if ([NSStringFromClass(cls) rangeOfString:@"."].location != NSNotFound) {
        NSAssert([cls isSubclassOfClass:[NSObject class]], swiftErrorLog);
    }
}

+ (void)checkValueIsNSString:(id)value {
    NSAssert(value == nil || [value isKindOfClass:[NSString class]],
             @"all property must use NSString type");
}

+ (NSDictionary *)dictionaryWithItem:(id)item {
    [self checkIsSwiftClass:[item class]];
    NSArray<NSString *> *keys = [self keysForItem:item];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        id value = [self getObjectForKey:key inItem:item];
        if (value) {
            [self checkValueIsNSString:value];
            [dict setObject:value forKey:key];
        }
    }
    return dict;
}

+ (id)itemWithDictionary:(NSDictionary *)dict {
    Class cls = [HYPEnvironmentSelectorPlugin getEnvironmentItemClass];
    if ([cls isMemberOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSArray<NSString *> *keys = [self keysForItemClass:cls];
    [self checkIsSwiftClass:cls];
    if (![cls instancesRespondToSelector:@selector(init)]) {
        NSAssert(NO, @"item's class must have `init` function");
        return nil;
    }
    id newItem = [[cls alloc] init];
    
    for (NSString *key in keys) {
        id obj = [dict objectForKey:key];
        if (obj == [NSNull null]) {
            obj = nil;
        }
        [self checkValueIsNSString:obj];
        [newItem setValue:obj forKey:key];
    }
    return newItem;
}

+ (id)mutableCopyItem:(id)item {
    if (item == nil) {
        return nil;
    }
    
    [self checkIsSwiftClass:[item class]];
    Class cls = [item class];
    if (![cls instancesRespondToSelector:@selector(init)]) {
        NSAssert(NO, @"item's class must have `init()` function");
        return nil;
    }
    id newItem = [[cls alloc] init];
    NSArray<NSString *> *keys = [self keysForItem:item];
    for (NSString *key in keys) {
        id value = [self getObjectForKey:key inItem:item];
        [self checkValueIsNSString:value];
        [newItem setValue:value forKey:key];
    }
    return newItem;
}

+ (NSArray<NSString *> *)keysForItem:(id)item {
    return [self keysForItemClass:[item class]];
}

+ (NSArray<NSString *> *)keysForItemClass:(Class)cls {
    [self checkIsSwiftClass:cls];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    NSMutableSet<NSString *> *propertySet = [NSMutableSet set];
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [propertySet addObject:propertyName];
    }
    
    // 去除NSObject本来的property
    objc_property_t *nsobject_properties = class_copyPropertyList([NSObject class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = nsobject_properties[i];
        const char *cName = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [propertySet removeObject:propertyName];
    }
    NSArray *sortDesc = @[[NSSortDescriptor sortDescriptorWithKey:@"lowercaseString" ascending:YES]];
    return [propertySet sortedArrayUsingDescriptors:sortDesc];
}

+ (id)getObjectForKey:(NSString *)key inItem:(id)item {
    [self checkIsSwiftClass:[item class]];
    NSArray<NSString *>* keys = [HYPEnvironmentItemManage keysForItem:item];
    if ([keys containsObject:key]) {
        id value = [item valueForKey:key];
        [self checkValueIsNSString:value];
        return value;
    }
    if ([key isEqualToString:@"name"]) {
        NSLog(@"\n%@, %@", @"you should set name", swiftErrorLog);
    } else {
        NSAssert(NO, swiftErrorLog);
    }
    return nil;
}

+ (id)updateObject:(id)newObj forKey:(NSString *)key inItem:(id)item {
    [self checkIsSwiftClass:[item class]];
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
    }
    return nil;
}

+ (NSString *)descriptionForItem:(id)item escapeName:(BOOL)escapeName {
    [self checkIsSwiftClass:[item class]];
    NSArray<NSString *> *keys = [self keysForItem:item];
    NSMutableString *description = [NSMutableString stringWithString:@""];
    for (NSString *property in keys) {
        if (escapeName && [property isEqualToString:@"name"]) {
            continue;
        }
        id value = [item valueForKey:property];
        [self checkValueIsNSString:value];
        [description appendFormat:@"\n%@:\n\t%@", property, value];
    }
    return description;
}

@end
