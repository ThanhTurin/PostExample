//
//  LogInViewController.m
//  Register
//
//  Created by ThanhTurin on 5/25/15.
//  Copyright (c) 2015 ThanhTurin. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

#define RATIO_X [[UIScreen mainScreen] bounds].size.width/320.0f
#define RATIO_Y [[UIScreen mainScreen] bounds].size.height/480.0f
#define RATIOTEXT (2*RATIO_X*RATIO_Y) / (RATIO_X + RATIO_Y)

#define LOGO_NAME @"logo.png"

#define BACKGROUND_COLOR [UIColor colorWithRed:25.0/255.0 green:145.0/255.0 blue:115.0/255.0 alpha:1.0]

/* LABEL */
#define LBL_FONT [UIFont fontWithName:@"Arial" size:12.5*RATIOTEXT]
#define LABEL_BACKGROUND_COLOR [UIColor clearColor]
#define LABEL_TEXT_COLOR [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.0]

/* TEXTFIELD */
#define SDT @"Nhập vào số điện thoại"
#define EMAIL @"Email"
#define RADIUS 3.0
#define TEXTFIELD_FONT [UIFont systemFontOfSize:12*RATIOTEXT]

@interface LogInViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@end

@implementation LogInViewController {
    UITableView *mainView;
    UITextField *phoneNumber;
    UITextField *pass;
}

- (CGRect)newRect :(float)X Y:(float)Y W:(float)W H:(float)H {
    return CGRectMake(X*RATIO_X, Y*RATIO_Y, W*RATIO_X, H*RATIO_Y);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BACKGROUND_COLOR_WHITE];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = [[[BarButtonBack alloc] initWithCurrentViewContrller:self] getButtonBack];
    
    isWaitCode = YES;
    
    [self createLabel:CGRectMake(20, 10, 280, 40) text:@"Nhập số điện thoại và mật khẩu"];
    
    phoneNumber = [self createTextfield:CGRectMake(20, 50, 280, 40)
                                   text:@""];
    [phoneNumber setPlaceholder:@"Nhập số điện thoại"];
    [phoneNumber setKeyboardType:UIKeyboardTypePhonePad];
    
    pass = [self createTextfield:CGRectMake(20, 100, 280, 40)
                            text:@""];
    [pass setKeyboardType:UIKeyboardTypeASCIICapable];
    [pass setPlaceholder:@"Nhập mã xác nhận được gửi qua SMS"];
    [pass setEnabled:NO];
    
    btnLogin = [self createButton:CGRectMake(20, 150, 280, 40)
                radius:2.0*RATIOTEXT
                  func:@selector(action)
                 image:nil
                 color:[UIColor colorWithRed:25.0/255.0 green:145.0/255.0 blue:115.0/255.0 alpha:1.0]
                  text:@"Lấy mã xác nhận"];
    
    [phoneNumber setDelegate:self];
    [pass setDelegate:self];
    // Do any additional setup after loading the view.
}

- (BOOL)isSuccessful {
    return [[Driver sharedDrivers] loginDriverWithCode:pass.text phone:phoneNumber.text];
}

- (void)action {
    
    if (isWaitCode == YES){
        isWaitCode = NO;
        [pass setEnabled:YES];
        [btnLogin setTitle:@"Đăng nhập" forState:UIControlStateNormal];
        
        // Send SMS
    }
    else {
        if ([self isSuccessful]) {
            UITabBarController *toVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarController"];
            [self.navigationController pushViewController:toVC animated:YES];
            [self.navigationController setNavigationBarHidden:YES];
            
        } else {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Đăng nhập không thành công" message:@"Số điện thoại hoặc mật khẩu không chính xác. Xin vui lòng đăng nhập lại." delegate:nil buttonTitles:@[@"Đồng ý"]];
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextField *)createTextfield: (CGRect)frame text:(NSString *)text {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(frame.origin.x * RATIO_X, 64+ frame.origin.y * RATIO_Y, frame.size.width * RATIO_X, frame.size.height * RATIO_Y)];
    [textField setText:text];
    [textField setFont:TEXTFIELD_FONT];
    [[textField layer] setCornerRadius:RADIUS];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [[textField layer] setBorderWidth:0.5*RATIOTEXT];
    [textField setFont:[UIFont systemFontOfSize:14*RATIOTEXT]];
    [textField setTextColor:[UIColor blackColor]];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8 * RATIO_X, frame.size.height * RATIO_Y)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:textField];
    return textField;
}

- (void)createLabel: (CGRect)frame text:(NSString *)text{
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setFrame:CGRectMake(frame.origin.x * RATIO_X, 64 + frame.origin.y * RATIO_Y, frame.size.width * RATIO_X, frame.size.height * RATIO_Y)];
    [lbl setText:text];
    [lbl setFont:LBL_FONT];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:LABEL_TEXT_COLOR];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:lbl];
}

- (UIButton*)createButton:(CGRect)frame radius:(float)radius func:(SEL)selector image:(UIImage *)image color:(UIColor *)color text:(NSString *)text {
    CGRect rect = CGRectMake(frame.origin.x * RATIO_X, 64 + frame.origin.y * RATIO_Y, frame.size.width * RATIO_X, frame.size.height * RATIO_Y);
    if (image != nil)
        rect = CGRectMake(frame.origin.x * RATIO_X, frame.origin.y * RATIO_Y, frame.size.width * RATIO_X, frame.size.height * RATIO_X);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    
    [[btn layer] setCornerRadius:radius];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    if (image != nil)
        [btn setImage:image forState:UIControlStateNormal];
    else
        [btn setBackgroundColor:color];
    
    [btn setTitle:text forState:UIControlStateNormal];
    [[btn titleLabel] setFont:[UIFont systemFontOfSize:14*RATIOTEXT]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    return btn;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:pass]){
        textField.text = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

@end
