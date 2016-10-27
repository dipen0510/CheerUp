//
//  ReadViewController.m
//  CheerUp
//
//  Created by Dipen Sekhsaria on 25/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "BlogDetailViewController.h"

@interface ReadViewController ()

@end

@implementation ReadViewController

@synthesize isOpenedFromSideMenu,isBookmarkedView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupInitalView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupInitalView {
    
    self.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    contentArr = [[NSMutableArray alloc] init];
    selectedDict = [[NSMutableDictionary alloc] init];
    
    NSString* attendStr = [[SharedClass sharedInstance] loadBookmarkDataForService];
    if (attendStr) {
        bookmarkedBlogArr = (NSMutableArray *)[[SharedClass sharedInstance] getDictionaryFromJSONString:attendStr];
    }
    else {
        bookmarkedBlogArr = [[NSMutableArray alloc] init];
    }
    
    if (isBookmarkedView) {
        contentArr = bookmarkedBlogArr;
    }
    else {
        
        [self startGetBlogService];
        
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showBlogDetailSegue"]) {
        BlogDetailViewController* controller = [segue destinationViewController];
        controller.contentDetailDict = selectedDict;
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


#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return contentArr.count;
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
    
    cell.descriptionTxtView.editable = NO;
    cell.descriptionTxtView.userInteractionEnabled = NO;
    
    //POPULATE CONTENT
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:[contentArr objectAtIndex:indexPath.row]];
    
    cell.headingLabel.text = [dict valueForKey:@"TITLE"];
    cell.profileNameLabel.text = [dict valueForKey:@"NAME_BLOGGER"];
    cell.dateLabel.text = [dict valueForKey:@"DATE_CREATED"];
    cell.descriptionTxtView.text = [dict valueForKey:@"DESCRIPTION"];
    
    cell.readMoreButton.tag = indexPath.row;
    [cell.readMoreButton addTarget:self action:@selector(readMoreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    if (isBookmarkedView) {
        cell.bookmarkButton.hidden = YES;
    }
    else {
        cell.bookmarkButton.hidden = NO;
        cell.bookmarkButton.tag = indexPath.row;
        [cell.bookmarkButton addTarget:self action:@selector(bookmarkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([bookmarkedBlogArr containsObject:dict]) {
            [cell.bookmarkButton setSelected:YES];
        }
        else {
            [cell.bookmarkButton setSelected:NO];
        }
    }
    
    if ([dict valueForKey:@"IMAGE"] && ![[dict valueForKey:@"IMAGE"] isEqual:[NSNull null]]) {
        __weak UIImageView* weakImageView = cell.contentImgView;
        
        NSString* imgStr = [[NSString stringWithFormat:@"http://beecheerup.in/Admin/Uploads/Upload_Blog/%@",[dict valueForKey:@"IMAGE"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.contentImgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imgStr]
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



- (void) startGetBlogService {
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    
    DataSyncManager* manager = [[DataSyncManager alloc] init];
    manager.serviceKey = kGetAllBlogsService;
    manager.delegate = self;
    [manager startGETWebServices];
    
}


#pragma mark - DATASYNCMANAGER Delegates

-(void) didFinishServiceWithSuccess:(id)responseData andServiceKey:(NSString *)requestServiceKey {
    
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"Success!"];
    
    if ([requestServiceKey isEqualToString:kGetAllBlogsService]) {
        
        contentArr = [[NSMutableArray alloc] initWithArray:[responseData valueForKey:@"blog"]];
        [self.contentTableView reloadData];
        
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


- (void) bookmarkButtonTapped:(UIButton *)button {
    
    if ([bookmarkedBlogArr containsObject:[contentArr objectAtIndex:button.tag]]) {
        [bookmarkedBlogArr removeObject:[contentArr objectAtIndex:button.tag]];
        [button setSelected:NO];
    }
    else {
        [bookmarkedBlogArr addObject:[contentArr objectAtIndex:button.tag]];
        [button setSelected:YES];
    }
    
    if (bookmarkedBlogArr.count>0) {
        NSError* error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bookmarkedBlogArr options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[SharedClass sharedInstance] saveBookmarkData:jsonString];
    }
    
}

- (void) readMoreButtonTapped:(UIButton *) button {
    
    selectedDict = [contentArr objectAtIndex:button.tag];
    [self performSegueWithIdentifier:@"showBlogDetailSegue" sender:nil];
    
}

@end
