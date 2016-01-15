//
//  NSThreadController.m
//  多线程Demo
//
//  Created by SmartDoc on 16/1/8.
//  Copyright © 2016年 SmartDoc. All rights reserved.
//

#import "RootViewController.h"

#import "SingleThreadController.h"
#import "MoreThreadController.h"
#import "ThreadStateController.h"

#import "InvocOperController.h"
#import "BlockOperController.h"

#import "QueueController.h"

#import "ThreadSynchroController.h"

@interface RootViewController ()

{
    NSArray * titles;
}

@property (nonatomic,strong) NSArray * dataArray;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titles = @[@"NSThread",@"NSOperation",@"GCD",@"NSLock"];
    self.dataArray = @[@[@"执行单个线程",@"多个线程并发",@"线程状态"],@[@"NSInvocationOperation",@"NSBlockOperation"],@[@"串行/并发队列"],@[@"线程同步"]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RootTableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RootTableCell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:indexPath];
    UIViewController * vc;
    if (!indexPath.section) {
        if (!indexPath.row) {
            vc = [[SingleThreadController alloc] initWithNibName:@"MainViewController" bundle:nil];
        } else if (indexPath.row == 1) {
            vc = [[MoreThreadController alloc] initWithNibName:@"MainViewController" bundle:nil];
        } else {
            vc = [[ThreadStateController alloc] initWithNibName:@"ThreadStateController" bundle:nil];
        }
    } else if (indexPath.section == 1) {
        if (!indexPath.row) {
            vc = [[InvocOperController alloc] initWithNibName:@"MainViewController" bundle:nil];
        } else {
            vc = [[BlockOperController alloc] initWithNibName:@"MainViewController" bundle:nil];
        }
    } else if (indexPath.section == 2) {
        vc = [[QueueController alloc] initWithNibName:@"ThreadStateController" bundle:nil];
    } else {
        vc = [[ThreadSynchroController alloc] initWithNibName:@"MainViewController" bundle:nil];
    }
    vc.navigationItem.title = self.dataArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return titles[section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView * tableViewHeaderFooterView = (UITableViewHeaderFooterView *)view;
        tableViewHeaderFooterView.textLabel.text = titles[section];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
