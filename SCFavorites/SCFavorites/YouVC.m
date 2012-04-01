//
//  YouVC.m
//  SCFavorites
//
//  Created by Prakash Donga on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YouVC.h"
#import "UIColor+SoundCloudUI.h"
#import "SCAPI.h"

#define LogoutAlertViewTag 352

@implementation YouVC
@synthesize tableview;
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"You";
    
    self.dataArray = [NSArray arrayWithObject:@"Logout"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *reuseIdent = @"reuse";
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:reuseIdent];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                         reuseIdentifier:reuseIdent];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) 
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logout" 
                                                           message:@"Do you want to logout?" 
                                                          delegate:self 
                                                 cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [alertView show];
        alertView.tag = LogoutAlertViewTag;
    }
}   

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (alertView.tag == LogoutAlertViewTag)
    {
        if (buttonIndex == 1) 
        {
            [SCSoundCloud removeAccess];
            
            //Tell Favorites to show login View
            FavoritesVC *favoritesVC = (FavoritesVC *)[[[self.tabBarController viewControllers] objectAtIndex:0] visibleViewController];
            [favoritesVC checkAuthentication];
            [favoritesVC setDnwDefaultValue];
            [favoritesVC updateUI];
            
            [self.tabBarController setSelectedIndex:0];
        }
    }
}

@end
