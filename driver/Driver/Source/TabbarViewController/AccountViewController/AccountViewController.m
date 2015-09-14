//
//  AccountViewController.m
//  Driver
//
//  Created by Phan Minh Nhut on 4/29/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "AccountViewController.h"

@implementation AccountViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    // Add Menu Button to Navaigation
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[[BarButtonMenu alloc] initWithCurrentViewController:self] getButtonMenu];
    
    containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:containView];
    
    float posY = 0;
    float deltaHeight = 8 * RATIOY;
    float width = 280 * RATIOX;
    float posX = ([HelperView getSizeScreen].width - width) / 2.0;
    float height = 30 * RATIOY;
    
    // Phone
    CGRect frame = CGRectMake(posX, posY, width, height);
    txtPhone = [[TextFieldAccount alloc] initWithFrame:frame caption:@"Điện thoại" type:TextFieldAccountTypeText dataChoosing:nil forViewController:nil];
    [txtPhone.txtField setEnabled:NO];
    
    // Name
    posY += height + deltaHeight;
    frame = CGRectMake(posX, posY, width, height);
    txtName = [[TextFieldAccount alloc] initWithFrame:frame caption:@"Họ tên" type:TextFieldAccountTypeText dataChoosing:nil  forViewController:nil];
    [txtName.txtField setEnabled:NO];
    
    // Name Car
    posY += height + deltaHeight;
    frame = CGRectMake(posX, posY, width, height);
    txtNameCar = [[TextFieldAccount alloc] initWithFrame:frame caption:@"Tên xe" type:TextFieldAccountTypeText dataChoosing:nil  forViewController:nil];
    [txtNameCar.txtField setEnabled:NO];
    
    // NumCar
    posY += height + deltaHeight;
    frame = CGRectMake(posX, posY, width, height);
    txtNumCar = [[TextFieldAccount alloc] initWithFrame:frame caption:@"Biển số xe" type:TextFieldAccountTypeText dataChoosing:nil forViewController:nil];
    [txtNumCar.txtField setEnabled:NO];
    // Number of Seats
    posY += height + deltaHeight;
    frame = CGRectMake(posX, posY, width, height);
    txtSeats = [[TextFieldAccount alloc] initWithFrame:frame caption:@"Số ghế" type:TextFieldAccountTypeText dataChoosing:nil forViewController:nil];
    [txtSeats.txtField setEnabled:NO];
    
    // Company
    posY += height + deltaHeight;
    frame = CGRectMake(posX, posY, width, height);
    txtCompany = [[TextFieldAccount alloc] initWithFrame:frame caption:@"Hãng xe" type:TextFieldAccountTypeText dataChoosing:nil forViewController:nil];
    [txtCompany.txtField setEnabled:NO];
    
    // Avatar
    posY += height + deltaHeight;
    frame = CGRectMake(posX, posY, width, 80 * RATIOX);
    txtAvartar = [[TextFieldAccount alloc] initWithFrame:frame caption:@"Avatar" type:TextFieldAccountTypeAvatar dataChoosing:nil  forViewController:nil];

    // btnSend
    width = 80 * RATIOX;
    posX = ([HelperView getSizeScreen].width - width) / 2.0;
    posY += txtAvartar.frame.size.height + deltaHeight;
    frame = CGRectMake(posX, posY, width, 40 * RATIOY);
    btnSend = [[ButtonApp alloc] initWithFrame:frame title:@"Cập nhật"];
    [btnSend addTarget:self action:@selector(actionBtnSend) forControlEvents:UIControlEventTouchUpInside];
    
    // add subview to containView
    [containView addSubview:txtPhone];
    [containView addSubview:txtNumCar];
    [containView addSubview:txtAvartar];
    [containView addSubview:txtSeats];
    [containView addSubview:txtCompany];
    [containView addSubview:txtName];
    [containView addSubview:txtNameCar];
    [containView addSubview:btnSend];
    
    // set position of containView
    height = btnSend.frame.origin.y + btnSend.frame.size.height;
    posY = 64 + ([HelperView getSizeScreen].height - 64 - self.tabBarController.tabBar.frame.size.height - height) / 2.0;
    frame = CGRectMake(0, posY, 320*RATIOX, height);
    [containView setFrame:frame];
    
    [self.view setBackgroundColor:BACKGROUND_COLOR_WHITE];
    [containView setBackgroundColor:BACKGROUND_COLOR_WHITE];
    
    [self fillInfo];
}

