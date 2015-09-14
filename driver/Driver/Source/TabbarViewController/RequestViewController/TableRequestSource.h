//
//  TableRequestSource.h
//  Driver
//
//  Created by Phan Minh Nhựt on 6/10/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableRequestCell.h"

@interface TableRequestSource : NSObject<UITableViewDataSource,UITableViewDelegate, TableRequestCellDelegate>{
    NSArray *data;
    UITableView *table;
    NSTimer *timer;
    BOOL isThreadProcessing;
}

-(id) initWithTableView:(UITableView*)t;

-(void) updateData;

@end
 