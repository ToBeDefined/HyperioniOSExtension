//
//  MyEnvItem.h
//  Example
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HYPEnviromentSelector/HYPEnviromentSelector.h>
@interface MyEnvItem: NSObject <HYPEnviromentItemProtocol>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *otherVariable;

- (instancetype)initWithName:(NSString *)name;

@end
