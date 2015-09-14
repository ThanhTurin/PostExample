//
//  CustomAlertView.m
//  Smart Memory+
//
//  Created by Phan Minh Nhựt on 1/27/14.
//  Copyright (c) 2014 Phan Minh Nhựt. All rights reserved.
//

#import "CustomAlertView.h"
#import "AppDelegate.h"

// size of dialogView
#define CUSTOM_ALERT_VIEW_DIALOGVIEW_WIDTH 280.0f
#define CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_WIDTH 20.0f
#define CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_HEIGHT 10.0f

// Button
#define CUSTOM_ALERT_VIEW_BUTTON_HEIGHT 40.0f

// Corner radius
#define CUSTOM_ALERT_VIEW_CORNER_RAIUS 10.0f

// effect (only use for main view's background (self), don't use dialogView)
// @property "dialogView" always start at 0.0f -> 1.0f 
#define CUSTOM_ALERT_VIEW_EFFECT_ALPHA_BEGIN 0.0f
#define CUSTOM_ALERT_VIEW_EFFECT_ALPHA_END 0.3f

// line separate (button
#define CUSTOM_ALERT_VIEW_TAG_SEPARATE_LINE 100

@implementation CustomAlertView
@synthesize dialogView;
@synthesize delegate;
@synthesize label_title,label_message;
@synthesize hasSeparateLine;

/********************
 ****** init
 ********************/

// init default
-(void) defaultCustomAlertView
{
    // set main view (self)
    CGRect frameScreen = [[UIScreen mainScreen] bounds];
    self.frame = CGRectMake(0, 0, frameScreen.size.width, frameScreen.size.height);
    [self setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    // set dialogView
    dialogView = [[UIView alloc] init];
    positionDialogView = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    [self addSubview:dialogView];
}

// init CustomAlertView
-(id) initWithTitle:(NSString*)tit message:(NSString*)msg delegate:(id<CustomAlertViewDelegate>)del buttonTitles:(NSArray*)buttonTit
{
    if (self = [super init])
    {
        self->height_dialog = CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_HEIGHT;
        [self defaultCustomAlertView];
        // set data for dialogView
        hasSeparateLine = YES;
        self-> buttonTitles = [buttonTit mutableCopy];
        self->title = tit;
        self->message = msg;
        if (del)
            delegate = del;
        else
            delegate = self;
        
        // init frame temporary for adding label
        [dialogView setFrame:CGRectMake(0, 0, CUSTOM_ALERT_VIEW_DIALOGVIEW_WIDTH, 0)];
        
        // add label
        [self addTitleAndMessage];
        
        //set frame
        int hasButton = [buttonTitles count] > 0? 1:0;
        int hasLabel = self->height_dialog > CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_HEIGHT ? 1:0;
        [dialogView setFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, CUSTOM_ALERT_VIEW_DIALOGVIEW_WIDTH, height_dialog*hasLabel + CUSTOM_ALERT_VIEW_BUTTON_HEIGHT*hasButton)];
        [dialogView setBackgroundColor:[UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.8f]];
        [dialogView.layer setCornerRadius:CUSTOM_ALERT_VIEW_CORNER_RAIUS];
        
        // add button
        [self addButton];
    }
    
    return self;
}

// override init method
-(id) init
{
    if (self = [super init])
    {
        [self defaultCustomAlertView];
        // set data for dialogView
        hasSeparateLine = NO;
        self->buttonTitles = nil;
        self->title = nil;
        self->message = nil;
        delegate = self;
        
        //set frame
        [dialogView setFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, CUSTOM_ALERT_VIEW_DIALOGVIEW_WIDTH, 30.0f)];
        [dialogView setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f]];
    }
    
    return self;
}

/********************
****** Custom dialogView
********************/

/* Use @property "dialogView" to custom everythings. */

// set background
-(void) dialogViewSetBackground:(UIImage *)bg alpha:(float)alpha
{
    [self->background removeFromSuperview];
    
    self->background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dialogView.frame.size.width, dialogView.frame.size.height)];
    self->background.image = bg;
    [self->background setAlpha:alpha];
    
    [dialogView addSubview:self->background];
    [dialogView setBackgroundColor:[UIColor clearColor]];
}

// set frame for dialogView
-(void) dialogViewSetFrame:(CGRect)frame
{
    dialogView.frame = frame;
    
    // fix background
    [self->background setFrame:CGRectMake(0, 0, dialogView.frame.size.width, dialogView.frame.size.height)];
    
    // fix label in the center
    self->height_dialog = CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_HEIGHT;
    [label_message removeFromSuperview];
    [label_title removeFromSuperview];
    label_title = nil;
    label_message = nil;
    [self addTitleAndMessage];
}

