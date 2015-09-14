//
//  SlashScreen.m
//  EndUser
//
//  Created by ThanhTurin on 4/28/15.
//  Copyright (c) 2015 ThanhTurin. All rights reserved.
//

#import "SlashScreenViewController.h"

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

#define LOGO_NAME @"logo.png"

#define HELLO @"Cảm ơn quý khách đã sử dụng dịch vụ"
#define SLOGAN @"Slogan"

#define BACKGROUND_COLOR [UIColor colorWithRed:25.0/255.0 green:145.0/255.0 blue:115.0/255.0 alpha:1.0]

#define LABEL_BACKGROUND_COLOR [UIColor clearColor]
#define LABEL_TEXT_COLOR [UIColor whiteColor]
#define LBL_FONT [UIFont systemFontOfSize:12*RATIO_TEXT]

#define TIME_DELAY 0.0f

@interface SlashScreenViewController ()

@end

@implementation SlashScreenViewController {
    UIViewController *viewController;
    UIImageView *logo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    self.navigationController.navigationBarHidden = YES;
    [self createLabel:CGRectMake(WIDTH*0.0, HEIGHT*0.1, WIDTH, HEIGHT*0.1) text:HELLO];
    [self createLabel:CGRectMake(WIDTH*0.0, HEIGHT*0.5, WIDTH, HEIGHT*0.1) text:SLOGAN];
    [self createImage:CGRectMake(WIDTH*0.3, HEIGHT*0.2, WIDTH*0.4, WIDTH*0.2) name:LOGO_NAME];
    
    [self performSelector:@selector(changeScreen)
               withObject:nil afterDelay:TIME_DELAY];
}

- (void)changeScreen {
    
    // get driver info at startup
    [Driver sharedDrivers];
    
    NSString *str;
    if ([[Driver sharedDrivers] getInfo] == nil){
        str = @"LOGIN";
    }
    else{
        str = @"TabbarController";
    }
    
    viewController = [self.storyboard instantiateViewControllerWithIdentifier:str];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)createLabel: (CGRect)frame text:(NSString *)text {
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setFrame:frame];
    [lbl setText:text];
    [lbl setFont:LBL_FONT];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:LABEL_TEXT_COLOR];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:lbl];
}

- (void)createImage: (CGRect)frame name:(NSString *)name {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [img setFrame:frame];
    [self.view addSubview:img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
