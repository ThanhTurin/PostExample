//
//  BarButtonBack.m
//  User
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "BarButtonBack.h"

@implementation BarButtonBack
@synthesize btnBack;

-(UIBarButtonItem *)getButtonBack{
    return self.btnBack;
}

-(void) actionBtnBack{
    [currentVC.navigationController popViewControllerAnimated:YES];
}

-(id) initWithCurrentViewContrller:(UIViewController *)vc{
    
    if (self = [super init]){
        
        currentVC = vc;
        [currentVC.view addSubview:self];
        
        UIImage *img = [HelperView createImageWithName:@"bar_button_back" extension:@"png"];
        UIImage *imgSelect = [HelperView createImageWithName:@"bar_button_select_back" extension:@"png"];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [btn setBackgroundImage:[HelperView resizeImage:img scaledToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[HelperView resizeImage:imgSelect scaledToSize:CGSizeMake(20, 20)] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(actionBtnBack) forControlEvents:UIControlEventTouchUpInside];
        
        btnBack = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return self;
}
@end
