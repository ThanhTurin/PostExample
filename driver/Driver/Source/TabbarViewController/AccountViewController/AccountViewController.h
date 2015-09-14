//
//  AccountViewController.h
//  User
//
//  Created by Phan Minh Nhut on 4/29/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldAccount.h"
#import "ButtonApp.h"

@interface AccountViewController : UIViewController{
    
    UIView *containView;
    TextFieldAccount *txtPhone, *txtName, *txtNameCar, *txtSeats, *txtNumCar, *txtAvartar, *txtCompany;
    ButtonApp *btnSend;
}

@end
