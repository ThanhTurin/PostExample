//
//  MenuViewController.m
//  Driver
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // remove left bar button
    self.navigationItem.hidesBackButton = YES;
    
    // add back button
    self.navigationItem.rightBarButtonItem = [[[BarButtonBack alloc] initWithCurrentViewContrller:self] getButtonBack];

    // create GUI
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320 * RATIOX, 480 * RATIOY - 64 - self.tabBarController.tabBar.frame.size.height)];
    [table setBackgroundColor:[UIColor clearColor]];
    [table setSeparatorColor:[UIColor blackColor]];
    
    
    delegateTable = [[TableDelegateMenu alloc] initWithParent:self];
    [table setDelegate:delegateTable];
    [table setDataSource:delegateTable];
    
    // add table to view
    [self.view addSubview:table];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
