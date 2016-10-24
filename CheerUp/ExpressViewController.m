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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)imageButtonTapped:(id)sender {
}

- (IBAction)postButtonTapped:(id)sender {
}
@end
