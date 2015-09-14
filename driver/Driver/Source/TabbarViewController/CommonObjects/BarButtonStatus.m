//
//  BarButtonStatus.m
//  Driver
//
//  Created by Phan Minh Nhựt on 6/10/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "BarButtonStatus.h"

@implementation BarButtonStatus
@synthesize btnStatus;
static BarButtonStatus *sharedBarButtonStatus = nil;

+(UIBarButtonItem *)sharedBarButtonStatus{
    if (sharedBarButtonStatus == nil){
        sharedBarButtonStatus = [[BarButtonStatus alloc] init];
    }
    
    return sharedBarButtonStatus.btnStatus;
}

-(void) actionBtnStatus{
    if (isIdle){
        isIdle = NO;
        [[Driver sharedDrivers] updateInfo:@{DB_DICT_DRIVER_IS_IDLE: @"NO"} updateAvatar:nil];
        [btn setBackgroundImage:imgWorking forState:UIControlStateNormal];
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Thông báo" message:@"Bạn đã chuyển sang trạng thái bận. Khách hàng sẽ không thấy bạn trên hệ thống" delegate:nil buttonTitles:@[@"Đóng"]];
        [alert show];
    }
    else{
        isIdle = YES;
        [[Driver sharedDrivers] updateInfo:@{DB_DICT_DRIVER_IS_IDLE: @"YES"} updateAvatar:nil];
        [btn setBackgroundImage:imgIdle forState:UIControlStateNormal];
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Thông báo" message:@"Bạn đã chuyển sang trạng thái rỗi. Khách hàng có thể nhìn thấy bạn trên hệ thống" delegate:nil buttonTitles:@[@"Đóng"]];
        [alert show];
    }
}

-(id) init{
    
    if (self = [super init]){
        
        isIdle = [(NSString*)[[[Driver sharedDrivers] getInfo] objectForKey:DB_DICT_DRIVER_IS_IDLE] boolValue];
        
        imgIdle = [HelperView resizeImage:[HelperView createImageWithName:@"bar_button_status_idle" extension:@"png"] scaledToSize:CGSizeMake(20, 20)];
        imgWorking = [HelperView resizeImage:[HelperView createImageWithName:@"bar_button_status_working" extension:@"png"] scaledToSize:CGSizeMake(20, 20)];
        
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        UIImage *img = (isIdle)? imgIdle : imgWorking;
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(actionBtnStatus) forControlEvents:UIControlEventTouchUpInside];
        
        btnStatus = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return self;
}

@end