/********************
 ****** Custom Button
 ********************/

// add button for alert view from title
-(void) addButtonTitles:(NSArray*)butTit;
{
    [self->buttonTitles removeAllObjects];
    self->buttonTitles = [butTit mutableCopy];
    
    // remove old button
    for (UIButton *but in self->arrayButton)
        [but removeFromSuperview];
    [self->arrayButton removeAllObjects];
    
    [self addButton];
}

// get button from title
-(UIButton*) getButtonFromTitle:(NSString *)tit
{
    for (UIButton *but in self->arrayButton)
        if ([[but currentTitle] isEqual:tit])
            return but;
    // not found
    return nil;
}

-(UIButton *)getButtonFromIndex:(NSInteger)index
{
    return [arrayButton objectAtIndex:index];
}

-(NSArray *)getAllButtons
{
    return arrayButton;
}

// action default for all button
-(void) customAlertViewButtonClicked:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)indexButton
{
    NSLog(@"Button \"%@\" clicked! Plesea set delegate for customAlertView\n\n",[self->buttonTitles objectAtIndex:indexButton]);
    [self close];
}

// manage action for all button (delegate)
-(IBAction)customAlertViewButtonClicked:(id)sender{
    
    [delegate customAlertViewButtonClicked:self clickedButtonAtIndex:[sender tag]];
}

// draw separate line between buttons (only use when use initWithTitle:)
-(void) drawSeparateLine
{
    // remove all separate line
    UIView *line;
    CGSize sizedialogView = dialogView.frame.size;
    while ((line = [dialogView viewWithTag:CUSTOM_ALERT_VIEW_TAG_SEPARATE_LINE]) !=nil)
        [line removeFromSuperview];
    
    // draw separate line (horizontal)
    if (self->height_dialog > CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_HEIGHT && [buttonTitles count]>0)
    {
        float delta = 1;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            delta = 2.0f;

        line = [[UIView alloc] initWithFrame:CGRectMake(0,sizedialogView.height - CUSTOM_ALERT_VIEW_BUTTON_HEIGHT,dialogView.frame.size.width, 0.5f*delta)];
        [line setTag:CUSTOM_ALERT_VIEW_TAG_SEPARATE_LINE];
        [line setBackgroundColor:[UIColor colorWithRed:132/255.0f green:1 blue:0 alpha:1]];
        [dialogView addSubview:line];
    }
    
    float widthButton = sizedialogView.width / [self->buttonTitles count];
    for (int index = 0; index < self->buttonTitles.count; index++)
    {
        // draw separate line (vertical)
        if (self->height_dialog>CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_HEIGHT && index > 0)
        {
            float delta = 1;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                delta = 2.0f;
            line = [[UIView alloc] initWithFrame:CGRectMake(widthButton*index,sizedialogView.height - CUSTOM_ALERT_VIEW_BUTTON_HEIGHT,0.5f*delta, CUSTOM_ALERT_VIEW_BUTTON_HEIGHT)];
            [line setBackgroundColor:[UIColor colorWithRed:132/255.0f green:1 blue:0 alpha:1]];
            [line setTag:CUSTOM_ALERT_VIEW_TAG_SEPARATE_LINE];
            [dialogView addSubview:line];
        }
    }
}

// add button
-(void) addButton
{
    if (self->buttonTitles == nil)
        return;
    
    CGSize sizedialogView = dialogView.frame.size;
    
    // draw button
    self->arrayButton = [[NSMutableArray alloc] initWithCapacity:[self->buttonTitles count]];
    int index = 0;
    float widthButton = sizedialogView.width / [self->buttonTitles count];
    for (NSString *butTitle in self->buttonTitles)
    {
        // set frame
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(index*widthButton, sizedialogView.height - CUSTOM_ALERT_VIEW_BUTTON_HEIGHT, widthButton, CUSTOM_ALERT_VIEW_BUTTON_HEIGHT)];
        [button setTag:index];
        [button setTitle:butTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(customAlertViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //set color (default)
        [button setBackgroundColor:[UIColor clearColor]];
        [button.titleLabel setFont:[UIFont fontWithName:LABEL_FONT size:18]];
        [button setTitleColor:[UIColor colorWithRed:132/255.0 green:1 blue:0 alpha:1.0f] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:132/255.0 green:1 blue:0 alpha:0.5f] forState:UIControlStateHighlighted];
        [button.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        
        [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8] forState:UIControlStateSelected];
        
        [dialogView addSubview:button];
        [self->arrayButton addObject:button];
        
        index++;
    }
}

