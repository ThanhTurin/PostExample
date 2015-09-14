//
//  DatabaseHandler.h
//  User
//
//  Created by Phan Minh Nhut on 5/1/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

// SERVER HOSTINGER

#define NAME_OF_YOUR_LAPTOP @"thanhnhutshop.url.ph"
#define ADDR_LOCALHOST [NSString stringWithFormat:@"http://%@/TTTN",NAME_OF_YOUR_LAPTOP]
#define SERVER_DB @"mysql.hostinger.vn"
#define USERNAME_DB @"u531686247_root"
#define PASSWORD_DB @"123456789"
#define NAME_MYDB @"u531686247_tttn"


// LOCAL HOST
/*
#define NAME_OF_YOUR_LAPTOP @"Phans-MacBook-Pro"
#define ADDR_LOCALHOST [NSString stringWithFormat:@"http://%@.local:80/XAMPP/TTTN",NAME_OF_YOUR_LAPTOP]
#define SERVER_DB @"localhost"
#define USERNAME_DB @"root"
#define PASSWORD_DB @""
#define NAME_MYDB @"mydb"
*/
#define LOGIN_INFO_PARAM [NSString stringWithFormat:@"servername=%@&username=%@&password=%@&dbname=%@",SERVER_DB,USERNAME_DB,PASSWORD_DB,NAME_MYDB]

/********* KEY OF NSDICTIONARY (COLUMN OF DATABASE) ***********/

// user column
#define DB_DICT_USER_NAME @"Name"
#define DB_DICT_USER_PASS @"Pass"
#define DB_DICT_USER_EMAIL @"Email"
#define DB_DICT_USER_PHONE @"Phone" // Primary
#define DB_DICT_USER_PROMOTION @"PromotionCode"
#define DB_DICT_USER_ADDRESS @"Address"
#define DB_DICT_USER_BIRTHDAY @"BirthDay"
#define DB_DICT_USER_SEX @"Sex"
#define DB_DICT_USER_AVATAR @"Avatar"
#define DB_DICT_USER_LONGITUDE @"Longitude"
#define DB_DICT_USER_LATITUDE @"Latitude"
#define DB_DICT_USER_IP_ADDRESS @"IPAddress"


// drvier column
#define DB_DICT_DRIVER_NAME @"Name"
#define DB_DICT_DRIVER_PASS @"Pass"
#define DB_DICT_DRIVER_EMAIL @"Email"
#define DB_DICT_DRIVER_PHONE @"Phone" // Primary
#define DB_DICT_DRIVER_PROMOTION @"PromotionCode"
#define DB_DICT_DRIVER_ADDRESS @"Address"
#define DB_DICT_DRIVER_BIRTHDAY @"BirthDay"
#define DB_DICT_DRIVER_SEX @"Sex"
#define DB_DICT_DRIVER_AVATAR @"Avatar"
#define DB_DICT_DRIVER_COMPANY @"Company"
#define DB_DICT_DRIVER_CAR_ID @"CarID"
#define DB_DICT_DRIVER_LONGITUDE @"Longitude"
#define DB_DICT_DRIVER_LATITUDE @"Latitude"
#define DB_DICT_DRIVER_IP_ADDRESS @"IPAddress"
#define DB_DICT_DRIVER_IS_IDLE @"IS_IDLE"

// tour column
#define DB_DICT_TOUR_ID @"id" // primary
#define DB_DICT_TOUR_USER_ID @"User_ID"
#define DB_DICT_TOUR_DRIVER_ID @"Driver_ID"
#define DB_DICT_TOUR_FROM_LOCATION @"From_Location"
#define DB_DICT_TOUR_TO_LOCATION @"To_Location"
#define DB_DICT_TOUR_TOTAL_LENGTH @"Total_Length"
#define DB_DICT_TOUR_PRICE @"Price"
#define DB_DICT_TOUR_FROM_TIME @"From_Time"
#define DB_DICT_TOUR_TO_TIME @"To_Time"

// Car column
#define DB_DICT_CAR_ID @"CarID" // Primary
#define DB_DICT_CAR_CAPACITY @"Capacity"
#define DB_DICT_CAR_CAR_NUMBER @"CarNumber"
#define DB_DICT_CAR_CAR_MAKER @"CarMaker"

// Company Column
#define DB_DICT_COMPANY_NAME @"Name" // primary
#define DB_DICT_COMPANY_ADDRESS @"Address"
#define DB_DICT_COMPANY_PHONE @"Phone"
#define DB_DICT_COMPANY_PROMOTION_CODE @"PromotionCode"
#define DB_DICT_COMPANY_PRICE_PER_KM @"Price_per_km"

