//
//  BarButtonBack.h
//  User
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Use to back previous view
 */
@interface BarButtonBack : UIView{
    UIViewController *currentVC;
}

@property (strong, readonly) UIBarButtonItem *btnBack;

/**
 Use this func to create instance
 */
-(id) initWithCurrentViewContrller:(UIViewController*)vc;

/**
 Use this func to get button
 */
-(UIBarButtonItem*) getButtonBack;

@end
