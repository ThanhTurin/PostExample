//
//  HelperView.m
//  Application
//
//  Created by Phan Minh Nhựt on 9/8/13.
//  Copyright (c) 2013 Phan Minh Nhựt. All rights reserved.
//

#import "HelperView.h"
#import "AppDelegate.h"

@implementation HelperView

static int width = -1;
static int height = -1;
static float ratioX = -1.0f, ratioY = -1.0f, ratioText = -1.0f;

/**************************
 ******* device
 *************************/

+(CGSize) getSizeScreen
{
    return [UIScreen mainScreen].bounds.size;
}

+(void)setDefaultSizeOfScreen:(CGSize)size
{
    width = (int)size.width;
    height = (int)size.height;
}

+(AppDelegate*)getAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

/**************************
 ******* ratio
 *************************/

+(float) getRatioX
{
    if (ratioX == -1)
    {
        NSAssert(width != -1, @"**HelperView: You must set default size of screen first. Use func: setDefaultSizeOfScreen:");
        
        if (ratioX == -1.0f)
            ratioX = [UIScreen mainScreen].bounds.size.width / width;
    }
    
    return ratioX;
}

+(float) getRatioY
{
    if (ratioY == -1)
    {
        NSAssert(height != -1, @"**HelperView: You must set default size of screen first. Use func: setDefaultSizeOfScreen:");
        ratioY = [UIScreen mainScreen].bounds.size.height / height;
    }
    
    return ratioY;
}

+(float) getRatioText
{
    if (ratioText == -1)
    {
        if (RATIOX == 1)
         ratioText =  1;
        else
            ratioText = (2*RATIOX*RATIOY) / (RATIOX + RATIOY);
    }
    
    return ratioText;
}

/**************************
 ******* Image
 *************************/

+(UIImage*) createImageWithName:(NSString *)name extension:(NSString *)ext
{
    NSString *filename;
    NSString *suffix;
    UIImage *img;
    
    // set suffix
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([UIScreen mainScreen].scale == 2.0f)
            suffix = SUFFIX_IPHONE_SCALE_2X;
        else
            suffix = SUFFIX_IPHONE_SCALE_3X;
    }
    else
    {
        if ([UIScreen mainScreen].scale == 1.0f)
            suffix = SUFFIX_IPAD;
        else
            suffix = SUFFIX_IPAD_SCALE_2X;
    }
    
    filename = [NSString stringWithFormat:@"%@%@",name,suffix];
    img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:ext]];
    if (!img)
        NSLog(@"ERROR - Not Found image: %@.%@\n\n",filename,ext);
    
    return img;
}

+ (UIImage *) createImageWithView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *) resizeImage:(UIImage *)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)rotateImage:(UIImage *)image orientation:(UIImageOrientation)orientation
{
    return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:orientation];
}

/**************************
 ******* Fix position and rectangle
 *************************/

+(CGRect) autoFixRect:(CGRect)rect
{
    rect.origin.x *= [HelperView getRatioX];
    rect.origin.y *= [HelperView getRatioY];
    
    rect.size.width *= [HelperView getRatioX];
    rect.size.height *= [HelperView getRatioY];
    
    return rect;
}

/**************************
 ******* Other
 *************************/

+ (BOOL)isEqualFloat:(float)num1 num2:(float)num2 epsilon:(float)epsilon
{
    float sub = num1 - num2;
    if (sub <= epsilon && sub >= -epsilon)
        return YES;
    
    return NO;
}

@end
