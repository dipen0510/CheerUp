//
//  BlogDetailViewController.h
//  CheerUp
//
//  Created by Dipen Sekhsaria on 28/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlogDetailViewController : UIViewController {
    NSMutableArray *tableViewCellsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *contentTblView;

@property (strong, nonatomic) NSMutableDictionary* contentDetailDict;

- (IBAction)backButtonTapped:(id)sender;

@end
