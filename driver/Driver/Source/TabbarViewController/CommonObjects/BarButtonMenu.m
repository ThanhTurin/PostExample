//
//  BarButtonMenu.m
//  User
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "BarButtonMenu.h"

@implementation BarButtonMenu
@synthesize btnMenu;

-(UIBarButtonItem *)getButtonMenu{
    return self.btnMenu;
}

-(void) actionBtnMenu{
    [currentVC.navigationController pushViewController:menuVC animated:YES];
}

-(id) initWithCurrentViewController:(UIViewController *)vc{
    
    if (self = [super init]){
        
        currentVC = vc;
        [currentVC.view addSubview:self];
        
        menuVC = [[HelperView getAppDelegate].window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"MENU"];
        
        UIImage *img = [HelperView createImageWithName:@"bar_button_menu" extension:@"png"];
        UIImage *imgSelect = [HelperView createImageWithName:@"bar_button_select_menu" extension:@"png"];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [btn setBackgroundImage:[HelperView resizeImage:img scaledToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[HelperView resizeImage:imgSelect scaledToSize:CGSizeMake(20, 20)] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(actionBtnMenu) forControlEvents:UIControlEventTouchUpInside];
        
        btnMenu = [[UIBarButtonItem alloc] initWithCustomView:btn];

    }
    return self;
}

@end
