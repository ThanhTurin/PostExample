//
//  Car.h
//  User
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject{
    NSArray *Cars;
}

/**
 Always use this func to get instance of class Car
 */
+(Car*) sharedCar;

/**
 Register car for new driver, this func also updates for server.
 */
-(void) registerCarForDriverWithPhone:(NSString*)phone info:(NSDictionary*)data;

/**
 Update car for driver, this func also updates for server
 */
-(void) updateCarForDriverWithPhone:(NSString*)phone info:(NSDictionary*)data;

/**
 Get info of Car
 */
-(NSDictionary*) getInfoOfCarWithID:(NSString*)ID;

/**
 Get info of all Car on server.
 RETURN: Array of NSDictionary.
 */
-(NSArray*) getAllCars;

/**
 Update data as needed. Use to sync new data on server and user's mobile about list of Cars.
 */
-(void) updateDataFromServer;

@end
