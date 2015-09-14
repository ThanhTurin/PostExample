//
//  TableRequestSource.m
//  Driver
//
//  Created by Phan Minh Nhựt on 6/10/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "TableRequestSource.h"
#import "TableRequestCell.h"
#import "Book.h"

@implementation TableRequestSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TABLE_REQUEST_HEIGHT_CELL;
}

-(BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableRequestCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[TableRequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setDelegate:self];
    }
    
    NSDictionary *book = [data objectAtIndex:indexPath.row];
    cell.ID = (NSString*)[book objectForKey:DB_DICT_BOOK_ID];
    cell.numberPhone = (NSString*)[book objectForKey:DB_DICT_BOOK_CUSTOMER_PHONE];
    
    [cell updateLabelType:labelRequestTypeDate section:@"Ngày đi" content:(NSString*)[book objectForKey:DB_DICT_BOOK_DATE_GO]];
    [cell updateLabelType:labelRequestTypeFromLocation section:@"Điểm đón" content:(NSString*)[book objectForKey:DB_DICT_BOOK_FROM_LOCATION]];
    [cell updateLabelType:labelRequestTypeToLocation section:@"Điểm đến" content:(NSString*)[book objectForKey:DB_DICT_BOOK_TO_LOCATION]];
    [cell updateLabelType:labelRequestTypePhone section:@"Số điện thoại" content:(NSString*)[book objectForKey:DB_DICT_BOOK_CUSTOMER_PHONE]];
    [cell updateLabelType:labelRequestTypeSeat section:@"Số chỗ ngồi" content:(NSString*)[book objectForKey:DB_DICT_BOOK_SEATS]];
    
    return cell;
}

-(void)needUpdateTable{
    [self updateData];
}

-(void) updateData{
    data = [[Book sharedBook] getAllBookToday];
    [table reloadData];
    if (isThreadProcessing == YES){
        isThreadProcessing = NO;
    }
    NSLog(@"Update Data");
}

-(void) updatePerMinutes{
    if (isThreadProcessing == NO){
        isThreadProcessing = YES;
        [NSThread detachNewThreadSelector:@selector(updateData) toTarget:self withObject:nil];
    }
}

-(id) initWithTableView:(UITableView *)t{
    if (self = [super init]){
        [t setDelegate:self];
        [t setDataSource:self];
        table = t;
        [self updateData];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2*60 target:self selector:@selector(updatePerMinutes) userInfo:nil repeats:YES];
        isThreadProcessing = NO;
    }
    
    return self;
}

@end
