//
//  HYPEnvironmentSelectorEditItemViewController.m
//  HYPEnvironmentSelector
//
//  Created by TBD on 2018/4/13.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>
#import "HYPEnvironmentSelectorEditItemViewController.h"
#import "HYPEnvironmentInfoEditCell.h"
#import "HYPEnvironmentItemManage.h"
#import "HYPEnvironmentSelectorManager.h"

static NSString *HYPEnvironmentInfoEditCellID           = @"HYPEnvironmentInfoEditCell";
static NSString *TextFieldAssociatedKey                 = @"TextFieldAssociatedKey";
static NSString *HYPEnvironmentSelectorEditItemSaveKey  = @"HYPEnvironmentSelectorEditItemSaveKey";

@interface HYPEnvironmentSelectorEditItemViewController()

@property (nonatomic, strong) id item;
@property (nonatomic, copy) NSArray<NSString *> *keys;

@end

@implementation HYPEnvironmentSelectorEditItemViewController

- (void)setItemUseItem:(id)item {
    // 传了item, 则使用item(拷贝)
    if (item) {
        _item = [HYPEnvironmentItemManage mutableCopyItem:item];
        return;
    }
    
    // 没传item
    // 1、如果存在缓存，使用缓存(生成item)
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:HYPEnvironmentSelectorEditItemSaveKey];
    if (data) {
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dict != nil) {
            _item = [HYPEnvironmentItemManage itemWithDictionary:dict];
            return;
        }
    }
    // 2、如果有模板，使用模板(拷贝)
    id baseItem = [HYPEnvironmentSelectorManager sharedManager].customEnvironmentItemTemplate;
    if (baseItem != nil) {
        _item = [HYPEnvironmentItemManage mutableCopyItem:baseItem];
        return;
    }
    
    // 3、如果什么都没，生成一个item
    _item = [HYPEnvironmentItemManage itemWithDictionary:nil];
}

- (instancetype)initWithItem:(id)item {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setItemUseItem:item];
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
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
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
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:itemDict];
    [[NSUserDefaults standardUserDefaults] setObject:data
                                              forKey:HYPEnvironmentSelectorEditItemSaveKey];
    [[HYPEnvironmentSelectorManager sharedManager] hideEnvironmentSelectorWindowAnimated:YES completionBlock:^{
        EnvironmentSelectedBlock block = [[HYPEnvironmentSelectorManager sharedManager].environmentSelectedBlock copy];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYPEnvironmentInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:HYPEnvironmentInfoEditCellID
                                                                       forIndexPath:indexPath];
    NSString *propertyKey = self.keys[indexPath.row];
    id value = [HYPEnvironmentItemManage getObjectForKey:propertyKey inItem:self.item];
    cell.titleLabel.text = propertyKey;
    if (value == [NSNull null]) {
        cell.valueTextView.text = nil;
    } else {
        cell.valueTextView.text = value;
    }
    __weak typeof(self)weakSelf = self;
    cell.textViewEditBlock = ^(NSString *key, NSString *value) {
        [HYPEnvironmentItemManage updateObject:value forKey:key inItem:weakSelf.item];
    };
    return cell;
}


@end
