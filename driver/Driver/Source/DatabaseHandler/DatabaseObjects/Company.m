//
//  Company.m
//  User
//
//  Created by Phan Minh Nhut on 5/5/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "Company.h"

@implementation Company
static Company *sharedCompany = nil;

+(Company *)sharedCompany{
    if (sharedCompany == nil){
        sharedCompany = [[Company alloc] init];
    }
    
    return sharedCompany;
}

-(NSDictionary *)getInfoOfCompanyWithName:(NSString *)name{
    
    for (NSDictionary *company in companys){
        
        NSString *companyName = (NSString*)[company objectForKey:DB_DICT_COMPANY_NAME];
        if ([companyName isEqualToString:name]){
            return company;
        }
    }
    
    return nil;
}

-(NSArray *)getAllCompanys{
    return companys;
}

-(void)updateDataFromServer{
    [[DatabaseHandler sharedDatabaseHandler] showWaitingView];
    companys = [[DatabaseHandler sharedDatabaseHandler] getAllInfoFromTable:DB_TABLE_COMPANY_INFO];
    [[DatabaseHandler sharedDatabaseHandler] hideWaitingView];
}

-(NSString*) reverseString:(NSString*)str{
    NSString *reverse = @"";
    for (int i = 0; i<str.length; i++){
        reverse = [NSString stringWithFormat:@"%c%@",[str characterAtIndex:i],reverse];
    }
    
    return reverse;
}

-(NSString *)convertPrice:(NSString *)price{
    NSMutableString *reverse = [[self reverseString:price] mutableCopy];
    
    int index = 0;
    while (true) {
        index += 3;
        if (index < reverse.length){
            [reverse insertString:@"." atIndex:index];
            index++;
        }
        else{
            break;
        }
    }
    
    return [self reverseString:reverse];
}

-(id) init{
    
    if (self = [super init]){
        [self updateDataFromServer];
    }
    
    return self;
}

@end
