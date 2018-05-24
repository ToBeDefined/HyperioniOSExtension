//
//  HYPEnvironmentSelectorEditCell.m
//  HYPEnvironmentSelector
//
//  Created by TBD on 2018/4/13.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import "HYPEnvironmentInfoEditCell.h"

@interface HYPEnvironmentInfoEditCell() <UITextViewDelegate>

@end

@implementation HYPEnvironmentInfoEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:10]];
    [self.titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:25]];
    
    self.valueTextView = [[UITextView alloc] init];
    self.valueTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.valueTextView.font = [UIFont systemFontOfSize:15];
    self.valueTextView.textContainerInset = UIEdgeInsetsMake(3, 5, 3, 5);
    self.valueTextView.textColor = [UIColor grayColor];
    self.valueTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.valueTextView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    self.valueTextView.layer.cornerRadius = 5;
    self.valueTextView.layer.masksToBounds = YES;
    self.valueTextView.delegate = self;
    self.valueTextView.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.valueTextView];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.valueTextView
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.valueTextView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:-10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.valueTextView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.valueTextView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1.0
                                                                  constant:-10]];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textViewEditBlock) {
        self.textViewEditBlock(self.titleLabel.text, textView.text);
    }
}

@end