-(void) fillInfo{

    NSDictionary *info = [[Driver sharedDrivers] getInfo];
    
    // phone
    NSString *str = (NSString*)[info objectForKey:DB_DICT_DRIVER_PHONE];
    [txtPhone changeText:str];
    
    // name
    str = (NSString*)[info objectForKey:DB_DICT_DRIVER_NAME];
    [txtName changeText:str];
    
    // Company
    str = (NSString*)[info objectForKey:DB_DICT_DRIVER_COMPANY];
    [txtCompany changeText:str];
    
    // Info Of Car
    NSDictionary *car = [[Driver sharedDrivers] getInfoCar];

    // NameCar
    str = (NSString*)[car objectForKey:DB_DICT_CAR_CAR_MAKER];
    [txtNameCar changeText:str];
    
    // NumCar
    str = (NSString*)[car objectForKey:DB_DICT_CAR_CAR_NUMBER];
    [txtNumCar changeText:str];
    
    // Number of Seats
    str = (NSString*)[car objectForKey:DB_DICT_CAR_CAPACITY];
    [txtSeats changeText:[self appendNumberOfSeat:str]];
    
    // Avatar
    [txtAvartar changeImage:[[Driver sharedDrivers] getAvatar]];
}

-(NSArray*) getAllNameOfCompany{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [[Company sharedCompany] updateDataFromServer];
    NSArray *companys = [[Company sharedCompany] getAllCompanys];
    for (NSDictionary *company in companys){
        NSString *name = (NSString*)[company objectForKey:DB_DICT_COMPANY_NAME];
        [data addObject:name];
    }
    
    return data;
}

// convert from "4" to "Xe 4 chỗ";
-(NSString*) appendNumberOfSeat:(NSString*)seat{
    
    if (seat == nil){
        return nil;
    }
    
    return [NSString stringWithFormat:@"Xe %@ chỗ",seat];
}

// convert from "Xe 4 chỗ" to "4";
-(NSString*) cutNumberOfSeat{
    
    if (txtSeats.getText.length > 0){
        NSMutableString *path = [[[txtSeats.getText mutableCopy] stringByReplacingOccurrencesOfString:@" " withString:@"/"] mutableCopy];
        NSMutableString *pathCut = [[path stringByDeletingLastPathComponent] mutableCopy];
        NSString *seat = [pathCut substringFromIndex:3];
        
        return seat;
    }
    
    return @"";
}

-(void) actionBtnSend{
    
    /*NSString *currentCarID = (NSString*)[[[Driver sharedDrivers] getInfo] objectForKey:DB_DICT_DRIVER_CAR_ID];
    // Update Car
    NSDictionary *info = @{
             DB_DICT_CAR_CAPACITY: [self cutNumberOfSeat],
             DB_DICT_CAR_CAR_MAKER: txtNameCar.getText,
             DB_DICT_CAR_CAR_NUMBER: txtNumCar.getText,
             };
    
    [[Car sharedCar] updateCarForDriverWithPhone:currentCarID info:info];
    [[Car sharedCar] updateCarForDriverWithPhone:currentCarID info:@{DB_DICT_CAR_ID: txtPhone.getText}];
    // Update Driver
    info = @{
            DB_DICT_DRIVER_COMPANY: txtCompany.getText,
            DB_DICT_DRIVER_NAME: txtName.getText,
            DB_DICT_DRIVER_CAR_ID: txtPhone.getText,
                           };
    [[Driver sharedDrivers] updateInfo:@{DB_DICT_DRIVER_PHONE: txtPhone.getText} updateAvatar:nil];*/
    [[Driver sharedDrivers] updateInfo:nil updateAvatar:[[Driver sharedDrivers] getAvatar]];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
