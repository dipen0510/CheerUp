//
//  ViewController.m
//  CheerUp
//
//  Created by Dipen Sekhsaria on 25/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupLocationManager];
    [self sideMenuSetup];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsGCMPosted]) {
        [self startGCMService];
    }

    
}

- (void)sideMenuSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuButton addTarget:self.revealViewController action:@selector( revealToggle: ) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:revealViewController.tapGestureRecognizer];
        //[revealViewController setFrontViewShadowRadius:10.0];
    }
}

- (void) setupLocationManager {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    
    [locationManager startUpdatingLocation];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    
}

- (void) startGCMService {
    
    if (currentLocation) {
        [self getCurrentCityAndCountry];
    }
    
}


- (void) getCurrentCityAndCountry {
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    [reverseGeocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         
         NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
         if (error){
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         NSLog(@"Received placemarks: %@", placemarks);
         
         
         CLPlacemark *myPlacemark = [placemarks objectAtIndex:0];
         NSString *countryCode = myPlacemark.ISOcountryCode;
         NSString *countryName = myPlacemark.country;
         NSLog(@"My country code: %@ and countryName: %@", countryCode, countryName);
         
         NSLog(@"%@, %@",myPlacemark.locality,countryName);
         
         [[NSUserDefaults standardUserDefaults] setObject:myPlacemark.locality forKey:kCurrentCity];
         
         [[SharedClass sharedInstance] startPostGCMService];
         
     }];
    
}

@end
