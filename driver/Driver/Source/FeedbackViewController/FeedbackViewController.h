//
//  FeedbackViewController.h
//  User
//
//  Created by Phan Minh Nhut on 4/29/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonApp.h"
#import <MessageUI/MessageUI.h>

@interface FeedbackViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate>{
    
    UIView *containView;
    UITextField *txtTitle;
    UITextView *txtFeedback;
    ButtonApp *btnSend;
}

@end
