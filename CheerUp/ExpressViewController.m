//
//  ExpressViewController.m
//  CheerUp
//
//  Created by Dipen Sekhsaria on 25/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import "ExpressViewController.h"

@interface ExpressViewController ()

@end

@implementation ExpressViewController

@synthesize isOpenedFromSideMenu;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contactTxtField.keyboardType = UIKeyboardTypeNumberPad;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyborad)];
    [self.contentScrollView addGestureRecognizer:tapGesture];
    
    [self setupActionSheet];
    
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

- (IBAction)imageButtonTapped:(id)sender {
    if ([actSheet isVisible]) {
        [actSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
    else {
        [actSheet showInView:self.view];
    }
}

- (IBAction)postButtonTapped:(id)sender {
    [self startPostBlogService];
}

- (void) hideKeyborad {
    
    [self.view endEditing:YES];
    
}


#pragma mark - Profile Image Change

- (void) setupActionSheet {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actSheet = [[UIActionSheet alloc] initWithTitle:nil
                                               delegate:self
                                      cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@"Photo Library", nil];
    }
    else {
        actSheet = [[UIActionSheet alloc] initWithTitle:nil
                                               delegate:self
                                      cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:@"Photo Library", @"Camera", nil];
    }
    
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet == actSheet) {
        //FLOG(@"Button %d", buttonIndex);
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            switch (buttonIndex) {
                    
                case 0:
                {
                    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                    imgPicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                    imgPicker.delegate = self;
                    [self presentViewController:imgPicker animated:YES completion:nil];
                    break;
                }
                    
                default:
                    
                    break;
            }
            
        }
        else {
            
            switch (buttonIndex) {
                    
                case 0:
                {
                    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                    imgPicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                    imgPicker.delegate = self;
                    [self presentViewController:imgPicker animated:YES completion:nil];
                    break;
                }
                    
                case 1:
                {
                    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                    imgPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                    imgPicker.delegate = self;
                    [self presentViewController:imgPicker animated:YES completion:nil];
                    break;
                }
                    
                default:
                    
                    break;
            }
            
        }
        
        
        
        
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image1 = info[UIImagePickerControllerOriginalImage];
    profileImage = image1;
    [self.imageButton setImage:profileImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - API Helpers

- (void) startPostBlogService {
    
    [SVProgressHUD showWithStatus:@"Posting Blog. Please Wait..."];
    
    NSMutableDictionary* reqDict = [self prepareDictForPostBlogService];
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kPostBlog;
    manager.delegate = self;
    [manager startPOSTWebServicesWithParams:reqDict];
    
    
}


#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(id)responseData andServiceKey:(NSString *)requestServiceKey {
    
    [SVProgressHUD dismiss];
    
    if ([requestServiceKey isEqualToString:kPostBlog]) {
        
        [SVProgressHUD showSuccessWithStatus:@"Blog posted successfully."];
        
        
    }
    
}


- (void) didFinishServiceWithFailure:(NSString *)errorMsg {
    
    [SVProgressHUD dismiss];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:nil
                                                  message:NSLocalizedString(@"An issue occured while processing your request. Please try again later.", nil)
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                        otherButtonTitles: nil];
    
    if (![errorMsg isEqualToString:@""]) {
        [alert setMessage:errorMsg];
    }
    
    if ([errorMsg isEqualToString:NSLocalizedString(@"Verify your internet connection and try again", nil)]) {
        [alert setTitle:NSLocalizedString(@"Connection unsuccessful", nil)];
    }
    
    
    [alert show];
    
    return;
    
}

- (NSMutableDictionary *) prepareDictForPostBlogService {
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:_nameTxtField.text forKey:@"NAME_BLOGGER"];
    [dict setObject:_contactTxtField.text forKey:@"CONTACT"];
    
    [dict setObject:_emailTxtField.text forKey:@"EMAIL"];
    [dict setObject:_titleTxtField.text forKey:@"TITLE"];
    [dict setObject:_expressTxtView.text forKey:@"DESCRIPTION"];
    [dict setObject:@"0" forKey:@"STATUS"];
    
    [dict setObject:[self encodeToBase64String:profileImage] forKey:@"IMAGE"];
    
    
    return dict;
    
}

#pragma mark - Image to String Encoding

- (NSString *)encodeToBase64String:(UIImage *)image {
    
    if (image) {
        return [UIImagePNGRepresentation([self resizeImage:image]) base64EncodedStringWithOptions:0];
    }
    
    return @"";
}

-(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = _imageButton.frame.size.width;
    float maxWidth = _imageButton.frame.size.height;;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}

@end
