//
//  SideMenuViewController.m
//  CheerUp
//
//  Created by Dipen Sekhsaria on 26/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import "SideMenuViewController.h"
#import "SideMenuTableViewCell.h"

#import "ReadViewController.h"
#import "ExpressViewController.h"
#import "AdsViewController.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateDataSource];
    
}

- (void) generateDataSource {
    
    tableArr = [[NSMutableArray alloc] init];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"Read" forKey:@"title"];
    [dict setObject:@"read_icon.png" forKey:@"image"];
    [tableArr addObject:dict];
    
    NSMutableDictionary* dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setObject:@"Express" forKey:@"title"];
    [dict1 setObject:@"express_icon.png" forKey:@"image"];
    [tableArr addObject:dict1];
    
    NSMutableDictionary* dict3 = [[NSMutableDictionary alloc] init];
    [dict3 setObject:@"Nearby!" forKey:@"title"];
    [dict3 setObject:@"nearby_icon.png" forKey:@"image"];
    [tableArr addObject:dict3];
    
    NSMutableDictionary* dict4 = [[NSMutableDictionary alloc] init];
    [dict4 setObject:@"Bookmarks" forKey:@"title"];
    [dict4 setObject:@"notification_icon.png" forKey:@"image"];
    [tableArr addObject:dict4];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString* identifier = @"SideMenuTableViewCell";
    SideMenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"SideMenuTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    cell.menuImgView.image = [UIImage imageNamed:[[tableArr objectAtIndex:indexPath.row] valueForKey:@"image"]];
    cell.menuTitleLabel.text = [[tableArr objectAtIndex:indexPath.row] valueForKey:@"title"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - UITableView Delegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"showReadSegue" sender:nil];
            break;
            
        case 1:
            [self performSegueWithIdentifier:@"showExpressSegue" sender:nil];
            break;
            
            
        case 2:
            [self performSegueWithIdentifier:@"showAdsSegue" sender:nil];
            break;
            
        case 3:
            [self performSegueWithIdentifier:@"showBookmarkSegue" sender:nil];
            break;
            
        default:
            break;
    }
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showReadSegue"]) {
        
        ReadViewController* controller = (ReadViewController *)[segue destinationViewController];
        controller.isOpenedFromSideMenu = YES;
        
    }
    if ([[segue identifier] isEqualToString:@"showExpressSegue"]) {
        
        ExpressViewController* controller = (ExpressViewController *)[segue destinationViewController];
        controller.isOpenedFromSideMenu = YES;
        
    }
    if ([[segue identifier] isEqualToString:@"showAdsSegue"]) {
        
        AdsViewController* controller = (AdsViewController *)[segue destinationViewController];
        controller.isOpenedFromSideMenu = YES;
        
    }
    if ([[segue identifier] isEqualToString:@"showBookmarkSegue"]) {
        
        ReadViewController* controller = (ReadViewController *)[segue destinationViewController];
        controller.isOpenedFromSideMenu = YES;
        controller.isBookmarkedView = YES;
    }
    
}

@end
