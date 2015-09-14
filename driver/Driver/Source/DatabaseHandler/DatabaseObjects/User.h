//
//  User.h
//  User
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    NSDictionary *info;
    NSString *numberPhone;
    UIImage *avatar;
}

/**
 Always use this func to get instance of class User (Singletone)
 */
+(User*) sharedUsers;

/**
 Send info of user to database server. This func also writes the phone to file.
 */
-(void) registerNumberPhone:(NSString*)phone info:(NSDictionary*)data;

/**
 Check @param "password" equal to user's password or not.
 RETURN: YES if two password are matched.
 */
-(BOOL) checkPassword:(NSString*)password;

/**
 Update info of user and also update it on database server. If @param data or img is nil, this func will update latest info from database (equal to "updateDataFromServer").
 */
-(void) updateInfo:(NSDictionary*)data updateAvatar:(UIImage*) img;

/**
 Update latest info from server.
 */
-(void) updateDataFromServer;

/**
 Get info of user
 */
-(NSDictionary*) getInfo;

/**
 Get Avatar of user
 */
-(UIImage*) getAvatar;

/**
 Update avatar. This func does not upload to database.
 */
-(void) updateAvatar:(UIImage*)img;

@end
