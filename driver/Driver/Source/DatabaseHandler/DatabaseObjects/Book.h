//
//  Book.h
//  User
//
//  Created by Phan Minh Nhut on 5/18/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

/**
 Always use this func to get instance of class Book
 */
+(Book*) sharedBook;

/**
 Send your book to server. This func also create ID automatically
 */
-(void) sendBookWithData:(NSDictionary*)data;
/**
 Get all book today
 */
-(NSArray*) getAllBookToday;

@end
