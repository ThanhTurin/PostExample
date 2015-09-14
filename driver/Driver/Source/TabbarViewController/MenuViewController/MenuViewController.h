//
//  MenuViewController.h
//  User
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableDelegateMenu.h"

@interface MenuViewController : UIViewController{
    UITableView *table;
    TableDelegateMenu *delegateTable;
}

@end
