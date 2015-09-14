//
//  Tour.m
//  User
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "Tour.h"

@implementation Tour
static Tour *sharedTour = nil;

+(Tour *)sharedTour{
    if (sharedTour == nil){
        sharedTour = [[Tour alloc] init];
    }
    
    return sharedTour;
}

-(void) addNewTourToDatabaseWithInfo:(NSDictionary *)data{
    
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ddMMyyyy-HHmmss"];
    NSString *dateStr = [format stringFromDate:date];
    NSString *phoneUser = (NSString*)[data objectForKey:DB_DICT_TOUR_USER_ID];
    NSString *phoneDriver = (NSString*)[data objectForKey:DB_DICT_TOUR_DRIVER_ID];
    
    NSString *ID = [NSString stringWithFormat:@"%@_%@_%@",dateStr,phoneUser,phoneDriver];
    
    [[DatabaseHandler sharedDatabaseHandler] insertStringTable:DB_TABLE_TOUR_INFO data:data primaryKey:DB_TABLE_TOUR_INFO_PRIMARYKEY primaryValue:ID];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(NSArray *)getAllTourOfUserWithPhone:(NSString *)phone{
    
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    NSArray *data = [[DatabaseHandler sharedDatabaseHandler] getInfoFromTable:DB_TABLE_TOUR_INFO withCondition:[NSString stringWithFormat:@"%@='%@'",DB_TABLE_USER_INFO_PRIMARYKEY, phone]];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
    return data;
}

@end
