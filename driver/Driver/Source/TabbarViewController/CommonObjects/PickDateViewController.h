//
//  PickDateViewController.h
//  User
//
//  Created by Phan Minh Nhut on 5/18/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickDateViewControllerDelegate <NSObject>

@required -(void) pickerDate:(UIDatePicker*)picker didSelectDate:(NSString*)date;

@end

typedef enum{
    PickDateViewControllerTypeDOB, // dd/MM/yyyy
    PickDateViewControllerTypeNormal, // hour:minute dd/MM/yyyy
    
} PickDateViewControllerType;

@interface PickDateViewController : UIDatePicker{
    UIView *waitingView;
    UIViewController *viewController;
    UIToolbar* toolbar;
    id<PickDateViewControllerDelegate> __weak delegateController;
    PickDateViewControllerType typeDate;
}

@property (nonatomic,readonly) BOOL isShow;

/**
 Always use this func to create
 */
-(id) initWithType:(PickDateViewControllerType)type delegate:(id<PickDateViewControllerDelegate>)del forViewController:(UIViewController*)vc limitFromToday:(BOOL)limit;

/**
 Show this picker view
 */
-(void) show;

@end