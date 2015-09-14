//
//  Car.m
//  User
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "Car.h"

@implementation Car
static Car *sharedCar = nil;

+(Car *)sharedCar{
    if (sharedCar == nil){
        sharedCar = [[Car alloc] init];
    }
    
    return sharedCar;
}

-(NSDictionary *)getInfoOfCarWithID:(NSString *)ID{
    
    for (NSDictionary *Car in Cars){
        
        NSString *CarName = (NSString*)[Car objectForKey:DB_DICT_CAR_ID];
        if ([CarName isEqualToString:ID]){
            return Car;
        }
    }
    
    return nil;
}

-(NSArray *)getAllCars{
    return Cars;
}

-(void)updateDataFromServer{
    
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    Cars = [[DatabaseHandler sharedDatabaseHandler] getAllInfoFromTable:DB_TABLE_CAR_INFO];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(void)registerCarForDriverWithPhone:(NSString *)phone info:(NSDictionary *)data{
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    [[DatabaseHandler sharedDatabaseHandler] insertStringTable:DB_TABLE_CAR_INFO data:data primaryKey:DB_TABLE_CAR_INFO_PRIMARYKEY primaryValue:phone];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:Cars];
    [array addObject:data];
    Cars = array;
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(void)updateCarForDriverWithPhone:(NSString *)phone info:(NSDictionary *)data{
    
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    [[DatabaseHandler sharedDatabaseHandler] updateStringTable:DB_TABLE_CAR_INFO data:data primaryKey:DB_TABLE_CAR_INFO_PRIMARYKEY primaryValue:phone];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
    
}

-(id) init{
    
    if (self = [super init]){
        [self updateDataFromServer];
    }
    
    return self;
}

@end
