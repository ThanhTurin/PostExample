//
//  BarButtonStatus.h
//  Driver
//
//  Created by Phan Minh Nhựt on 6/10/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarButtonStatus : NSObject{
    BOOL isIdle;
    UIImage *imgIdle, *imgWorking;
    UIButton *btn;
}

@property (nonatomic,readonly) UIBarButtonItem *btnStatus;

/**
Use this func to get button
*/
+(UIBarButtonItem*) sharedBarButtonStatus;

@end
