//
//  MyEnvItem.h
//  Example
//
//  Created by TBD on 2018/4/17.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HYPEnvironmentSelector/HYPEnvironmentSelector.h>
@interface MyEnvItem: NSObject <HYPEnvironmentItemProtocol>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *commonPort;
@property (nonatomic, strong) NSString *H5BaseURL1;
@property (nonatomic, strong) NSString *H5BaseURL2;
@property (nonatomic, strong) NSString *H5BaseURL3;
@property (nonatomic, strong) NSString *H5BaseURL4;

- (instancetype)initWithName:(NSString *)name;

@end
