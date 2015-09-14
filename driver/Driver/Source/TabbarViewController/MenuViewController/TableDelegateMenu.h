//
//  TableDelegateMenu.h
//  User
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableDelegateMenu : NSObject<UITableViewDataSource, UITableViewDelegate>{
    UIViewController *parentVC;
    NSDictionary *data;
}

-(id) initWithParent:(UIViewController*)vc;

@end
