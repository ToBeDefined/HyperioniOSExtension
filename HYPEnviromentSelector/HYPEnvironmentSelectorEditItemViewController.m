//
//  HYPEnvironmentSelectorEditItemViewController.m
//  HYPEnviromentSelector
//
//  Created by TBD on 2018/4/13.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import "HYPEnvironmentSelectorEditItemViewController.h"
#import "HYPEnvironmentInfoEditCell.h"
#import "HYPEnvironmentItemManage.h"
#import "HYPEnvironmentSelectorPlugin.h"

static NSString *HYPEnvironmentInfoEditCellID           = @"HYPEnvironmentInfoEditCell";
static NSString *TextFieldAssociatedKey                 = @"TextFieldAssociatedKey";
static NSString *HYPEnvironmentSelectorEditItemSaveKey  = @"HYPEnvironmentSelectorEditItemSaveKey";

@interface HYPEnvironmentSelectorEditItemViewController()

@property (nonatomic, strong) id item;
@property (nonatomic, strong) NSArray<NSString *> *keys;

@end

@implementation HYPEnvironmentSelectorEditItemViewController

- (instancetype)initWithItem:(id)item {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (item) {
            _item = [HYPEnvironmentItemManage mutableCopyItem:item];
        } else {
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:HYPEnvironmentSelectorEditItemSaveKey];
            _item = [HYPEnvironmentItemManage itemWithDictionary:dict];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Environment Edit";
    self.keys = [HYPEnvironmentItemManage keysForItem:self.item];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HYPEnvironmentInfoEditCell class]
           forCellReuseIdentifier:HYPEnvironmentInfoEditCellID];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:tap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(confirmEdit)];
}

- (void)hideKeyboard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)confirmEdit {
    [self hideKeyboard];
    NSDictionary *itemDict = [HYPEnvironmentItemManage dictionaryWithItem:self.item];
    [[NSUserDefaults standardUserDefaults] setObject:itemDict
                                              forKey:HYPEnvironmentSelectorEditItemSaveKey];
    [HYPEnvironmentSelectorPlugin hideEnvironmentSelectorWindowAnimated:YES completionBlock:^{
        EnvironmentSelectedBlock block = [HYPEnvironmentSelectorPlugin.environmentSelectedBlock copy];
        if (block) {
            block(self.item);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYPEnvironmentInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:HYPEnvironmentInfoEditCellID
                                                                       forIndexPath:indexPath];
    NSString *propertyKey = self.keys[indexPath.row];
    id value = [HYPEnvironmentItemManage getObjectForKey:propertyKey inItem:self.item];
    cell.titleLabel.text = propertyKey;
    cell.valueTextField.text = value;
    __weak typeof(self)weakSelf = self;
    cell.textFieldEditBlock = ^(NSString *key, NSString *value) {
        [HYPEnvironmentItemManage updateObject:value forKey:key inItem:weakSelf.item];
    };
    return cell;
}


@end
