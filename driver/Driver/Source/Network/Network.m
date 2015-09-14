//
//  Network.m
//  User
//
//  Created by Phan Minh Nhut on 5/6/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "Network.h"

@implementation Network
static Network *sharedNetwork = nil;

+(Network *)sharedNetwork{
    if (sharedNetwork == nil){
        sharedNetwork = [[Network alloc] init];
    }
    
    return sharedNetwork;
}

-(NSString *)getIPAddressOfThisDevice{
    UIDevice *currentDevice = [UIDevice currentDevice];
    if ([currentDevice.model rangeOfString:@"Simulator"].location == NSNotFound) {
        NSString *url = [NSString stringWithFormat:@"%@/getIPAddress.php",ADDR_LOCALHOST];
        return [self executeURL:url];
    } else {
        NSString *ip = [NSString stringWithFormat:@"%@.local",NAME_OF_YOUR_LAPTOP];
        [self printLog:ip];
        return ip;
    }
}

-(NSArray *)getDriverNearByLongitude:(float)longitude latitude:(float)latitude{
    NSString *url = [NSString stringWithFormat:@"%@/requestAllDriverNearBy.php?longitude=%f&latitude=%f&%@",ADDR_LOCALHOST,longitude,latitude,LOGIN_INFO_PARAM];
    NSString *result = [self executeURL:url];
    NSArray *idDrivers = [self getArrayFromResult:result];
    NSMutableArray *lstDriver = [[NSMutableArray alloc] init];
    for (NSString *ID in idDrivers){
        NSDictionary *driver = [[DatabaseHandler sharedDatabaseHandler] getDriverInfoWithNumberPhone:ID];
        [lstDriver addObject:driver];
    }
    
    return lstDriver;
}

-(NSArray *)getDriverNearByLongitude:(float)longitude latitude:(float)latitude numberSeat:(int)num{
    
    NSString *url = [NSString stringWithFormat:@"%@/requestAllDriverNearByAndSeat.php?longitude=%f&latitude=%f&numseat=%i&%@",ADDR_LOCALHOST,longitude,latitude,num,LOGIN_INFO_PARAM];
    NSString *result = [self executeURL:url];
    NSArray *idDrivers = [self getArrayFromResult:result];
    NSMutableArray *lstDriver = [[NSMutableArray alloc] init];
    for (NSString *ID in idDrivers){
        NSDictionary *driver = [[DatabaseHandler sharedDatabaseHandler] getDriverInfoWithNumberPhone:ID];
        [lstDriver addObject:driver];
    }
    
    return lstDriver;
}

-(NSString *)readInfoFromServer:(ServerInfoType)type{
    
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    NSString *filename = @"";
    if (type == ServerInfoTypeAbout){
        filename = @"About.txt";
    }
    else if (type == ServerInfoTypeSupport){
        filename = @"Support.txt";
    }
    else if (type == ServerInfoTypeApp){
        filename = @"AppDriver.txt";
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/readTextFromFile.php?filename=%@&%@",ADDR_LOCALHOST,filename,LOGIN_INFO_PARAM];
    NSString *result = [self executeURL:url];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
    
    return result;
}

/***********
 ** PRIVATE FUNCTION
 **********/

-(NSString*) executeURL:(NSString*)url{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *getStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self printLog:getStr];
    
    return getStr;
}

/**
 This func analyze "result" (type: str1/str2/str3/) and add str1,str2,str3,... to NSArray.
 */
-(NSArray*) getArrayFromResult:(NSString*)result{
    // get array
    NSMutableArray *array = [[NSMutableArray alloc] init];
    BOOL first = YES;
    while ([result isEqualToString:@""] == NO) {
        NSString *strNext = [result stringByDeletingLastPathComponent];
        
        if ([strNext isEqualToString:@""]){
            
            if (first == YES){
                first = NO;
                [array addObject:[result substringToIndex:result.length-1]];
            }
            else{
                [array addObject:result];
            }
        }
        else{
            NSString *element;
            
            if (first == NO){
                element = [result substringFromIndex:strNext.length+1];
            }
            else{
                first = NO;
                NSString *str = [result substringFromIndex:strNext.length+1];
                element = [str substringToIndex:str.length-1];
            }
            [array addObject:element];
        }
        result = strNext;
    }
    
    return array;
}

-(void) printLog:(NSString*)log{
    NSLog(@"Network: %@",log);
}

@end
