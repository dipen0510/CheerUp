//
//  ReadViewController.h
//  CheerUp
//
//  Created by Dipen Sekhsaria on 25/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

- (IBAction)backButtonTapped:(id)sender;

@end
