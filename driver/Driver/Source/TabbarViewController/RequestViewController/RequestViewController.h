//
//  RequestViewController.h
//  Driver
//
//  Created by Phan Minh Nhựt on 6/10/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableRequestSource.h"

@interface RequestViewController : UIViewController{
    UITableView *table;
    TableRequestSource *source;
}

@end
