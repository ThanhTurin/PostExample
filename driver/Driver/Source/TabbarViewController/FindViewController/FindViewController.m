//
//  CurrentPositionControllerViewController.m
//  GoogleMapDemo
//
//  Created by ThanhTurin on 5/23/15.
//  Copyright (c) 2015 ThanhTurin. All rights reserved.
//

/*
 Current version only support iOS 8.0 or newer!
 */

#import "FindViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface FindViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) GMSMapView *mapView;
@property (nonatomic) CLLocationManager* locationManager;

@end

@implementation FindViewController {
    GMSMapView *mapView_;
    UIViewController *mapVC;
    BOOL firstLocationUpdate_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BACKGROUND_COLOR_WHITE];
    
    // change status button
    self.navigationItem.leftBarButtonItem = [[[BarButtonMenu alloc] initWithCurrentViewController:self] getButtonMenu];
    self.navigationItem.rightBarButtonItem = [BarButtonStatus sharedBarButtonStatus];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.currentLocation.coordinate.latitude
                                                            longitude:self.currentLocation.coordinate.longitude
                                                                 zoom:6];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    //GPS Button
    mapView_.settings.myLocationButton = YES;
    
    // Listen to the myLocation property of GMSMapView.
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    [mapView_ setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49)];
    mapVC = [[UIViewController alloc] init];
    mapVC.view = mapView_;
    [mapVC.view setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 49)];
    
    [self.view addSubview:mapVC.view];
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
}

// Update Current Position for first time running
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (!firstLocationUpdate_) {
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:16];
    }
}

- (void)dealloc {
    
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
