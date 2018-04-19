//
//  MyEnvItem.m
//  HyperioniOSExtensionDemo
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "MyEnvItem.h"

@implementation MyEnvItem

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

@end
