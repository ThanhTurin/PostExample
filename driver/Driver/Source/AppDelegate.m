//
//  AppDelegate.m
//  Driver
//
//  Created by Phan Minh Nhut on 5/26/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (NSString *)unicodeToASCII : (NSString *)unicodeString {
    NSString *unicode = unicodeString;
    NSString *standard = [unicode stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    standard = [standard stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    NSData *decode = [standard dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *ansi = [[NSString alloc] initWithData:decode encoding:NSASCIIStringEncoding];
    NSLog(@"ANSI: %@", ansi);
    return ansi;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [HelperView setDefaultSizeOfScreen:CGSizeMake(320.0, 480)];
    
    // set color for navigation
    [[UINavigationBar appearance] setBarTintColor:BACKGROUND_COLOR_BLUE];
    
    // Set attributes for title
    UIFont *font = [UIFont fontWithName:LABEL_FONT size:20];
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowOffset:CGSizeMake(0, 1)];
    UIColor *textColor = [UIColor whiteColor];
    NSDictionary *properties = @{NSForegroundColorAttributeName: textColor,
                                 NSFontAttributeName: font,
                                 NSShadowAttributeName: shadow};
    [[UINavigationBar appearance] setTitleTextAttributes:properties];
    
    //----------------------------------------------
    
    //  <----- Updating : Google Maps:
    [GMSServices provideAPIKey:@"AIzaSyAoQjz_pU2R2QuJB0NwbnM7DDx4UCCVEHQ"];
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 100.0;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
