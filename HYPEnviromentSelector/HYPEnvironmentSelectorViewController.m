//
//  HYPEnvironmentSelectorViewController.m
//  HYPEnviromentSelector
//
//  Created by TBD on 2018/4/13.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>

#import "HYPEnvironmentSelectorViewController.h"
#import "HYPEnvironmentInfoCell.h"
#import "HYPEnvironmentSelectorPlugin.h"
#import "HYPEnvironmentSelectorEditItemViewController.h"
#import "HYPEnvironmentItemManage.h"

static NSString *HYPEnvironmentInfoCellID = @"HYPEnvironmentInfoCellID";

@interface HYPEnvironmentSelectorViewController()

@property (nonatomic, strong) NSArray *items;

@end

@implementation HYPEnvironmentSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [HYPEnvironmentSelectorPlugin getEnvironmentItems];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancelSelectEnvironment)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                           target:self
                                                                                           action:@selector(pushToEditViewControllerWithItemUseCache)];
    self.title = @"Environment Selector";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HYPEnvironmentInfoCell class]
           forCellReuseIdentifier:HYPEnvironmentInfoCellID];
}

- (void)cancelSelectEnvironment {
    [HYPEnvironmentSelectorPlugin hideEnvironmentSelectorWindowAnimated:YES completionBlock:nil];
}

- (void)pushToEditViewControllerWithItemUseCache {
    [self pushToEditViewControllerWithItem:nil];
}

- (void)pushToEditViewControllerWithItem:(id)item {
    HYPEnvironmentSelectorEditItemViewController *editVC = [[HYPEnvironmentSelectorEditItemViewController alloc] initWithItem:item];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYPEnvironmentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:HYPEnvironmentInfoCellID
                                                            forIndexPath:indexPath];
    
    id item = self.items[indexPath.row];
    NSString *title;
    id tmpName = [HYPEnvironmentItemManage getObjectForKey:@"name" inItem:item];
    if (tmpName) {
        title = [NSString stringWithFormat:@"%@", tmpName];
    } else {
        title = @"Don't Have Name";
    }
    
    if (indexPath.row == 0) {
        cell.topLine.hidden = NO;
    } else {
        cell.topLine.hidden = YES;
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = [HYPEnvironmentItemManage descriptionForItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [HYPEnvironmentSelectorPlugin hideEnvironmentSelectorWindowAnimated:YES completionBlock:^{
        EnvironmentSelectedBlock block = [HYPEnvironmentSelectorPlugin.environmentSelectedBlock copy];
        if (block) {
            block(self.items[indexPath.row]);
        }
    }];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    id item = self.items[indexPath.row];
    [self pushToEditViewControllerWithItem:item];
}



@end









