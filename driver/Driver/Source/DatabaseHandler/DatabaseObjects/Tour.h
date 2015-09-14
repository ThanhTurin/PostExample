//
//  Tour.h
//  User
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tour : NSObject

/**
 Always use this func to get instance of class Tour
 */
+(Tour*) sharedTour;

/**
 Add new tour to database
 */
-(void) addNewTourToDatabaseWithInfo:(NSDictionary*)data;

/**
 Get all tour which user ordered. 
 RETURN: Array of NSDictionay.
 */
-(NSArray*) getAllTourOfUserWithPhone:(NSString*)phone;

@end
