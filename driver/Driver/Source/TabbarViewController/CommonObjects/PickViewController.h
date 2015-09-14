//
//  PickViewController.h
//  User
//
//  Created by Phan Minh Nhut on 5/18/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PickViewController;

@protocol PickViewControllerDelegate <NSObject>

@required -(void) pickerView:(PickViewController*)pickerView didSelectTitle:(NSString*)title;

/**
 Force pickerView select a row in component 0 (only show for the first time or update data, then pcikerview selects automatically).
 */
@optional -(NSInteger) pickerViewSetSelectRowForTheFirstTime:(PickViewController *)pickerView;

@end

@interface PickViewController : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>{
    NSArray *data;
    id<PickViewControllerDelegate> __weak delegateController;
    UIView *waitingView;
    UIViewController *viewController;
    UIToolbar* toolbar;
    NSInteger currentRow;
    BOOL isFirstShow;
}

@property (readonly) BOOL isShow;

/**
 Always use this func to create instance. Data is an array of NSString whick contains titles for pickview
 */
-(id) initWithData: (NSArray*)d delegate:(id<PickViewControllerDelegate>)del forViewController:(UIViewController*)vc;

/**
 Update data and reload.
 */
-(void) updateData:(NSArray*)d;

/**
 Get order of row based on title
 */
-(NSInteger) rowForTitle:(NSString*)title;

/**
 Show this pickview
 */
-(void) show;

@end
