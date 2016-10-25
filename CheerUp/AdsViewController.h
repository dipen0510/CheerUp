//
//  AdsViewController.h
//  CheerUp
//
//  Created by Dipen Sekhsaria on 26/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdsViewController : UIViewController <DataSyncManagerDelegate> {
    
    NSMutableArray* adsArr;
    int currentIndex;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *adImgView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property BOOL isOpenedFromSideMenu;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)leftButtonTapped:(id)sender;
- (IBAction)rightButtonTapped:(id)sender;

@end
