//
//  SideMenuViewController.h
//  CheerUp
//
//  Created by Dipen Sekhsaria on 26/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuViewController : UIViewController {
    NSMutableArray* tableArr;
}

@property (weak, nonatomic) IBOutlet UITableView *menuTblView;
@end
