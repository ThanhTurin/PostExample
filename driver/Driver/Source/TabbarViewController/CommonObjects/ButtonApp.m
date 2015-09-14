//
//  ButtonBook.m
//  User
//
//  Created by Phan Minh Nhut on 4/29/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "ButtonApp.h"

@implementation ButtonApp

-(id)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    if (self = [super initWithFrame:frame]){
        
        [self setBackgroundColor:BACKGROUND_COLOR_BLUE];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [self.titleLabel setFont:[UIFont fontWithName:LABEL_FONT size:15 * RATIO_TEXT]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setShadowColor:[UIColor blackColor]];
        [self.titleLabel setShadowOffset:CGSizeMake(0, 1 * RATIOY)];
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, 1 * RATIO_TEXT);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 1.0f * RATIO_TEXT;
        
        self.layer.cornerRadius = 5.0 * RATIO_TEXT;
    }
    
    return self;
}

@end