- (void) dialogViewAddCustomButton:(UIButton *)button
{
    if (self->arrayButton == nil)
        self->arrayButton = [[NSMutableArray alloc] init];
    
    [button addTarget:self action:@selector(customAlertViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:self->arrayButton.count];
    [self->arrayButton addObject:button];
    [dialogView addSubview:button];
}

/********************
 ****** show and close alert view
 ********************/

//---------- show effect
-(void) animationShowBegin:(CustomAlertViewAnimationShow)animation
{
    // set color background
    CGFloat r,g,b,a;
    [[self backgroundColor] getRed:&r green:&g blue:&b alpha:&a];
    [self setBackgroundColor:[UIColor colorWithRed:r green:g blue:b alpha:CUSTOM_ALERT_VIEW_EFFECT_ALPHA_BEGIN]];
    
    // set dialogView
    [dialogView.layer setPosition:positionDialogView];
    [dialogView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [dialogView setAlpha:1.0f];
    switch (animation)
    {
        case customAlertViewAnimationShowZoomIn:
            dialogView.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.0f);
            break;
            
        case customAlertViewAnimationShowZoomInHorizontal:
            dialogView.layer.transform = CATransform3DMakeScale(0.5f, 1.0f, 1.0f);
            break;
        
        case customAlertViewAnimationShowZoomInVertical:
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 0.5f, 1.0f);
            break;
            
        case customAlertViewAnimationShowZoomOut:
            dialogView.layer.transform = CATransform3DMakeScale(1.5f, 1.5f, 1.0f);
            break;
            
        case customAlertViewAnimationShowZoomOutHorizontal:
            dialogView.layer.transform = CATransform3DMakeScale(1.5f, 1.0f, 1.0f);
            break;
            
        case customAlertViewAnimationShowZoomOutVertical:
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.5f, 1.0f);
            break;
            
        case customAlertViewAnimationShowFadeIn:
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
            [dialogView setAlpha:0.0f];
            break;
            
        case customAlertViewAnimationShowFadeLeftToRight:
            [dialogView.layer setPosition:CGPointMake(-dialogView.frame.size.width/2.0f,positionDialogView.y)];
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
            break;
            
        case customAlertViewAnimationShowFadeRightToLeft:
            [dialogView.layer setPosition:CGPointMake(self.frame.size.width+dialogView.frame.size.width/2.0f,positionDialogView.y)];
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
            break;
            
        case customAlertViewAnimationShowFadeTopToBottom:
            [dialogView.layer setPosition:CGPointMake(positionDialogView.x,-dialogView.frame.size.height/2.0f)];
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
            break;
            
        case customAlertViewAnimationShowFadeBottomToTop:
            [dialogView.layer setPosition:CGPointMake(positionDialogView.x,self.frame.size.height+dialogView.frame.size.height / 2.0f)];
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
            break;
            
        case customAlertViewAnimationShowNone:
            [self setBackgroundColor:[UIColor colorWithRed:r green:g blue:b alpha:CUSTOM_ALERT_VIEW_EFFECT_ALPHA_END]];
            break;
            
        default:
            break;
    }
}

-(void) animationShowEnd
{
    // set color background
    CGFloat r,g,b,a;
    [[self backgroundColor] getRed:&r green:&g blue:&b alpha:&a];
    [self setBackgroundColor:[UIColor colorWithRed:r green:g blue:b alpha:CUSTOM_ALERT_VIEW_EFFECT_ALPHA_END]];
    
    // set dialogView
    dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f); // always use original size
    [dialogView setAlpha:1.0f];
    
    // set dialogView in in the center
    [dialogView.layer setPosition:positionDialogView];
    [dialogView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
}

// show alert
-(void) show
{
    if (hasSeparateLine)
        [self drawSeparateLine];
    
    [self animationShowBegin:CUSTOM_ALERT_VIEW_ANIMATE_SHOW];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window.rootViewController.view addSubview:self];
    [appDelegate.window.rootViewController.view bringSubviewToFront:self];
    // effect
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:
    ^
    {
        [self animationShowEnd];
    }completion:nil];
}

//------------- close effect

-(void) animationCloseBegin
{
    // set color background
    CGFloat r,g,b,a;
    [[self backgroundColor] getRed:&r green:&g blue:&b alpha:&a];
    [self setBackgroundColor:[UIColor colorWithRed:r green:g blue:b alpha:CUSTOM_ALERT_VIEW_EFFECT_ALPHA_END]];
    
    // set dialogView
    dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f); // always use original size
    [dialogView setAlpha:1.0f];
}

