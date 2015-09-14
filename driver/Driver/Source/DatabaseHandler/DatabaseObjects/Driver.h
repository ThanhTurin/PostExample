//
//  Driver.h
//  Driver
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Driver : NSObject <CLLocationManagerDelegate>{
    NSDictionary *info, *infoCar;
    NSString *numberPhone;
    UIImage *avatar;
    float newLong;
    float newLat;
    float currentLong;
    float currentLat;
    CLLocationManager *locationManager;
    NSTimer *timer;
}

/**
 Always use this func to get instance of class Driver (Singletone)
 */
+(Driver*) sharedDrivers;

/**
 Login.
 */
-(BOOL)loginDriverWithCode:(NSString *)code phone:(NSString*)phone;

/**
 Send info of Driver to database server. This func also writes the phone to file.
 */
-(void) registerNumberPhone:(NSString*)phone info:(NSDictionary*)data;

/**
 Check @param "password" equal to Driver's password or not.
 RETURN: YES if two password are matched.
 */
-(BOOL) checkPassword:(NSString*)password;

/**
Update info of driver and also update it on database server. If @param data or img is nil, this func will update latest info from database (equal to "updateDataFromServer").
*/
-(void) updateInfo:(NSDictionary*)data updateAvatar:(UIImage*) img;

/**
 Update latest info from server.
 */
-(void) updateDataFromServer;

/**
 Get info of Driver
 */
-(NSDictionary*) getInfo;

/**
 Get info of Car's Driver
 */
-(NSDictionary *) getInfoCar;

/**
 Get info od any driver with his/her number phone;
 */
-(NSDictionary*) getInfoWithNumberPhone:(NSString*)phone;

/**
 Get Avatar of Driver
 */
-(UIImage*) getAvatar;

/**
 Update avatar. This func does not upload to database.
 */
-(void) updateAvatar:(UIImage*)img;

@end
