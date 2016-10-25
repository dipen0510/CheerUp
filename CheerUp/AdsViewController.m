//
//  AdsViewController.m
//  CheerUp
//
//  Created by Dipen Sekhsaria on 26/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import "AdsViewController.h"

@interface AdsViewController ()

@end

@implementation AdsViewController

@synthesize isOpenedFromSideMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    adsArr = [[NSMutableArray alloc] init];
    [self setupUIForIndex:0];
    [self startGetAdService];
    
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonTapped:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonTapped:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setupUIForIndex:(int) index {
    
    if (index == 0) {
        _rightButton.hidden = NO;
        _leftButton.hidden = YES;
    }
    
    else if (index == (adsArr.count-1)) {
        _leftButton.hidden = NO;
        _rightButton.hidden = YES;
    }
    else {
        _leftButton.hidden = NO;
        _rightButton.hidden = NO;
    }
    
    if (adsArr.count > 0) {
        NSMutableDictionary* dict = [adsArr objectAtIndex:index];
        
        if ([dict valueForKey:@"IMAGE"] && ![[dict valueForKey:@"IMAGE"] isEqual:[NSNull null]]) {
            __weak UIImageView* weakImageView = self.adImgView;
            
            NSString* imgStr = [[NSString stringWithFormat:@"http://beecheerup.in/Admin/Uploads/Advertise/%@",[dict valueForKey:@"IMAGE"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [self.adImgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imgStr]
                                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                                timeoutInterval:60.0] placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                
                
                weakImageView.alpha = 0.0;
                weakImageView.image = image;
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     weakImageView.alpha = 1.0;
                                 }];
            } failure:NULL];
        }
    }
    
   
    
    
    
}

- (IBAction)backButtonTapped:(id)sender {
    if (isOpenedFromSideMenu) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ViewController* controller = (ViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.revealViewController setFrontViewController:controller animated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)leftButtonTapped:(id)sender {
    
    if (currentIndex > 0) {
        _adImgView.image = nil;
        [self setupUIForIndex:--currentIndex];
    }
    
}

- (IBAction)rightButtonTapped:(id)sender {
    
    if (currentIndex < adsArr.count-1) {
        _adImgView.image = nil;
        [self setupUIForIndex:++currentIndex];
    }
    
}

#pragma mark - API Helpers

- (void) startGetAdService {
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    
//    if ([[NSUserDefaults standardUserDefaults] valueForKey:kCurrentCity]) {
//        manager.serviceKey = [NSString stringWithFormat:@"%@%@",kGetAdService,[[NSUserDefaults standardUserDefaults] valueForKey:kCurrentCity]];
//    }
//    else {
        manager.serviceKey = [NSString stringWithFormat:@"%@Akola",kGetAdService];
//    }
    
    manager.delegate = self;
    [manager startGETWebServices];
    
}


#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(id)responseData andServiceKey:(NSString *)requestServiceKey {
    
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"Success!"];
    
    if ([requestServiceKey containsString:kGetAdService]) {
        
        adsArr = [[NSMutableArray alloc] initWithArray:[responseData valueForKey:@"scate"]];
        [self setupUIForIndex:0];
        
    }
    
}


- (void) didFinishServiceWithFailure:(NSString *)errorMsg {
    
    [SVProgressHUD dismiss];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:@"An issue occured while processing your request. Please try again later."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:noButton];
    
    
    if (![errorMsg isEqualToString:@""]) {
        [alert setMessage:errorMsg];
    }
    
    if ([errorMsg isEqualToString:NSLocalizedString(@"Verify your internet connection and try again", nil)]) {
        [alert setTitle:NSLocalizedString(@"Connection unsuccessful", nil)];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
    return;
    
}

@end
