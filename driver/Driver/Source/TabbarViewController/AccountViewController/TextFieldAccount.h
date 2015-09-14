//
//  TextFieldAccount.h
//  User
//
//  Created by Phan Minh Nhut on 4/29/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickDateViewController.h"
#import "PickViewController.h"

typedef enum{
    TextFieldAccountTypeText,
    TextFieldAccountTypeTextChoose,
    TextFieldAccountTypeTextDOB,
    TextFieldAccountTypeTextPassword,
    TextFieldAccountTypeAvatar,
    
} TextFieldAccountType;

@class TextFieldAccount;

@protocol TextFieldAccountDelegate <NSObject>

@optional -(void) textFieldAccountPickerDidSelectTitle:(NSString*)title;
@optional -(void) textFieldAccountWillEdit:(TextFieldAccount*)txtField;
@optional -(void) textFieldAccountEndEdit:(TextFieldAccount*)txtField;

@end

@interface TextFieldAccount : UIView<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PickDateViewControllerDelegate, PickViewControllerDelegate, UIActionSheetDelegate>{
    UILabel *label;
    UIView *avatarForm;
    PickDateViewController *pickDate;
    PickViewController *pick;
    TextFieldAccountType typeField;
    UIImagePickerController *imagePicker;
    UIActionSheet *actionSheet;
}

/**
 Use to get event of TextFiledAccount, only use for "TextFieldAccountTypeTextChoose"
 */
@property (nonatomic,weak) id<TextFieldAccountDelegate> delegate;
@property (nonatomic, strong) UITextField *txtField;
/**
 Always use this func to create an instance. This func does not add instance to subview of @param vc. And @param vc only use for type "TextFieldAccountTypeTextChoose" & "TextFieldAccountTypeTextDOB", for other type, vc can be nil. @param "choose" only uses for "TextFieldAccountTypeTextChoose", this param is array of string for pickviewController.
 */
-(id)initWithFrame:(CGRect)frame caption:(NSString *)caption type:(TextFieldAccountType)type dataChoosing:(NSArray*)choose forViewController:(UIViewController *)vc;

/**
 Always use this func to change text (use for type "TextFieldAccountTypeText")
 */
-(void) changeText:(NSString*)txt;

/**
 Always use this func to get text (use for type "TextFieldAccountTypeText")
 */
-(NSString*) getText;

/**
 Use this func to get image for button (use for type "TextFieldAccountTypeAvatar")
 */
-(void) changeImage:(UIImage*)img;

/**
 Enable or Disable for textfield.
 */
-(void) setTextFieldEnable:(BOOL)isEnable;

/**
 @param "data" is array of string for pickviewController.
 */
-(void) updateChoosingData:(NSArray*)data;

@end
