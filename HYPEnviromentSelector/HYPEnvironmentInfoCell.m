//
//  HYPEnvironmentInfoCell.m
//  HYPEnviromentSelector
//
//  Created by TBD on 2018/4/14.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPEnvironmentInfoCell.h"

@interface HYPEnvironmentInfoCell()

@end

@implementation HYPEnvironmentInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.numberOfLines = 0;
        self.accessoryType = UITableViewCellAccessoryDetailButton;
        [self insertUI];
    }
    return self;
}

- (void)insertUI {
    CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
    UIColor *lineColor = [UIColor lightGrayColor];
    self.topLine = [[UIView alloc] init];
    self.topLine.backgroundColor = lineColor;
    self.topLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.topLine];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topLine
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topLine
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.topLine
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0]];
    [self.topLine addConstraint:[NSLayoutConstraint constraintWithItem:self.topLine
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:lineHeight]];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = lineColor;
    self.bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.bottomLine];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomLine
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomLine
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomLine
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0]];
    [self.bottomLine addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomLine
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:lineHeight]];
}

@end
