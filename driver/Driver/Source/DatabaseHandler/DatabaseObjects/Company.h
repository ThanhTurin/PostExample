//
//  Company.h
//  User
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject{
    NSArray *companys;
}

/**
 Always use this func to get instance of class Company
 */
+(Company*) sharedCompany;

/**
 Get info of company
 */
-(NSDictionary*) getInfoOfCompanyWithName:(NSString*)name;

/**
 Get info of all company on server.
 RETURN: Array of NSDictionary.
 */
-(NSArray*) getAllCompanys;

/**
 Update data as needed. Use to sync new data on server and user's mobile about list of companys.
 */
-(void) updateDataFromServer;

/**
 Price on database is 500000, this func will convert to 500.000
 */
-(NSString*) convertPrice:(NSString*)price;

@end