-(void) animationCloseEnd:(CustomAlertViewAnimationClose)animation
{
    // set color background
    CGFloat r,g,b,a;
    [[self backgroundColor] getRed:&r green:&g blue:&b alpha:&a];
    [self setBackgroundColor:[UIColor colorWithRed:r green:g blue:b alpha:CUSTOM_ALERT_VIEW_EFFECT_ALPHA_BEGIN]];
    
    // set dialogView
    [dialogView setAlpha:0.0f];
    switch (animation)
    {
        case customAlertViewAnimationCloseZoomIn:
            dialogView.layer.transform = CATransform3DMakeScale(1.5f, 1.5f, 1.0f);
            break;
          
        case customAlertViewAnimationCloseZoomInHorizontal:
            dialogView.layer.transform = CATransform3DMakeScale(1.5f, 1.0f, 1.0f);
            break;
        
        case customAlertViewAnimationCloseZoomInVertical:
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.5f, 1.0f);
            break;
            
        case customAlertViewAnimationCloseZoomOut:
            dialogView.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.0f);
            break;
            
        case customAlertViewAnimationCloseZoomOutHorizontal:
            dialogView.layer.transform = CATransform3DMakeScale(0.5f, 1.0f, 1.0f);
            break;
            
        case customAlertViewAnimationCloseZoomOutVertical:
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 0.5f, 1.0f);
            break;
            
        case customAlertViewAnimationCloseFadeOut:
            dialogView.layer.transform = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
            break;
            
        case customAlertViewAnimationCloseFadeLeftToRight:
            [dialogView.layer setPosition:CGPointMake(self.frame.size.width+dialogView.frame.size.width/2.0f,positionDialogView.y)];
            [dialogView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            break;
            
        case customAlertViewAnimationCloseFadeRightToLeft:
            [dialogView.layer setPosition:CGPointMake(-dialogView.frame.size.width/2.0f,positionDialogView.y)];
            [dialogView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            break;

        case customAlertViewAnimationCloseFadeTopToBottom:
            [dialogView.layer setPosition:CGPointMake(positionDialogView.x,self.frame.size.height - dialogView.frame.size.height / 2.0f)];
            [dialogView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            break;
            
        case customAlertViewAnimationCloseFadeBottomToTop:
            [dialogView.layer setPosition:CGPointMake(positionDialogView.x,- dialogView.frame.size.height / 2.0f)];
            [dialogView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            break;
            
        default:
            break;
    }
}


// close
-(void) close
{
    [self animationCloseBegin];
    
    // effect
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:
     ^
     {
         [self animationCloseEnd:CUSTOM_ALERT_VIEW_ANIMATE_CLOSE];
     }completion:
     ^(BOOL finish)
     {
         [self removeFromSuperview];
     }];
}

/********************
 ****** add Title and message
 ********************/

-(void) addTitleAndMessage
{
    if (title)
    {
        label_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dialogView.frame.size.width - CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_WIDTH, 0)];
        [label_title setLineBreakMode:NSLineBreakByWordWrapping];
        [label_title setNumberOfLines:0];
        [label_title setBackgroundColor:[UIColor clearColor]];
        [label_title setTextAlignment:NSTextAlignmentCenter];
        [label_title setFont:[UIFont fontWithName:LABEL_FONT size:22]];
        [label_title setText:self->title];
        [label_title setTextColor:[UIColor colorWithRed:132/255.0 green:1 blue:0 alpha:1]];
        [label_title setShadowColor:[UIColor blackColor]];
        [label_title setShadowOffset:CGSizeMake(0, 1)];
         
        
        // fit size
        [label_title sizeToFit];
        
        // set position
        [label_title.layer setPosition:CGPointMake(dialogView.frame.size.width/2.0f, self->height_dialog)];
        [label_title.layer setAnchorPoint:CGPointMake(0.5, 0.0f)];
        
        [dialogView addSubview:label_title];
        height_dialog += label_title.frame.size.height + CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_HEIGHT;
    }
    
    if (message)
    {
        label_message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dialogView.frame.size.width -CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_WIDTH, 0)];
        [label_message setLineBreakMode:NSLineBreakByWordWrapping];
        [label_message setNumberOfLines:0];
        [label_message setBackgroundColor:[UIColor clearColor]];
        [label_message setFont:[UIFont fontWithName:LABEL_FONT size:18]];
        [label_message setText:self->message];
        [label_message setTextAlignment:NSTextAlignmentCenter];
        [label_message setTextColor:[UIColor whiteColor]];
        // fit size
        [label_message sizeToFit];
        
        // set position
        [label_message.layer setPosition:CGPointMake(dialogView.frame.size.width/2.0f, self->height_dialog)];
        [label_message.layer setAnchorPoint:CGPointMake(0.5f, 0.0f)];
        
        [dialogView addSubview:label_message];
        
        height_dialog += label_message.frame.size.height + CUSTOM_ALERT_VIEW_DIALOGVIEW_DELTA_HEIGHT;
    }
}

@end
