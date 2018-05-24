//
//  HYPEnvironmentSelectorViewController.m
//  HYPEnvironmentSelector
//
//  Created by TBD on 2018/4/13.
//  Copyright © 2018年 TBD. All rights reserved.
//

#import <objc/runtime.h>

#import "HYPEnvironmentSelectorViewController.h"
#import "HYPEnvironmentSelectorEditItemViewController.h"
#import "HYPEnvironmentItemManage.h"
#import "HYPEnvironmentSelectorManager.h"

//@interface HYPEnvironmentSelectorViewCellModel : NSObject
//
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *description;
//@property (nonatomic, assign) CGFloat height;
//
//@end
//
//@implementation HYPEnvironmentSelectorViewCellModel
//
//- (CGFloat)height {
//    if ((int)self->_height == 0) {
//        self
//    }
//    return self->_height;
//}
//
//- (CGFloat)calculateHeight {
//
//}
//
//@end



static NSString *HYPEnvironmentInfoCellID = @"HYPEnvironmentInfoCellID";

@interface HYPEnvironmentSelectorViewController()

@property (nonatomic, copy) NSArray *items;

@end

@implementation HYPEnvironmentSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [HYPEnvironmentSelectorManager sharedManager].environmentItems;
    if (self.items.count == 0) {
        NSLog(@"\
\n\n\
===============================================================\
\n should set `HYPEnvironmentSelectorPlugin.environmentItems \n\
===============================================================\
\n\n");
    }
    if (self.isCanCancel) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(cancelSelectEnvironment)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                           target:self
                                                                                           action:@selector(pushToEditViewControllerWithItemUseCache)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.title = @"Environment Selector";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
}

- (void)setIsCanCancel:(BOOL)isCanCancel {
    self->_isCanCancel = isCanCancel;
    if (!self.navigationItem) {
        return;
    }
    if (isCanCancel) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                              target:self
                                                                                              action:@selector(cancelSelectEnvironment)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)cancelSelectEnvironment {
    [[HYPEnvironmentSelectorManager sharedManager] hideEnvironmentSelectorWindowAnimated:YES completionBlock:nil];
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (@available(iOS 11, *)) {
        return UITableViewAutomaticDimension;
    } else {
        return [self calculateHeightForIndex:indexPath];
    }
}

- (CGFloat)calculateHeightForIndex:(NSIndexPath *)indexPath {
    id item = self.items[indexPath.row];
    NSString *title;
    id tmpName = [HYPEnvironmentItemManage getObjectForKey:@"name" inItem:item];
    if (tmpName) {
        title = [NSString stringWithFormat:@"%@", tmpName];
    } else {
        title = @"No name was set.";
    }
    NSString *detail = [HYPEnvironmentItemManage descriptionForItem:item escapeName:YES];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:HYPEnvironmentInfoCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:HYPEnvironmentInfoCellID];
    }
    
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: cell.textLabel.font}
                                           context:nil];
    CGRect detailRect = [detail boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: cell.detailTextLabel.font}
                                             context:nil];
    return titleRect.size.height + detailRect.size.height + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HYPEnvironmentInfoCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:HYPEnvironmentInfoCellID];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if ([HYPEnvironmentSelectorManager sharedManager].isCanEditItemFromListItem) {
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    id item = self.items[indexPath.row];
    NSString *title;
    id tmpName = [HYPEnvironmentItemManage getObjectForKey:@"name" inItem:item];
    if (tmpName) {
        title = [NSString stringWithFormat:@"%@", tmpName];
    } else {
        title = @"No name was set.";
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = [HYPEnvironmentItemManage descriptionForItem:item escapeName:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[HYPEnvironmentSelectorManager sharedManager] hideEnvironmentSelectorWindowAnimated:YES completionBlock:^{
        EnvironmentSelectedBlock block = [[HYPEnvironmentSelectorManager sharedManager].environmentSelectedBlock copy];
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









