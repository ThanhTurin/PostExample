//
//  TextFieldAccount.m
//  Driver
//
//  Created by Phan Minh Nhut on 4/29/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "TextFieldAccount.h"

#define RATIO_LABEL 0.25
#define RATIO_TEXTFIELD (1 - RATIO_LABEL)
#define TAG_AVARTAR 10
#define TAG_BUTTON_AVARAR 11
#define CORNER_AVATAR 5 * RATIO_TEXT

@implementation TextFieldAccount
@synthesize txtField;

-(UILabel*) createLabelWithCaption:(NSString*)caption{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width * RATIO_LABEL, self.frame.size.height);
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    [lbl setTextColor:[UIColor blackColor]];
    [lbl setTextAlignment:NSTextAlignmentLeft];
    [lbl setFont:[UIFont fontWithName:LABEL_FONT size:13 * RATIO_TEXT]];
    [lbl setText:caption];
    
    [self addSubview:lbl];
    return lbl;
}

-(UITextField*) createTextField{
    CGRect frame = CGRectMake(label.frame.size.width, 0, self.frame.size.width * RATIO_TEXTFIELD, self.frame.size.height);
    UITextField *txtF = [[UITextField alloc] initWithFrame:frame];
    [txtF setBorderStyle:UITextBorderStyleRoundedRect];
    [txtF setTextAlignment:NSTextAlignmentLeft];
    [txtF setFont:[UIFont fontWithName:LABEL_FONT size:12 * RATIO_TEXT]];
    [txtF setTextColor:[UIColor blackColor]];
    [txtF setDelegate:self];
    
    [self addSubview:txtF];
    return txtF;
}

-(UIView*) createAvatar{
   
    CGRect frame = CGRectMake(label.frame.size.width, 0, self.frame.size.height, self.frame.size.height);
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    [containerView.layer setCornerRadius:CORNER_AVATAR];
    [containerView setBackgroundColor:BACKGROUND_COLOR_BLUE];
    
    float size = containerView.frame.size.width - 2*RATIOY;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(RATIOY, RATIOY, size, size)];
    [view.layer setCornerRadius:CORNER_AVATAR];
    [view setBackgroundColor:BACKGROUND_COLOR_WHITE];
    [containerView addSubview:view];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn setTag:TAG_BUTTON_AVARAR];
    [btn setFrame:CGRectMake(0, 0, size, size)];
    [btn addTarget:self action:@selector(actionBtnAvatar) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setCornerRadius:CORNER_AVATAR];
    [view addSubview:btn];
    
    [self addSubview:containerView];
    return view;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *img = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
    if (img == nil){
        img = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [self changeImage:img];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){ // Get image from Photo
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [[HelperView getAppDelegate].window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (buttonIndex == 1){ // get image from Camera
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [[HelperView getAppDelegate].window.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void) actionBtnAvatar{

    UIViewController *rootVC = [HelperView getAppDelegate].window.rootViewController;
    [actionSheet showInView:rootVC.view];
}

-(id)initWithFrame:(CGRect)frame caption:(NSString *)caption type:(TextFieldAccountType)type dataChoosing:(NSArray*)choose forViewController:(UIViewController *)vc{
    
    typeField = type;
    if (self = [super initWithFrame:frame]){
        label = [self createLabelWithCaption:caption];
        if (type == TextFieldAccountTypeText){
            txtField = [self createTextField];
        }
        else if (type == TextFieldAccountTypeTextChoose){
            txtField = [self createTextField];
            [vc.view addSubview:self];
            pick = [[PickViewController alloc] initWithData:choose delegate:self forViewController:vc];
        }
        else if (type == TextFieldAccountTypeTextDOB){
            txtField = [self createTextField];
            pickDate = [[PickDateViewController alloc] initWithType:PickDateViewControllerTypeDOB delegate:self forViewController:vc limitFromToday:NO];
        }
        else if (type == TextFieldAccountTypeAvatar){
            avatarForm = [self createAvatar];
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Bỏ qua" destructiveButtonTitle:nil otherButtonTitles:@"Lấy ảnh từ Photo", @"Chụp bằng camera", nil];
        }
        else if (type == TextFieldAccountTypeTextPassword){
            txtField = [self createTextField];
            txtField.secureTextEntry = YES;
        }
    }
    
    return self;
}

-(void)updateChoosingData:(NSArray *)data{
    [pick updateData:data];
}

-(void)setTextFieldEnable:(BOOL)isEnable{
    [txtField setEnabled:isEnable];
}

-(void)changeText:(NSString *)txt{
    
    if ([txt isKindOfClass:[NSNull class]]){
        txtField.text = @"";
    }
    
    txtField.text = txt;
}

-(NSString *)getText{
    return txtField.text;
}

-(void)changeImage:(UIImage *)img{
    UIImageView *imgV = (UIImageView*)[avatarForm viewWithTag:TAG_AVARTAR];
    
    if (imgV == nil){
        imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, avatarForm.frame.size.width, avatarForm.frame.size.height)];
        imgV.clipsToBounds = YES;
        [imgV setTag:TAG_AVARTAR];
        [imgV.layer setCornerRadius:CORNER_AVATAR];
        [avatarForm addSubview:imgV];
    }
    [imgV setImage:img];
    [avatarForm bringSubviewToFront:[avatarForm viewWithTag:TAG_BUTTON_AVARAR]];
    [[Driver sharedDrivers] updateAvatar:img];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (typeField == TextFieldAccountTypeTextChoose){
        [textField setEnabled:NO];
        
        if ([self.delegate respondsToSelector:@selector(textFieldAccountWillEdit:)]){
            [self.delegate textFieldAccountWillEdit:self];
        }
        [pick show];
    }
    else if (typeField == TextFieldAccountTypeTextDOB){
        [textField setEnabled:NO];
        if (textField.text.length > 0){
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"dd/MM/yyyy"];
            [pickDate setDate:[format dateFromString:txtField.text]];
        }
        [pickDate show];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]){
        [self.delegate textFieldAccountWillEdit:self];
    }
}

-(void)pickerDate:(UIDatePicker *)picker didSelectDate:(NSString *)date{
    [txtField setEnabled:YES];
    [txtField setText:date];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectTitle:(NSString *)title{
    [txtField setEnabled:YES];
    [txtField setText:title];
    if ([self.delegate respondsToSelector:@selector(textFieldAccountPickerDidSelectTitle:)]){
        [self.delegate textFieldAccountPickerDidSelectTitle:title];
    }
}

-(NSInteger)pickerViewSetSelectRowForTheFirstTime:(PickViewController *)pickerView{
    return [pickerView rowForTitle:txtField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return textField.resignFirstResponder;
}

@end
