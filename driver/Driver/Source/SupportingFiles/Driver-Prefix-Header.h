//
//  User-Prefix-Header.h
//  User
//
//  Created by Phan Minh Nhut on 4/29/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#ifndef User_User_Prefix_Header_h
#define User_User_Prefix_Header_h

#define APP_NAME @"Drivers"

#define BACKGROUND_COLOR_BLUE [UIColor colorWithRed:25/255.0f green:145/255.0f blue:115/255.0f alpha:1.0f]
#define BACKGROUND_COLOR_WHITE [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]

#define BUTTON_FONT @"Arial"
#define LABEL_FONT @"Arial"

// Define key for NSDictionary (HistoryViewController)
#define KEY_HIS_NAME @"Name"
#define KEY_HIS_NUM_CAR @"NumCar"
#define KEY_HIS_COMPANY @"company"
#define KEY_HIS_TIMES @"NumberOfTimes"
#define KEY_HIS_PHONE @"NumberPhone"

// Animate for alert view
#define CUSTOM_ALERT_VIEW_ANIMATE_SHOW customAlertViewAnimationShowZoomIn
#define CUSTOM_ALERT_VIEW_ANIMATE_CLOSE customAlertViewAnimationCloseZoomIn

#import "HelperView.h"
#import "BarButtonMenu.h"
#import "BarButtonBack.h"
#import "DatabaseHandler.h"
#import "User.h"
#import "Driver.h"
#import "Company.h"
#import "Car.h"
#import "Tour.h"
#import "Network.h"
#import "CustomAlertView.h"
#import "BarButtonStatus.h"

#endif
