//
//  FeedbackViewController.m
//  User
//
//  Created by Phan Minh Nhut on 4/29/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "FeedbackViewController.h"

#define TEXTVIEW_PLACE_HOLDER @"Nội dung phản hồi"

@implementation FeedbackViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    // Add Menu Button to Navaigation
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[[BarButtonMenu alloc] initWithCurrentViewController:self] getButtonMenu];
    
    // create containView
    containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:containView];
    
    float posX = 20 * RATIOX;
    float posY = 0;
    float width = 280 * RATIOX;
    float deltaHeight = 20 * RATIOY;
    
    // create textfield (Title)
    txtTitle = [[UITextField alloc] initWithFrame:CGRectMake(posX, posY, width, 40 * RATIOY)];
    [txtTitle setBorderStyle:UITextBorderStyleRoundedRect];
    [txtTitle setTextAlignment:NSTextAlignmentLeft];
    [txtTitle setFont:[UIFont fontWithName:LABEL_FONT size:12 * RATIO_TEXT]];
    [txtTitle setTextColor:[UIColor blackColor]];
    [txtTitle setPlaceholder:@"Tiêu đề"];
    [txtTitle setDelegate:self];
    
    // create textView (Feedback)
    posY += txtTitle.frame.size.height + deltaHeight;
    txtFeedback = [[UITextView alloc] initWithFrame:CGRectMake(posX, posY, width, 150 * RATIOY)];
    [txtFeedback.layer setCornerRadius:5.0 * RATIO_TEXT];
    [txtFeedback setTextAlignment:NSTextAlignmentLeft];
    [txtFeedback setFont:[UIFont fontWithName:LABEL_FONT size:12 * RATIO_TEXT]];
    [txtFeedback setTextColor:[UIColor colorWithRed:199/255.0f green:199/255.0f blue:205/255.0f alpha:1.0f]];
    [txtFeedback setText:TEXTVIEW_PLACE_HOLDER];
    [txtFeedback setDelegate:self];
    
    // create button
    width = 60 * RATIOX;
    posX = ([HelperView getSizeScreen].width - width) / 2.0;
    posY += txtFeedback.frame.size.height + deltaHeight;
    CGRect frame = CGRectMake(posX, posY, width, 40 * RATIOY);
    btnSend = [[ButtonApp alloc] initWithFrame:frame title:@"Gửi đi"];
    [btnSend addTarget:self action:@selector(actionBtnSend) forControlEvents:UIControlEventTouchUpInside];
    
    // add subview to containView
    [containView addSubview:txtTitle];
    [containView addSubview:txtFeedback];
    [containView addSubview:btnSend];
    
    // set position of contain view
    float height = btnSend.frame.origin.y + btnSend.frame.size.height;
    posY = 64 + ([HelperView getSizeScreen].height - 64 - self.tabBarController.tabBar.frame.size.height - height) / 2.0;
    frame = CGRectMake(0, posY, 320 * RATIOX, height);
    [containView setFrame:frame];
    
    [self.view setBackgroundColor:BACKGROUND_COLOR_WHITE];
    [containView setBackgroundColor:BACKGROUND_COLOR_WHITE];
}

-(void) actionBtnSend{
    MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
    [vc setToRecipients:@[@"itpropmn07_feedback@hotmail.com"]];
    [vc setSubject:[NSString stringWithFormat:@"Feedback - %@", APP_NAME]];
    NSString *message = [NSString stringWithFormat:@"Tiêu đề: %@\n\nPhản hồi: %@\n\n", txtTitle.text, txtFeedback.text];
    [vc setMessageBody:message isHTML:NO];
    [vc setMailComposeDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

/**
 Delegate of mail
 */
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultSent) // Success
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:APP_NAME message:@"Cám ơn lời phản hồi của bạn." delegate:nil buttonTitles:@[@"Đóng"]];
        [alertView show];
    }
    else if (result == MFMailComposeResultFailed)
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:APP_NAME message:@"Phản hồi của bạn vẫn chưa được gửi đi." delegate:nil buttonTitles:@[@"Đóng"]];
        [alertView show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

/**
 * Delegate of UITextField
 */

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return textField.resignFirstResponder;
}

/**
 * Delegate of UITextView
 */
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:TEXTVIEW_PLACE_HOLDER]){
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]){
        [txtFeedback setTextColor:[UIColor colorWithRed:199/255.0f green:199/255.0f blue:205/255.0f alpha:1.0f]];
        [txtFeedback setText:TEXTVIEW_PLACE_HOLDER];
    }
    return YES;
}

@end