// Book
#define DB_DICT_BOOK_ID @"ID"
#define DB_DICT_BOOK_FROM_LOCATION @"FROM_LOCATION"
#define DB_DICT_BOOK_TO_LOCATION @"TO_LOCATION"
#define DB_DICT_BOOK_SEATS @"SEATS"
#define DB_DICT_BOOK_NUMBER_CUSTOMER @"NUMBER_CUSTOMER"
#define DB_DICT_BOOK_CUSTOMER_PHONE @"CUSTOMER_PHONE"
#define DB_DICT_BOOK_DATE_GO @"DATE_GO"

/**************************/

/********** TABLE OF DATABASE **********/

// userinfo
#define DB_TABLE_USER_INFO @"userinfo"
#define DB_TABLE_USER_INFO_PRIMARYKEY DB_DICT_USER_PHONE

// driverinfo
#define DB_TABLE_DRIVER_INFO @"driverinfo"
#define DB_TABLE_DRIVER_INFO_PRIMARYKEY DB_DICT_DRIVER_PHONE

// Tourinfo
#define DB_TABLE_TOUR_INFO @"tour"
#define DB_TABLE_TOUR_INFO_PRIMARYKEY DB_DICT_TOUR_ID

// Carinfo
#define DB_TABLE_CAR_INFO @"Car"
#define DB_TABLE_CAR_INFO_PRIMARYKEY DB_DICT_CAR_ID

// Company Info
#define DB_TABLE_COMPANY_INFO @"Company"
#define DB_TABLE_COMPANY_INFO_PRIMARYKEY DB_DICT_COMPANY_NAME

// Book
#define DB_TABLE_BOOK_INFO @"Book"
#define DB_TABLE_BOOK_INFO_PRIMARYKEY DB_DICT_BOOK_ID

/**************************/

@interface DatabaseHandler : NSObject{
    UIView *waitingView;
    BOOL isShowWait;
}

/**
 Use this singletone to access this instance of Databasehandler
 */
+(DatabaseHandler*) sharedDatabaseHandler;

/**
 Get all info of users.
 */
-(NSDictionary*) getUserInfoWithNumberPhone:(NSString*)phone;

/**
 Get all info of driver.
 */
-(NSDictionary*) getDriverInfoWithNumberPhone:(NSString*)phone;

/**
 Get all info of car.
 */
-(NSDictionary*) getCarInfoWithID:(NSString*)ID;

/**
 Get all info of tour.
 */
-(NSDictionary*) getTourInfoWithID:(NSString*)ID;

/**
 Get all info of company
 */
-(NSDictionary*) getCompanyWithName:(NSString*)name;

/**
 Get list of any info from table conform a/some condition(s). This func return an array of NSDictionary for each object.
 */
-(NSArray*) getInfoFromTable:(NSString*)table withCondition:(NSString*)where;

/**
 Get list of any info from table. This func return an array of NSDictionary for each object.
 */
-(NSArray*) getAllInfoFromTable:(NSString*)table;

/**
 Insert data to Database (only support NSString).
 @param table: is table you select
 @param data: is instance of NSDictionary, key is column and value is corespond value.
 @param pk: is primary key of user.
 @param pValue: is correspond value of primary key.
 */
-(void)insertStringTable:(NSString*)table data:(NSDictionary *)data primaryKey:(NSString*)pk primaryValue:(NSString*)pValue;

/**
 Update data to Database (only support NSString).
 @param table: is table you select
 @param data: is instance of NSDictionary, key is column and value is corespond value.
 @param pk: is primary key of user.
 @param pValue: is correspond value of primary key.
 */
-(void)updateStringTable:(NSString *)table data:(NSDictionary *)data primaryKey:(NSString *)pk primaryValue:(NSString *)pValue;

/**
 Delete a row
 @param table: is table you select
 @param pk: is primary key of user.
 @param pValue: is correspond value of primary key.
 */
-(void) deleteTable:(NSString*)table primaryKey:(NSString*)primary keyValue:(NSString*)value;

/**
 Upload avatar to sever
 */
-(void) uploadAvatar:(UIImage *)avatar forNumberPhone:(NSString*)phone;

/**
 Download avatar from sever
 */
-(UIImage*) downloadAvatarForNumberPhone:(NSString*)phone;

/**
 Show a view while waitaing the app connect to server and get result. Remember call func "hideWaitingView" after all things completed.
 */
-(void) showWaitingView;

/**
 Hide a waiting View.
 */
-(void) hideWaitingView;

/**
 Rename file store on server (Avatar image)
 */
-(void) renameAvatar:(NSString*)oldName newName:(NSString*)newName;

@end
