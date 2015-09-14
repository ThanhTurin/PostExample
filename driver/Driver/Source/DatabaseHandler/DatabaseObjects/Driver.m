//
//  Driver.m
//  Driver
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "Driver.h"

#define FILE_OF_NAME @"Number_Phone_Drivers.data"

@implementation Driver
static Driver *sharedDriver = nil;

+(Driver *)sharedDrivers{
    if (sharedDriver == nil){
        sharedDriver = [[Driver alloc] init];
    }
    
    return sharedDriver;
}

-(BOOL)loginDriverWithCode:(NSString *)code phone:(NSString*)phone{
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    numberPhone = phone;
    info = [[DatabaseHandler sharedDatabaseHandler] getDriverInfoWithNumberPhone:numberPhone];
    infoCar = [[DatabaseHandler sharedDatabaseHandler] getCarInfoWithID:numberPhone];
    avatar = [[DatabaseHandler sharedDatabaseHandler] downloadAvatarForNumberPhone:[NSString stringWithFormat:@"%@_Driver",numberPhone]];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
    
    if ([[info objectForKey:DB_DICT_DRIVER_PASS] isEqualToString:code]){
        [self writeToFileNumberPhone:phone];
        return YES;
    }
    
    return NO;
}

-(void)registerNumberPhone:(NSString *)phone info:(NSDictionary *)data{
    
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    numberPhone = phone;
    [self writeToFileNumberPhone:phone];
    [[DatabaseHandler sharedDatabaseHandler] insertStringTable:DB_TABLE_DRIVER_INFO data:data primaryKey:DB_TABLE_DRIVER_INFO_PRIMARYKEY primaryValue:phone];
    info = [[DatabaseHandler sharedDatabaseHandler] getDriverInfoWithNumberPhone:phone];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(void)updateInfo:(NSDictionary *)data updateAvatar:(UIImage *)img{
    
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    
    if (img != nil){
        [self updateAvatar:img];
        [[DatabaseHandler sharedDatabaseHandler] uploadAvatar:avatar forNumberPhone:[NSString stringWithFormat:@"%@_Driver",numberPhone]];
    }
    else if (avatar == nil){
        avatar = [[DatabaseHandler sharedDatabaseHandler] downloadAvatarForNumberPhone:numberPhone];
    }
    
    if (data != nil){
        [[DatabaseHandler sharedDatabaseHandler] updateStringTable:DB_TABLE_DRIVER_INFO data:data primaryKey:DB_TABLE_DRIVER_INFO_PRIMARYKEY primaryValue:numberPhone];
        
        NSString *newPhone = (NSString*)[data objectForKey:DB_DICT_DRIVER_PHONE];
        if (newPhone){
            [[DatabaseHandler sharedDatabaseHandler] renameAvatar:numberPhone newName:newPhone];
            [[DatabaseHandler sharedDatabaseHandler] updateStringTable:DB_TABLE_CAR_INFO data:@{DB_DICT_CAR_ID: newPhone} primaryKey:DB_TABLE_DRIVER_INFO_PRIMARYKEY primaryValue:numberPhone];
            numberPhone = newPhone;
            [self writeToFileNumberPhone:newPhone];
        }
        info = [[DatabaseHandler sharedDatabaseHandler] getDriverInfoWithNumberPhone:numberPhone];
    }
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(void)updateDataFromServer{
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    info = [[DatabaseHandler sharedDatabaseHandler] getDriverInfoWithNumberPhone:numberPhone];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(NSDictionary *)getInfo{
    return info;
}

-(NSDictionary *) getInfoCar{
    return infoCar;
}

-(NSDictionary *)getInfoWithNumberPhone:(NSString *)phone{
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    NSDictionary *data = [[DatabaseHandler sharedDatabaseHandler] getDriverInfoWithNumberPhone:phone];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
    
    return data;
}

-(BOOL) checkPassword:(NSString *)password{
    NSString *pass = [info objectForKey:DB_DICT_DRIVER_PASS];
    if ([pass isEqualToString:password]){
        NSLog(@"Two passwords match");
        return YES;
    }
    NSLog(@"Password incorrect");
    
    return NO;
}

-(UIImage *)getAvatar{
    return avatar;
}

-(void)updateAvatar:(UIImage *)img{
    avatar = [HelperView resizeImage:img scaledToSize:CGSizeMake(100, 100)];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    
    newLong = location.coordinate.longitude;
    newLat = location.coordinate.latitude;
    
    if (timer == nil){
        [self sendLocation];
        timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(sendLocation) userInfo:nil repeats:YES];
    }
}

-(void) location{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

-(void) updateLocationToDatabase{
    NSDictionary *data = @{
                           DB_DICT_DRIVER_LONGITUDE: [NSString stringWithFormat:@"%f",newLong],
                           DB_DICT_DRIVER_LATITUDE: [NSString stringWithFormat:@"%f", newLat],
                           };
    [[DatabaseHandler sharedDatabaseHandler] updateStringTable:DB_TABLE_DRIVER_INFO data:data primaryKey:DB_TABLE_DRIVER_INFO_PRIMARYKEY primaryValue:numberPhone];
    NSLog(@"Update new location to database");
}

-(void) sendLocation{
    if ((fabsf(currentLong - newLong) > 0.0003) || (fabsf(currentLat - newLat) > 0.0003)){
        currentLat = newLat;
        currentLong = newLong;
        [NSThread detachNewThreadSelector:@selector(updateLocationToDatabase) toTarget:self withObject:nil];
    }
}

-(id) init{
    if (self = [super init]){
        
        avatar = nil;
        newLong = 0;
        newLat = 0;
        currentLat = 0;
        currentLong = 0;
        [self location];
        
        // check path is exist or not
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:FILE_OF_NAME];
        
        BOOL *isDictionary = malloc(sizeof(BOOL));
        *isDictionary = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:isDictionary] == YES){
            // get number phone from file.
            numberPhone = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
            
            // get info from database
            info = [[DatabaseHandler sharedDatabaseHandler] getDriverInfoWithNumberPhone:numberPhone];
            
            // get info of Car
            infoCar = [[DatabaseHandler sharedDatabaseHandler] getCarInfoWithID:numberPhone];
            
            // get avatar from server
            avatar = [[DatabaseHandler sharedDatabaseHandler] downloadAvatarForNumberPhone:[NSString stringWithFormat:@"%@_Driver",numberPhone]];
        }
    }
    
    return self;
}

-(void) writeToFileNumberPhone:(NSString*)phone{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:FILE_OF_NAME];
    
    if ([phone writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL]){
        NSLog(@"Write number phone - Success - Path: %@",filePath);
    }
    else {
        NSLog(@"Write number phone - Failed - Path: %@",filePath);
    }
}

@end
