//
//  CustomAlertView.h
//  Smart Memory+
//
//  Created by Phan Minh Nhựt on 1/27/14.
//  Copyright (c) 2014 Phan Minh Nhựt. All rights reserved.
//

typedef enum CustomAlertViewAnimationShow // animation when show
{
    customAlertViewAnimationShowZoomIn,
    customAlertViewAnimationShowZoomInHorizontal,
    customAlertViewAnimationShowZoomInVertical,
    customAlertViewAnimationShowZoomOut,
    customAlertViewAnimationShowZoomOutHorizontal,
    customAlertViewAnimationShowZoomOutVertical,
    customAlertViewAnimationShowFadeIn,
    customAlertViewAnimationShowFadeLeftToRight,
    customAlertViewAnimationShowFadeRightToLeft,
    customAlertViewAnimationShowFadeTopToBottom,
    customAlertViewAnimationShowFadeBottomToTop,
    customAlertViewAnimationShowNone,
} CustomAlertViewAnimationShow;

typedef enum CustomAlertViewAnimationClose // animation when show
{
    customAlertViewAnimationCloseZoomIn,
    customAlertViewAnimationCloseZoomInHorizontal,
    customAlertViewAnimationCloseZoomInVertical,
    customAlertViewAnimationCloseZoomOut,
    customAlertViewAnimationCloseZoomOutHorizontal,
    customAlertViewAnimationCloseZoomOutVertical,
    customAlertViewAnimationCloseFadeOut,
    customAlertViewAnimationCloseFadeLeftToRight,
    customAlertViewAnimationCloseFadeRightToLeft,
    customAlertViewAnimationCloseFadeTopToBottom,
    customAlertViewAnimationCloseFadeBottomToTop,
    customAlertViewAnimationCloseNone,
} CustomAlertViewAnimationClose;

@class CustomAlertView;

// adopt this protocal if you use button in alert view (initWithTitle:), otherwise you munually create uibutton.
@protocol CustomAlertViewDelegate

@required -(void) customAlertViewButtonClicked:(CustomAlertView*)alertView clickedButtonAtIndex:(NSInteger)indexButton;

@end

#import <UIKit/UIKit.h>

/**
 This class allow you custom you alert view. NOTE: You must edit property "dialogView".
 */
@interface CustomAlertView : UIView <CustomAlertViewDelegate>
{
    float height_dialog;
    CGPoint positionDialogView;
    NSMutableArray *buttonTitles;
    NSMutableArray *arrayButton;
    NSString *title;
    NSString *message;
    UIImageView *background;
}

/**
 Draw (YES) or not draw (NO) separate line between buttons. Default YES.
 */
@property (nonatomic) BOOL hasSeparateLine;
@property (nonatomic,strong) UILabel *label_title; // title of alert view;
@property (nonatomic,strong) UILabel *label_message; // message of alert view;
@property (nonatomic,weak) id<CustomAlertViewDelegate>delegate; // delegate for action of button

/** 
 The dialog of main view (place your ui elements here, use addSubView:). NOTE: Always use dialogView family func to change some properties of dialogview.
*/
@property (nonatomic,strong) UIView *dialogView;

/********************
 ****** DialogView family
 ********************/

/**
 set background for dialog view
 */
-(void) dialogViewSetBackground:(UIImage*)bg alpha:(float)alpha;

/*set frame for dialogView. You must set position other objects manually if frame is changed.
 */
-(void) dialogViewSetFrame:(CGRect)frame;

/**
 Add custom button. Index is the next number. Ex: Current alert view has 2 buttons (index 0,1). If you add new custom button, index of this is 2
 */
-(void) dialogViewAddCustomButton:(UIButton*)button;

//--------------------------------------------- Button

/**
 Get button from title (only use when custom some button). NOTE: This func not working for your custom button, you should use "getButtonFromIndex" instead.
 */
-(UIButton*) getButtonFromTitle:(NSString*)tit;

/**
 Get button of alert view from index
 */
-(UIButton*) getButtonFromIndex:(NSInteger)index;

/**
 Get all button of alertview
 */
-(NSArray*) getAllButtons;

//--------------------------------------------- show and close

/** 
 show alert view at default position
 */
-(void) show;

/** 
 close alert view
 */
-(void) close;

/********************
 ****** For simple alert view
 ********************/

/**
 init Simple alert view and custom it
 */
-(id) initWithTitle:(NSString*)tit message:(NSString*)msg delegate:(id)del buttonTitles:(NSArray*)buttonTit;

@end
