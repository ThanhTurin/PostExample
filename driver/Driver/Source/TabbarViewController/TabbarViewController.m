//
//  TabbarViewController.m
//  Driver
//
//  Created by Phan Minh Nhut on 5/26/15.
//  Copyright (c) 2015 Phan Minh Nhut. All rights reserved.
//

#import "TabbarViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBar setBarTintColor:[UIColor blackColor]];
    
    // Set icon for tabbar
    /**
     Draw each item of tabbar
     */
    // unselect
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowOffset:CGSizeMake(0, 1)];
    NSDictionary *properties = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:LABEL_FONT size:10],
                                 NSShadowAttributeName: shadow};
    [[UITabBarItem appearance] setTitleTextAttributes:properties forState:UIControlStateNormal];
    
    //select
    properties = @{NSForegroundColorAttributeName:BACKGROUND_COLOR_BLUE,
                   NSFontAttributeName: [UIFont fontWithName:LABEL_FONT size:10],
                   NSShadowAttributeName: shadow};
    [[UITabBarItem appearance] setTitleTextAttributes:properties forState:UIControlStateSelected];
    
    // Create array for name for selected image
    NSArray *arrSelect = @[
                           @"maps_select.png",
                           @"book_select.png",
                           @"account_select.png",
                           @"feedback_select.png",
                           ];
    
    // Create array for name for selected image
    NSArray *arrUnSelect = @[
                             @"maps_unselect.png",
                             @"book_unselect.png",
                             @"account_unselect.png",
                             @"feedback_unselect.png",
                             ];
    
    // draw bar items
    for (int index = 0; index < arrSelect.count ; index++)
        [self setBarItemAtIndex:index selectImageName:[arrSelect objectAtIndex:index] unselectImageName:[arrUnSelect objectAtIndex:index]];
    
}

/**
 Draw each item of tabbar
 */
-(void) setBarItemAtIndex:(NSUInteger)index selectImageName:(NSString*)selectImgName unselectImageName:(NSString*)unselectImgName
{
    UITabBarItem *item = [self.tabBar.items objectAtIndex:index];
    
    // create image for icon bar (also add "Render mode" to prevent system coloring and reize it)
    UIImage *img = [HelperView resizeImage:[UIImage imageNamed:selectImgName] scaledToSize:CGSizeMake(25, 25)];
    UIImage *imgSelect = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    img = [HelperView resizeImage:[UIImage imageNamed:unselectImgName] scaledToSize:CGSizeMake(25, 25)];
    UIImage *imgUnselect = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // Set icon for tabbar
    [item setSelectedImage:imgSelect];
    [item setImage:imgUnselect];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
