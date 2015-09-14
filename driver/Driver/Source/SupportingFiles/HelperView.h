//
//  HelperView.h
//  Application
//
//  Created by Phan Minh Nhựt on 9/8/13.
//  Copyright (c) 2013 Phan Minh Nhựt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

//------------------------------- Define String

#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_COPYRIGHT_BY_PHAN @"Copyright © 2015 Phan. All rights reserved."

//------------------------------- Rate page

#define APP_ID @"959378313"
#define LINK_TO_RATE_PAGE [NSString stringWithFormat:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",APP_ID]

// define ratio
#define RATIOX [HelperView getRatioX]
#define RATIOY [HelperView getRatioY]
#define RATIO_TEXT [HelperView getRatioText]
#define RATIO_CIRCLE RATIO_TEXT

/**************************
 ******* Debug and Release Mode
 *************************/

// disable NSLog(@"") in Release Mode (DEBUG is defined by Apple in debug mode in target's preprocessor, but it's not defined in release mode)
#ifndef DEBUG
    #define NSLog(...)
#endif

/**
 Class use to help developer quickly coding by creating some methods regarding UIView that usually use.
 */
@interface HelperView: NSObject

/**************************
 ******* device
 *************************/

/**
Return size of screen of current device;
*/
+(CGSize) getSizeScreen;

/**
Set size of screen of your device which you use to programming.
*/
+(void) setDefaultSizeOfScreen:(CGSize)size;

/**
 Get appDelegate instance
 */
+(AppDelegate*) getAppDelegate;

/**************************
 ******* ratio
 *************************/

/**
 Get ratio width between current device and "programming" device. Use to scale on differnenr device.
 */
+(float) getRatioX;

/**
 Get ratio height between current device and "programming" device. Use to scale on differnenr device.
 */
+(float) getRatioY;

/**
 Get ratio for text between current device and "programming" device. Use to scale on differnenr device.
 */
+(float) getRatioText;

/**************************
 ******* Image
 *************************/

//---------- Image for navigation bar
// Use Fullscreen: Width *64 (default on iOS 7 and later);

//---------- How to add suffix
//Ex: name.jpg, name@2x.jpg, name@3x.jpg.
// define suffix for image
#define SUFFIX_IPHONE_SCALE_2X @"@2x" // use for iPhone 4,5,6 (scale = 2.0)
#define SUFFIX_IPHONE_SCALE_3X @"@3x" // use for iPhone 6 Plus (scale = 3.0)

#define SUFFIX_IPAD @"~ipad" // use for iPad 2, ipad mini (scale = 2.0)
#define SUFFIX_IPAD_SCALE_2X @"@2x~ipad" // use for iPad retina (scale = 2.0)

/**
 create and optimze image for correspond device
 */
+(UIImage*) createImageWithName:(NSString*)name extension:(NSString*)ext;

/**
 Convert UIView to UIImage
 */
+ (UIImage *) createImageWithView:(UIView *)view;

/**
 resize image
 */
+ (UIImage *) resizeImage:(UIImage *)image scaledToSize:(CGSize)size;

/**
 Rotate image
 */
+(UIImage *) rotateImage:(UIImage*)image orientation:(UIImageOrientation)orientation;

/**************************
 ******* Fix position and rectangle
 *************************/

/** 
 Auto fix rectangle based on RATIO (width and height) between current device and "programming" device.
 */
+(CGRect) autoFixRect:(CGRect)rect;

/**************************
 ******* Compare
 *************************/

/**
 Compare 2 float number is equal or not.
 */
+(BOOL) isEqualFloat:(float)num1 num2:(float)num2 epsilon:(float)epsilon;

@end
