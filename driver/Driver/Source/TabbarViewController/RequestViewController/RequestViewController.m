//
//  RequestViewController.m
//  Driver
//
//  Created by Phan Minh Nhựt on 6/10/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "RequestViewController.h"

@interface RequestViewController ()

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[[BarButtonMenu alloc] initWithCurrentViewController:self] getButtonMenu];
    [self.view setBackgroundColor:BACKGROUND_COLOR_WHITE];
    
    // create table view
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320*RATIOX, 480*RATIOY - 49 - 64)];
    [table setBackgroundColor:BACKGROUND_COLOR_WHITE];
    [table setSeparatorColor:BACKGROUND_COLOR_BLUE];
    
    source = [[TableRequestSource alloc] initWithTableView:table];
    
    [self.view addSubview:table];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
