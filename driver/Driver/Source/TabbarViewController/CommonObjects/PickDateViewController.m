//
//  PickDateViewController.m
//  User
//
//  Created by Phan Minh Nhut on 5/18/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "PickDateViewController.h"

@implementation PickDateViewController
@synthesize isShow;

-(void)show{
    
    if (isShow == NO){
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self setHidden:NO];
        [toolbar setHidden:NO];
        CGRect frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        CGRect frameToolbar = CGRectMake(0, toolbar.frame.origin.y, toolbar.frame.size.width, toolbar.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^(void){
            [self setFrame:frame];
            [toolbar setFrame:frameToolbar];
        }];
        [viewController.view addSubview:waitingView];
        [viewController.view bringSubviewToFront:waitingView];
        [viewController.view bringSubviewToFront:self];
        [viewController.view bringSubviewToFront:toolbar];
        isShow = YES;
    }
}

-(void) actionBtnDone{
    
    if (isShow == YES){
        CGRect frame = CGRectMake(self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        CGRect frameToolbar = CGRectMake(toolbar.frame.size.width, toolbar.frame.origin.y, toolbar.frame.size.width, toolbar.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^(void){
            [self setFrame:frame];
            [toolbar setFrame:frameToolbar];
        } completion:^(BOOL finish){
            [self setHidden:YES];
            [toolbar setHidden:YES];
        }];
        [waitingView removeFromSuperview];
        isShow = NO;
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        if (typeDate == PickDateViewControllerTypeNormal){
            [format setDateFormat:@"HH:mm - dd/MM/yyyy"];
        }
        else{
            [format setDateFormat:@"dd/MM/yyyy"];
        }
        NSString *date = [format stringFromDate:self.date];
        [delegateController pickerDate:self didSelectDate:date];
    }
}

-(void) actionChangeDate{
    
    // user only choose from today to future
    NSDate *date = self.date;
    NSDate *current = [NSDate date];
    
    if ([current compare:date] == NSOrderedDescending){
        self.date = current;
    }
}

-(id)initWithType:(PickDateViewControllerType)type delegate:(id<PickDateViewControllerDelegate>)del forViewController:(UIViewController *)vc limitFromToday:(BOOL)limit{
    
    CGSize sizeScreen = [HelperView getSizeScreen];
    float heightTabbar = vc.tabBarController.tabBar.frame.size.height;
    typeDate = type;
    if (self = [super init]){
        
        [self setFrame:CGRectMake(sizeScreen.width, sizeScreen.height - heightTabbar - self.frame.size.height, sizeScreen.width, self.frame.size.height)];
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        
        if (typeDate == PickDateViewControllerTypeNormal){
            self.datePickerMode = UIDatePickerModeDateAndTime;
        }
        else if (typeDate == PickDateViewControllerTypeDOB){
            self.datePickerMode = UIDatePickerModeDate;
        }
        if (limit){
            [self addTarget:self action:@selector(actionChangeDate) forControlEvents:UIControlEventValueChanged];
        }
        NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"vi_vn"];
        self.locale = local;
        
        delegateController = del;
        viewController = vc;
        waitingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 * RATIOX, 480 * RATIOY)];
        
        isShow = NO;
        
        toolbar = [[UIToolbar alloc] init];
        float heightToolbar = 40;
        toolbar.frame=CGRectMake(sizeScreen.width, self.frame.origin.y,320 * RATIOX, heightToolbar);
        toolbar.barStyle = UIBarStyleDefault;
        
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(actionBtnDone)];
        [toolbar setItems:@[flexibleSpaceLeft,doneButton]];
        
        [viewController.view addSubview:self];
        [viewController.view addSubview:toolbar];
    }
    
    return self;
}

@end
