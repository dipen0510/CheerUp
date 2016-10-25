//
//  ExpressViewController.h
//  CheerUp
//
//  Created by Dipen Sekhsaria on 25/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DataSyncManagerDelegate> {
    UIActionSheet* actSheet;
    UIImage* profileImage;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtField;
@property (weak, nonatomic) IBOutlet UITextField *contactTxtField;
@property (weak, nonatomic) IBOutlet UITextField *titleTxtField;
@property (weak, nonatomic) IBOutlet UITextView *expressTxtView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property BOOL isOpenedFromSideMenu;

- (IBAction)backButtonTapped:(id)sender;
- (IBAction)imageButtonTapped:(id)sender;
- (IBAction)postButtonTapped:(id)sender;

@end
