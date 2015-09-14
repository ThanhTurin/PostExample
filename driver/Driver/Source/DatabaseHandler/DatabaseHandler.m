//
//  DatabaseHandler.m
//  User
//
//  Created by Phan Minh Nhut on 5/1/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "DatabaseHandler.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation DatabaseHandler
static DatabaseHandler *sharedDatabaseHandler = nil;

+(DatabaseHandler *)sharedDatabaseHandler{
    if (sharedDatabaseHandler == nil){
        sharedDatabaseHandler = [[DatabaseHandler alloc] init];
    }
    
    return sharedDatabaseHandler;
}

-(void) showWaitingViewNewThread{
   
    if (isShowWait == NO){
        [[HelperView getAppDelegate].window.rootViewController.view addSubview:waitingView];
        [[HelperView getAppDelegate].window.rootViewController.view bringSubviewToFront:waitingView];
        isShowWait = YES;
    }
}

-(void) showWaitingView{
    [NSThread detachNewThreadSelector:@selector(showWaitingViewNewThread) toTarget:self withObject:nil];
}

-(void) hideWaitingView{
    
    if (isShowWait == YES){
        [waitingView removeFromSuperview];
        isShowWait = NO;
        NSLog(@"Close");
    }
//    NSLog(@"Close");
}

-(NSDictionary*) getCompanyWithName:(NSString*)name{
    
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'",DB_TABLE_COMPANY_INFO_PRIMARYKEY, name];
    NSString *path = [NSString stringWithFormat:@"%@/selectCompany.php?%@&where=%@",ADDR_LOCALHOST,LOGIN_INFO_PARAM,[self replaceSpaceByPercent20:where]];
    return (NSDictionary*)[[self getJSONResultFromPath:path] firstObject];
}

-(NSDictionary*) getCarInfoWithID:(NSString*)ID{
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'",DB_TABLE_CAR_INFO_PRIMARYKEY, ID];
    NSString *path = [NSString stringWithFormat:@"%@/selectCar.php?%@&where=%@",ADDR_LOCALHOST,LOGIN_INFO_PARAM,[self replaceSpaceByPercent20:where]];
    return (NSDictionary*)[[self getJSONResultFromPath:path] firstObject];
}

-(NSDictionary*) getTourInfoWithID:(NSString*)ID{
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'",DB_TABLE_TOUR_INFO_PRIMARYKEY, ID];
    NSString *path = [NSString stringWithFormat:@"%@/selectTour.php?%@&where=%@",ADDR_LOCALHOST,LOGIN_INFO_PARAM,[self replaceSpaceByPercent20:where]];
    return (NSDictionary*)[[self getJSONResultFromPath:path] firstObject];
}

-(NSDictionary*) getDriverInfoWithNumberPhone:(NSString*)phone{
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'",DB_TABLE_DRIVER_INFO_PRIMARYKEY, phone];
    NSString *path = [NSString stringWithFormat:@"%@/selectDriver.php?%@&where=%@",ADDR_LOCALHOST,LOGIN_INFO_PARAM,[self replaceSpaceByPercent20:where]];
    return (NSDictionary*)[[self getJSONResultFromPath:path] firstObject];
}

-(NSDictionary *) getUserInfoWithNumberPhone:(NSString *)phone{
    
    NSString *where = [NSString stringWithFormat:@"%@ = '%@'",DB_TABLE_USER_INFO_PRIMARYKEY, phone];
    NSString *path = [NSString stringWithFormat:@"%@/selectUser.php?%@&where=%@",ADDR_LOCALHOST,LOGIN_INFO_PARAM,[self replaceSpaceByPercent20:where]];
    return (NSDictionary*)[[self getJSONResultFromPath:path] firstObject];
}

