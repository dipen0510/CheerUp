//
//  ViewController.h
//  CheerUp
//
//  Created by Dipen Sekhsaria on 25/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager* locationManager;
    CLLocation* currentLocation;
}

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

