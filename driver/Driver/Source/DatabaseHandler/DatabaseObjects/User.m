//
//  User.m
//  User
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "User.h"

#define FILE_OF_NAME @"Number_Phone_Users.data"

@implementation User
static User *sharedUser = nil;

+(User *)sharedUsers{
    if (sharedUser == nil){
        sharedUser = [[User alloc] init];
    }
    
    return sharedUser;
}

-(void)registerNumberPhone:(NSString *)phone info:(NSDictionary *)data{
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    numberPhone = phone;
    [self writeToFileNumberPhone:phone];
    [[DatabaseHandler sharedDatabaseHandler] insertStringTable:DB_TABLE_USER_INFO data:data primaryKey:DB_TABLE_USER_INFO_PRIMARYKEY primaryValue:phone];
    info = [[DatabaseHandler sharedDatabaseHandler] getUserInfoWithNumberPhone:phone];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(void)updateInfo:(NSDictionary *)data updateAvatar:(UIImage *)img{
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    
    if (img != nil){
        avatar = img;
    }
    else{
        avatar = [[DatabaseHandler sharedDatabaseHandler] downloadAvatarForNumberPhone:numberPhone];
    }
    [[DatabaseHandler sharedDatabaseHandler] uploadAvatar:avatar forNumberPhone:numberPhone];
    
    [[DatabaseHandler sharedDatabaseHandler] updateStringTable:DB_TABLE_USER_INFO data:data primaryKey:DB_TABLE_USER_INFO_PRIMARYKEY primaryValue:numberPhone];
    
    NSString *newPhone = (NSString*)[data objectForKey:DB_DICT_USER_PHONE];
    if (newPhone){
        [[DatabaseHandler sharedDatabaseHandler] renameAvatar:numberPhone newName:newPhone];
        numberPhone = newPhone;
        [self writeToFileNumberPhone:newPhone];
    }
    info = [[DatabaseHandler sharedDatabaseHandler] getUserInfoWithNumberPhone:numberPhone];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(void)updateDataFromServer{
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    info = [[DatabaseHandler sharedDatabaseHandler] getDriverInfoWithNumberPhone:numberPhone];
    avatar = [[DatabaseHandler sharedDatabaseHandler] downloadAvatarForNumberPhone:numberPhone];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(NSDictionary *)getInfo{
    return info;
}

-(BOOL) checkPassword:(NSString *)password{
    NSString *pass = [info objectForKey:DB_DICT_USER_PASS];
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
    avatar = img;
}

-(id) init{
    if (self = [super init]){
        
        avatar = nil;
        
        // check path is exist or not
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:FILE_OF_NAME];
        
        BOOL *isDictionary = malloc(sizeof(BOOL));
        *isDictionary = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:isDictionary] == YES){
            [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
            // get number phone from file.
            numberPhone = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
            
            // get info from database
            info = [[DatabaseHandler sharedDatabaseHandler] getUserInfoWithNumberPhone:numberPhone];
            
            // get avatar from server
            avatar = [[DatabaseHandler sharedDatabaseHandler] downloadAvatarForNumberPhone:numberPhone];
            [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
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
