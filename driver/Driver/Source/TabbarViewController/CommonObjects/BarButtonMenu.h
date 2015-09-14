//
//  BarButtonMenu.h
//  User
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface BarButtonMenu : UIView{
    MenuViewController *menuVC;
    UIViewController *currentVC;
}

@property (strong, readonly) UIBarButtonItem *btnMenu;

/**
 Use this func to create button
 */
-(id) initWithCurrentViewController:(UIViewController*)vc;

/**
 Use this func to get button
 */
-(UIBarButtonItem*) getButtonMenu;

@end
