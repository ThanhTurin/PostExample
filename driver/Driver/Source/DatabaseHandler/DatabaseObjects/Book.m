//
//  Book.m
//  User
//
//  Created by Phan Minh Nhut on 5/18/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "Book.h"

@implementation Book
static Book *sharedBook = nil;

+(Book *)sharedBook{
    if (sharedBook == nil){
        sharedBook = [[Book alloc] init];
    }
    
    return sharedBook;
}

-(NSArray *)getAllBookToday{
    NSArray *books = [[DatabaseHandler sharedDatabaseHandler] getAllInfoFromTable:DB_TABLE_BOOK_INFO];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *book in books){
        // get order date
        NSString *dateStr = (NSString*)[book objectForKey:DB_DICT_BOOK_DATE_GO];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"HH:mm - dd/MM/yyyy"];
        NSDate *dateOrder = [format dateFromString:dateStr];
        
        // get today
        NSDate *today = [NSDate date];
        NSDateFormatter *formatOnlyDate = [[NSDateFormatter alloc] init];
        [formatOnlyDate setDateFormat:@"dd/MM/yyyy"];
        NSString *todayStr = [formatOnlyDate stringFromDate:today];
        
        NSDate *lowDate = [format dateFromString:[format stringFromDate:[NSDate date]]];
        NSDate *upDate = [format dateFromString:[NSString stringWithFormat:@"23:59 - %@",todayStr]];
        
        if (([dateOrder compare:lowDate] == NSOrderedDescending || [dateOrder compare:lowDate] == NSOrderedSame) &&
            ([dateOrder compare:upDate] == NSOrderedAscending || [dateOrder compare:upDate] == NSOrderedSame)){
            [array addObject:book];
        }
    }
    return array;
}

-(void)sendBookWithData:(NSDictionary *)data{
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"ddMMyyyy-HHmmss"];
    NSString *dateStr = [format stringFromDate:date];
    NSString *phoneUser = (NSString*)[[[User sharedUsers] getInfo] objectForKey:DB_TABLE_USER_INFO_PRIMARYKEY];
    
    NSString *ID = [NSString stringWithFormat:@"BOOK_%@_%@_",dateStr,phoneUser];
    
    [[DatabaseHandler sharedDatabaseHandler] insertStringTable:DB_TABLE_BOOK_INFO data:data primaryKey:DB_TABLE_BOOK_INFO_PRIMARYKEY primaryValue:ID];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

@end
