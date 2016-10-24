//
//  ReadViewController.m
//  CheerUp
//
//  Created by Dipen Sekhsaria on 25/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadTableViewCell.h"

@interface ReadViewController ()

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupInitalView {
    
    self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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


#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* identifier = @"ReadTableViewCell";
    ReadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ReadTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    
    [self displayContentForCell:cell atIndexPath:indexPath];
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400.0;
}

#pragma mark - UITableView Delegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
}

- (void) displayContentForCell:(ReadTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    //POPULATE CONTENT
    
    
    
    
    
}
@end