-(NSArray*) getInfoFromTable:(NSString*)table withCondition:(NSString*)where{
    NSString *phpFile = @"";
    if ([table isEqualToString:DB_TABLE_USER_INFO]){
        phpFile = @"selectUser.php";
    }
    else if ([table isEqualToString:DB_TABLE_DRIVER_INFO]){
        phpFile = @"selectDriver.php";
    }
    else if ([table isEqualToString:DB_TABLE_COMPANY_INFO]){
        phpFile = @"selectCompany.php";
    }
    else if ([table isEqualToString:DB_TABLE_CAR_INFO]){
        phpFile = @"selectCar.php";
    }
    else if ([table isEqualToString:DB_TABLE_TOUR_INFO]){
        phpFile = @"selectTour.php";
    }
    else if ([table isEqualToString:DB_TABLE_BOOK_INFO]){
        phpFile = @"selectBook.php";
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@?%@&where=%@",ADDR_LOCALHOST, phpFile,LOGIN_INFO_PARAM,[self replaceSpaceByPercent20:where]];
    return [self getJSONResultFromPath:path];
}

-(NSArray *)getAllInfoFromTable:(NSString *)table{
    NSString *phpFile = @"";
    if ([table isEqualToString:DB_TABLE_USER_INFO]){
        phpFile = @"selectUserNoCondition.php";
    }
    else if ([table isEqualToString:DB_TABLE_DRIVER_INFO]){
        phpFile = @"selectDriverNoCondition.php";
    }
    else if ([table isEqualToString:DB_TABLE_COMPANY_INFO]){
        phpFile = @"selectCompanyNoCondition.php";
    }
    else if ([table isEqualToString:DB_TABLE_CAR_INFO]){
        phpFile = @"selectCarNoCondition.php";
    }
    else if ([table isEqualToString:DB_TABLE_TOUR_INFO]){
        phpFile = @"selectTourNoCondition.php";
    }
    else if ([table isEqualToString:DB_TABLE_BOOK_INFO]){
        phpFile = @"selectBookNoCondition.php";
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@?%@",ADDR_LOCALHOST, phpFile,LOGIN_INFO_PARAM];
    return [self getJSONResultFromPath:path];
}

-(void) deleteTable:(NSString*)table primaryKey:(NSString*)primary keyValue:(NSString*)v{
    
    NSString *value = [self replaceSpaceByPercent20:v];
    
    NSString *path = [NSString stringWithFormat:@"%@/delete.php?table=%@&primarykey=%@&keyvalue=%@&%@",ADDR_LOCALHOST, table,primary, value, LOGIN_INFO_PARAM];
    [self executeURL:path];
}

-(void)updateStringTable:(NSString *)table data:(NSDictionary *)data primaryKey:(NSString *)pk primaryValue:(NSString *)value{

    NSString *pValue = [self replaceSpaceByPercent20:value];
    NSMutableString *update = [@"" mutableCopy];
    
    for (NSString *key in data.allKeys){
        
        NSString *value = (NSString*)[data objectForKey:key];
        NSString *cmd = [NSString stringWithFormat:@"%@='%@',",key,value];
        [update appendString:cmd];
    }
    NSString *optUpdate = [update substringWithRange:NSMakeRange(0, update.length-1)];
    NSString *URLString = [optUpdate stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URLString: %@",URLString);
    NSString *path = [NSString stringWithFormat:@"%@/update.php?table=%@&update=%@&primarykey=%@&keyvalue=%@&%@",ADDR_LOCALHOST,table,URLString,pk,pValue,LOGIN_INFO_PARAM];
    [self executeURL:path];
}

-(void)insertStringTable:(NSString *)table data:(NSDictionary *)data primaryKey:(NSString *)pk primaryValue:(NSString *)value{

    NSMutableString *column = [pk mutableCopy];
    NSMutableString *values = [NSMutableString stringWithFormat:@"'%@'",value];
    
    for (NSString *key in data.allKeys){
        if ([key isEqualToString:pk] == NO){
            NSString *value = (NSString*)[data objectForKey:key];
            [column appendFormat:@",%@",key];
            [values appendFormat:@",'%@'",value];
        }
    }
    NSString *URLString = [values stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"URLString: %@",URLString);
    NSString *path = [NSString stringWithFormat:@"%@/insert.php?table=%@&column=%@&value=%@&%@",ADDR_LOCALHOST,table,[self replaceSpaceByPercent20:column],URLString,LOGIN_INFO_PARAM];
    [self executeURL:path];
}

-(void)renameAvatar:(NSString *)oldName newName:(NSString *)newName{
    NSString *path = [NSString stringWithFormat:@"%@/renameAvatar.php?old_name=%@&new_name=%@",ADDR_LOCALHOST,oldName,newName];
    [self executeURL:path];
}

/**
 Return an array of NSDictionary
 */
-(NSArray*) getJSONResultFromPath:(NSString*)path{
    NSLog(@"Path: %@",path);
    
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data != nil){
        NSError *error;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error){
            NSLog(@"Database JSON: Error: %@",error);
        }
        else{
            return json;
        }
    }
    
    return nil;
}

-(NSString*) executeURL:(NSString*)url{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *getStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self printLog:getStr];
    
    return getStr;
}

-(void) uploadAvatar:(UIImage *)avatar forNumberPhone:(NSString*)phone{
    NSData *imageData = UIImageJPEGRepresentation(avatar, 90);
    // setting up the URL to post to
    NSString *urlString = [NSString stringWithFormat:@"%@/upload.php",ADDR_LOCALHOST];
    
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    /*
     add some header info now
     we always need a boundary when we post a file
     also we need to set the content type
     
     You might want to generate a random boundary.. this is just the same
     as my output from wireshark on a valid html post
     */
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    /*
     now lets create the body of the post
     */
    NSMutableData *body = [NSMutableData data];
    NSString *str = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",phone];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",returnString);
}

-(UIImage*) downloadAvatarForNumberPhone:(NSString*)phone{
    NSString *stringURL = [NSString stringWithFormat:@"%@/Avatar/%@",ADDR_LOCALHOST,phone];
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,phone];
        [urlData writeToFile:filePath atomically:YES];
        UIImage *img = [UIImage imageWithData:urlData];
        return img;
    }
    
    return nil;
}

-(void) printLog:(NSString*)log{
    NSLog(@"Database: %@",log);
}

-(NSString*) replaceSpaceByPercent20:(NSString*)str{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
}

-(id) init{
    
    if (self = [super init]){
        isShowWait = NO;
        waitingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320 * RATIOX, 480 * RATIOY)];
        [waitingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 320*RATIOX, 480 * RATIOY)];
        [waitingView addSubview:indicator];
        [indicator startAnimating];
    }
    
    return self;
}

@end
