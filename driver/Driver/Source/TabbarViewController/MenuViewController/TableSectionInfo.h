//
//  TableSectionInfo.h
//  User
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableSectionInfo : UIView{
    UIView *avatar;
    UILabel *label;
    UIImageView *imgView;
}

/**
 Always use this func to create
 */
-(id) initWithFrame:(CGRect)frame username:(NSString*)name numberPhone:(NSString*)phone;

/**
 Update Avatar
 */
-(void) updateAvartar:(UIImage*)img;

@end
