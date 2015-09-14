//
//  Network.h
//  User
//
//  Created by Phan Minh Nhut on 5/6/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ServerInfoTypeAbout,
    ServerInfoTypeSupport,
    ServerInfoTypeApp,
} ServerInfoType;

#define SERVER_INFO_ABOUT @"About.rtf"

@interface Network : NSObject

/**
 Always use this func to get instance of class
 */
+(Network*) sharedNetwork;

/**
 Get IP address of this device.
 */
-(NSString*) getIPAddressOfThisDevice;

/**
 Get drivers near by user (all car, no condition)
 RETURN: Array of NSDictionary, each element is info of correspond driver.
 */
-(NSArray*) getDriverNearByLongitude:(float)longitude latitude:(float)latitude;

/**
 Get drivers near by user and have number of seats that user require
 RETURN: Array of NSDictionary, each element is info of correspond driver.
 */
-(NSArray *)getDriverNearByLongitude:(float)longitude latitude:(float)latitude numberSeat:(int)num;

/**
 Read file infomation from server
 */
-(NSString*) readInfoFromServer:(ServerInfoType)type;

@end
