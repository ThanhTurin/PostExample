//
//  TableDelegateMenu.m
//  Driver
//
//  Created by Phan Minh Nhut on 4/30/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "TableDelegateMenu.h"
#import "TableSectionInfo.h"
#import "AppViewController.h"
#import "AboutUSViewController.h"
#import "SupportViewController.h"

#define NUMBER_OF_SECTIONS 2
#define SECTION_INFO 0
#define SECTION_ABOUT 1

#define NUMBER_OF_ROWS_INFO 0
#define NUMBER_OF_ROWS_ABOUT 3

#define HEIGHT_HEADER_INFO 70 * RATIOY
#define HEIGHT_HEADER_ABOUT 30 * RATIOY
#define HEIGHT_FOOTER HEIGHT_HEADER_ABOUT
#define HEIGHT_ROW 30*RATIOY;

#define COLOR_SECTION [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1]
#define COLOR_ROW [UIColor colorWithRed:41/255.0 green:41/255.0 blue:41/255.0 alpha:1]

#define LIMIT_X 20 * RATIOX

@implementation TableDelegateMenu

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUMBER_OF_SECTIONS;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == SECTION_INFO){
        return NUMBER_OF_ROWS_INFO;
    }
    else if (section == SECTION_ABOUT){
        return NUMBER_OF_ROWS_ABOUT;
    }
    
    return -1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == SECTION_INFO){
        return HEIGHT_HEADER_INFO;
    }
    else if (section == SECTION_ABOUT){
        return HEIGHT_HEADER_ABOUT;
    }
    
    return -1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_ROW;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == SECTION_INFO){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*RATIOX, HEIGHT_HEADER_INFO)];
        [view setBackgroundColor:COLOR_SECTION];
        
        float height = HEIGHT_HEADER_INFO - 20 * RATIOY;
        float posY = (HEIGHT_HEADER_INFO - height) /2.0;
        NSDictionary *driver = [[Driver sharedDrivers] getInfo];
        NSString *name = (NSString*)[driver objectForKey:DB_DICT_DRIVER_NAME];
        NSString *phone = (NSString*)[driver objectForKey:DB_DICT_DRIVER_PHONE];
        
        TableSectionInfo *info = [[TableSectionInfo alloc] initWithFrame:CGRectMake(LIMIT_X, posY, 320*RATIOX - LIMIT_X, height) username:name numberPhone:phone];
        [info updateAvartar:[[Driver sharedDrivers] getAvatar]];
        [info setBackgroundColor: COLOR_SECTION];
        [view addSubview:info];
        
        return view;
    }
    else if (section == SECTION_ABOUT){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*RATIOX, HEIGHT_HEADER_ABOUT)];
        [view setBackgroundColor:COLOR_SECTION];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LIMIT_X, 0, 320 * RATIOX - LIMIT_X, HEIGHT_HEADER_ABOUT)];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setFont:[UIFont fontWithName:LABEL_FONT size:14 * RATIO_TEXT]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:@"Giới thiệu"];
        [view addSubview:label];
        
        return view;
    }
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320*RATIOX, HEIGHT_HEADER_ABOUT)];
    [view setBackgroundColor:COLOR_SECTION];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == NUMBER_OF_SECTIONS - 1){
        return HEIGHT_FOOTER;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *vc = [HelperView getAppDelegate].window.rootViewController;
    
    if (indexPath.section == SECTION_ABOUT){
        if (indexPath.row == 0){
            AppViewController *toVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"APP"];
            [parentVC.navigationController pushViewController:toVC animated:YES];
        }
        else if (indexPath.row == 1){
            AboutUSViewController *toVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"ABOUTUS"];
            [parentVC.navigationController pushViewController:toVC animated:YES];
        }
        else if (indexPath.row == 2){
            SupportViewController *toVC = [vc.storyboard instantiateViewControllerWithIdentifier:@"SUPPORT"];
            [parentVC.navigationController pushViewController:toVC animated:YES];
        }
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell.textLabel setFont:[UIFont fontWithName:LABEL_FONT size:10 * RATIO_TEXT]];
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:COLOR_ROW];
    }
    
    
    NSString *str = @"";
    if (indexPath.section == SECTION_ABOUT){
        if (indexPath.row == 0){
            str = @"Về ứng dụng";
        }
        else if (indexPath.row == 1){
            str = @"Về chúng tôi";
        }
        else if (indexPath.row == 2){
            str = @"Hỗ trợ";
        }
        
    }
    [cell.textLabel setText:str];

    return cell;
}

-(id)initWithParent:(UIViewController *)vc{
    if (self = [super init]){
        parentVC = vc;
    }
    
    return self;
}

@end
