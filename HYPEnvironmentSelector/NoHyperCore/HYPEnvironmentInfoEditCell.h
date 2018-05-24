//
//  HYPEnvironmentSelectorEditCell.h
//  HYPEnvironmentSelector
//
//  Created by TBD on 2018/4/13.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYPEnvironmentInfoEditCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *valueTextField;
@property (nonatomic, copy) void(^textFieldEditBlock)(NSString *key, NSString *value);

@end

NS_ASSUME_NONNULL_END
