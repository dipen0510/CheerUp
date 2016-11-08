//
//  BlogDetailViewController.m
//  CheerUp
//
//  Created by Dipen Sekhsaria on 28/10/16.
//  Copyright © 2016 stardeep. All rights reserved.
//

#import "BlogDetailViewController.h"
#import "BlogDetailTableViewCell.h"

@interface BlogDetailViewController ()

@end

@implementation BlogDetailViewController

@synthesize contentDetailDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tableViewCellsArray = [[NSMutableArray alloc] init];
    _contentTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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


#pragma mark - UITableView Datasource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* identifier = @"BlogDetailTableViewCell";
    BlogDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"BlogDetailTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    
    // Store table view cells in an array
    if (![tableViewCellsArray containsObject:cell]) {
        [tableViewCellsArray addObject:cell];
    }
    
    [self displayContentForCell:cell atIndexPath:indexPath];
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableViewCellsArray.count>0) {
        BlogDetailTableViewCell* cell = (BlogDetailTableViewCell*)[_contentTblView cellForRowAtIndexPath:indexPath];
        cell.descrtiptionTxtViewHeightConstraint.constant = [self height:[contentDetailDict valueForKey:@"DESCRIPTION"]];
        return 320.+[self height:[contentDetailDict valueForKey:@"DESCRIPTION"]];

    }
    return 0.0;
    
}

#pragma mark - UITableView Delegate -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
}

- (void) displayContentForCell:(BlogDetailTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    
    [cell.descriptionTxtView scrollRangeToVisible:NSMakeRange(0, 1)];
    cell.descriptionTxtView.editable = NO;
    cell.descriptionTxtView.userInteractionEnabled = NO;
    
    //POPULATE CONTENT
    
    cell.headingLabel.text = [contentDetailDict valueForKey:@"TITLE"];
    cell.profileNameLabel.text = [contentDetailDict valueForKey:@"NAME_BLOGGER"];
    cell.dateLabel.text = [contentDetailDict valueForKey:@"DATE_CREATED"];
    cell.descriptionTxtView.text = [contentDetailDict valueForKey:@"DESCRIPTION"];
    
    cell.bookmarkButton.hidden = YES;
    cell.readMoreButton.hidden = YES;
    
    if ([contentDetailDict valueForKey:@"IMAGE"] && ![[contentDetailDict valueForKey:@"IMAGE"] isEqual:[NSNull null]]) {
        __weak UIImageView* weakImageView = cell.contentImgView;
        
        NSString* imgStr = [[NSString stringWithFormat:@"http://beecheerup.in/Admin/Uploads/Upload_Blog/%@",[contentDetailDict valueForKey:@"IMAGE"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
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


// put ur height calculation method
-(float)height :(NSString*)string
{
    /*
     NSString *stringToSize = [NSString stringWithFormat:@"%@", string];
     // CGSize constraint = CGSizeMake(LABEL_WIDTH - (LABEL_MARGIN *2), 2000.f);
     CGSize maxSize = CGSizeMake(280, MAXFLOAT);//set max height //set the constant width, hear MAXFLOAT gives the maximum height
     
     CGSize size = [stringToSize sizeWithFont:[UIFont systemFontOfSize:20.0f] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
     return size.height; //finally u get the correct height
     */
    //commenting the above code because "sizeWithFont: constrainedToSize:maxSize: lineBreakMode: " has been deprecated to avoid above code use below
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:string
                                                                         attributes:@
                                          {
                                          NSFontAttributeName: [UIFont systemFontOfSize:14.0]
                                          }];
    
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.bounds.size.width - 16, MAXFLOAT}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];//you need to specify the some width, height will be calculated
    CGSize requiredSize = rect.size;
    return requiredSize.height; //finally u return your height
}


@end
