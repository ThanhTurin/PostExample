//
//  AppViewController.m
//  User
//
//  Created by Phan Minh Nhut on 5/1/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "AppViewController.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // navaigaiton
    self.navigationItem.rightBarButtonItem = [[[BarButtonBack alloc] initWithCurrentViewContrller:self] getButtonBack];
    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:BACKGROUND_COLOR_WHITE];
    
    txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, 320,480)];
    [txtView setBackgroundColor:BACKGROUND_COLOR_WHITE];
    [txtView setTextAlignment:NSTextAlignmentLeft];
    [txtView setTextColor:[UIColor blackColor]];
    [txtView setFont:[UIFont fontWithName:LABEL_FONT size:15 * RATIO_TEXT]];
    [self.view addSubview:txtView];
}

-(void)updateInfo{
    [txtView setText:[[Network sharedNetwork] readInfoFromServer:ServerInfoTypeApp]];
    [txtView sizeToFit];
    
    CGSize size = txtView.frame.size;
    float height = [HelperView getSizeScreen].height - 64 - self.tabBarController.tabBar.frame.size.height;
    
    float posX = 0,posY = 64;
    
    if (size.height < height){
        posY = 64 + (height - txtView.frame.size.height) / 2.0;
    }
    if (size.width < [HelperView getSizeScreen].width){
        posX = ([HelperView getSizeScreen].width - size.width) / 2.0;
    }
    
    [txtView setFrame:CGRectMake(posX, posY, size.width, size.height)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateInfo];
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
