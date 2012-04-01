//
//  FavoritesVC.m
//  SCFavorites
//
//  Created by Prakash Donga on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesVC.h"
#import "SCAPI.h"
#import "SCUI.h"
#import "LoginVC.h"
#import "JSONKit.h"
#import "UIColor+SoundCloudUI.h"
#import "AppDelegate.h"
#import "FavoritesTableCell.h"

#define kReleaseToReloadStatus 0
#define kPullToReloadStatus 1
#define kLoadingStatus 2

@implementation FavoritesVC
@synthesize tableview;
@synthesize tracks;
@synthesize trackComments;
@synthesize objMan;
@synthesize refreshHeaderView;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        //First set the track download offset and limit to the intial value
        [self setDnwDefaultValue];
        
        //Type to favorite listing default
        curTrackType = UserFavoriteTrackType;
        
        //Get the AppDel Image manage obj
        self.objMan = ((AppDelegate *)[UIApplication sharedApplication].delegate).objMan;
    }
    return self;
}

- (void)viewDidLoad
{
    // Initialization code
    [super viewDidLoad];
    self.title = @"Favorites";
    
    self.tracks = [NSMutableArray arrayWithCapacity:1];
    self.trackComments = [NSMutableDictionary dictionaryWithCapacity:1];
    
    self.tableview.separatorColor = [UIColor clearColor];
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.canCancelContentTouches = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bumpPattern.png"]];
        
    //Pull To Refresh view
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, 320.0f, self.view.bounds.size.height)];
    
    [self.tableview addSubview:self.refreshHeaderView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"All" 
                                                                             style:UIBarButtonItemStyleBordered 
                                                                            target:self action:@selector(leftBarButtonPressed:)];
    
    //Check for the login
    [self checkAuthentication];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    NSUInteger rowCount = self.tracks.count;
    if (isMoreTrackToLoad) {
        rowCount += 1;
    }
    return rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = nil;
    
    if (isMoreTrackToLoad && indexPath.row == self.tracks.count) 
    {
        static NSString *reuse = @"reuseLoadCell";
        UITableViewCell *loadCell = [tableview dequeueReusableCellWithIdentifier:reuse];
        if (loadCell == nil) 
        {
            loadCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:reuse];
            loadCell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            loadCell.textLabel.text = @"More Tracks...";
            loadCell.textLabel.textAlignment = UITextAlignmentCenter;
            loadCell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
            loadCell.textLabel.textColor = [UIColor whiteColor];
        }
        
        cell = loadCell;
    }
    else 
    {
        static NSString *reuseIdent = @"reuse";
        FavoritesTableCell *favCell = [tableview dequeueReusableCellWithIdentifier:reuseIdent];
        if (favCell == nil) 
        {
            favCell = [[FavoritesTableCell alloc] initWithStyle:UITableViewCellStyleValue1 
                                                reuseIdentifier:reuseIdent];
            favCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
        //Set the track and values
        [favCell setValuesForTrack:track];
        
        //Get the track comments on basis of TrackID and set to waveform view
        [favCell setTrackComments:[self.trackComments objectForKey:[track objectForKey:TRACK_ID_KEY]]];
        
        cell = favCell;    
    }
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if ((indexPath.row % 2) == 0)
        cell.backgroundColor = [UIColor colorWithWhite:0.1f alpha:1.0];
    else
        cell.backgroundColor = [UIColor colorWithWhite:0.15f alpha:1.0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    float height = 44.0;
    
    if (!(isMoreTrackToLoad && indexPath.row == self.tracks.count))
    {
        NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
        NSString *trackTitle = [track objectForKey:TRACK_TITLE_KEY];
        
        height = [FavoritesVC heightForString:trackTitle 
                                     withFont:TitleLableFont 
                                     andWidth:TitleLabel_W];
        if (height > 0) 
        {
            height += FAVORITES_CELL_HEIGHT;
        }
        else 
        {
            height = FAVORITES_CELL_HEIGHT;
        }        
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (isMoreTrackToLoad && indexPath.row == self.tracks.count) 
    {
        [self.activityIndicator startAnimating];
        self.tableview.userInteractionEnabled = NO;
        [self getTrackOfCurType];
    }
}

#pragma mark - General Methods

- (void) startSpinner 
{
    [self.activityIndicator startAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.tableview.userInteractionEnabled = NO;
}

- (void) stopSpinner 
{
    [self.activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.tableview.userInteractionEnabled = YES;
}

- (void) leftBarButtonPressed:(id) sender 
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Option." 
                                                             delegate:self cancelButtonTitle:nil
                                               destructiveButtonTitle:nil otherButtonTitles:@"Incoming Tracks", @"My Favorite Tracks", @"Cancel", nil];
    [actionSheet setDestructiveButtonIndex:2];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void) checkAuthentication
{
    if ([SCSoundCloud account] == nil) 
    {
        self.tracks = [NSMutableArray arrayWithCapacity:1];
        self.trackComments = [NSMutableDictionary dictionaryWithCapacity:1];
        
        LoginVC *loginVC = [LoginVC loginViewControllerWithHandler:^(BOOL isSuccess) {
            if (isSuccess) 
            {
                NSLog(@"Login Successfully. Get the user favourites track.");
                [self getTrackOfCurType];
            }
            else 
            {
                NSLog(@"Some problem in login");
                //
                [self showError:@"Some problem in login"];
            }
        }];
        
        [self.tabBarController presentModalViewController:loginVC animated:YES];
    }
    else 
    {
        [self getTrackOfCurType];
    }
}

- (void) setDnwDefaultValue
{
    trackDnwLimit = 6;
    trackDnwOffset = followingDnwOffset = 0;
    apiRequestCount = 0;
}


+ (float) heightForString:(NSString *) string withFont:(UIFont *)wfont andWidth:(float) width
{
	
	CGSize max = CGSizeMake(width, 1024);
	
	//Calucating the total height required
	CGSize size = [string sizeWithFont:wfont constrainedToSize:max lineBreakMode:UILineBreakModeWordWrap]; 
	
	//Setting frame according number of lines......
	return size.height;
}

- (void) showError:(NSString *) errorMsg 
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorMsg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView show];
} 

#pragma mark - SC API calls Methods

- (void) getTrackOfCurType
{
    if (!reloading) 
    {
        //Then show spinner
        [self startSpinner];
    }
    
    if (curTrackType == UserFavoriteTrackType) 
    {
        [self getNextFavoriteTrack];   
    }
    else if(curTrackType == UserIncomingTrackType) 
    {
        [self getFollowingList];
    }
}

- (void) getNextFavoriteTrack
{
    SCAccount *account = [SCSoundCloud account];
    if (account != nil)
    {
        NSString *requestURLStr = [NSString stringWithFormat:@"%@/me/favorites.json?limit=%d&offset=%d",API_HOST,trackDnwLimit, trackDnwOffset];
        //NSString *requestURLStr = [NSString stringWithFormat:@"%@/users/1861068/tracks.json?limit=%d&offset=%d",API_HOST,dnwLimit, dnwOffset];
        
        //Means user have valid access token
        [SCRequest performMethod:SCRequestMethodGET
                      onResource:[NSURL URLWithString:requestURLStr]
                 usingParameters:nil
                     withAccount:account
          sendingProgressHandler:nil
                 responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                     // Handle the response
                     if (error) 
                     {
                         NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                         [self showError:[error localizedDescription]];
                     } 
                     else 
                     {
                         // Check the statuscode and parse the data
                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                         int statusCode = [httpResponse statusCode]; 
                         if(statusCode > HTTP_ERROR_STATES_CODE_MAX || statusCode < HTTP_ERROR_STATES_CODE_MIN)
                         {
                             NSLog(@"Error Getting the data");
                             [self showError:@"Please try after some time."];
                         }	
                         else
                         {
                             //Data received
                             if (reloading) 
                             {
                                 self.tracks = [NSMutableArray arrayWithCapacity:1];
                                 self.trackComments = [NSMutableDictionary dictionaryWithCapacity:1];
                             }
                             
                             //Update Data Structure, and get the comments on the each tracks                             
                             NSArray *favoritesTracks = [[JSONDecoder decoderWithParseOptions:JKParseOptionValidFlags] objectWithData:data];
                             
                             if (favoritesTracks.count) 
                             {
                                 
                                 //Means tracks are received, Update the track data structure
                                 [self.tracks addObjectsFromArray:favoritesTracks];
                                 
                                 //Get the track comments if commenct count is greater then zero
                                 for (NSDictionary *track in self.tracks) 
                                 {
                                     id commentCount = [track objectForKey:TRACK_COMMENT_COUNT_KEY];
                                     if(![commentCount isEqual:[NSNull null]])
                                     {
                                         if ([commentCount intValue]) 
                                         {
                                             [self getCommentsForTrack:track];
                                         }
                                     }
                                     
                                 }
                                 
                                 //Check for more track to load
                                 //If the downloaded track comes less compared to the download limit then no more downloads and comes equal then may OR may not be more track to download
                                 if (favoritesTracks.count < trackDnwLimit) 
                                 {
                                     isMoreTrackToLoad = NO;
                                 }
                                 else 
                                 {
                                     isMoreTrackToLoad = YES;
                                     
                                     //User Favorites tracks getted. //Update the download offset
                                     trackDnwOffset += trackDnwLimit;
                                 }
                             }
                             else 
                             {
                                 isMoreTrackToLoad = NO;
                                 [self updateUI];
                             }
                        }
                     }
                 }];
    }
    else 
    {
        //Appear the login Screen
        [self checkAuthentication];
    }
}

- (void) getFollowingList
{
    SCAccount *account = [SCSoundCloud account];
    if (account != nil)
    {
        //For each following we will show latest two
        NSUInteger dwnLoadLimit = trackDnwLimit / 2;
        if (dwnLoadLimit < 2) 
        {
            dwnLoadLimit = 2;
        }
        
        NSString *requestURLStr = [NSString stringWithFormat:@"%@/me/followings.json?limit=%d&offset=%d",API_HOST,dwnLoadLimit , followingDnwOffset];        
        //Means user have valid access token
        [SCRequest performMethod:SCRequestMethodGET
                      onResource:[NSURL URLWithString:requestURLStr]
                 usingParameters:nil
                     withAccount:account
          sendingProgressHandler:nil
                 responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                     // Handle the response
                     if (error) 
                     {
                         NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                         [self showError:[error localizedDescription]];
                         [self stopSpinner];
                     } 
                     else 
                     {
                         // Check the statuscode and parse the data
                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                         int statusCode = [httpResponse statusCode]; 
                         if(statusCode > HTTP_ERROR_STATES_CODE_MAX || statusCode < HTTP_ERROR_STATES_CODE_MIN)
                         {
                             NSLog(@"Error Getting the data");
                             [self showError:@"Please try after some time."];
                         }	
                         else
                         {
                             
                             //Data received - Now if it is due to reloading then update the data structure to new object
                             if (reloading) 
                             {
                                 self.tracks = [NSMutableArray arrayWithCapacity:1];
                                 self.trackComments = [NSMutableDictionary dictionaryWithCapacity:1];
                             }
                             
                             //Update Data Structure, and get the comments on the each tracks                             
                             NSArray *followingList = [[JSONDecoder decoderWithParseOptions:JKParseOptionValidFlags] objectWithData:data];
                             
                             if (followingList.count) 
                             {
                                 for (NSDictionary *following in followingList) 
                                 {
                                     NSLog(@"%@",following);
                                     id userID = [following objectForKey:FOLLOWING_ID_KEY];
                                     if (![userID isEqual:[NSNull null]]) 
                                         [self getTrackForUserID:(NSString *)userID];
                                 }
                                 
                                 if (followingList.count < dwnLoadLimit) 
                                 {
                                     isMoreTrackToLoad = NO;
                                 }
                                 else 
                                 {
                                     isMoreTrackToLoad = YES;
                                     
                                     //User Favorites tracks getted. //Update the download offset
                                     followingDnwOffset += dwnLoadLimit;
                                 }
                             }
                             else 
                             {
                                 isMoreTrackToLoad = NO;
                                 
                                 //Update the UI
                                 [self updateUI];
                             }
                        }
                     }
                 }];

    }
    else 
    {
        [self checkAuthentication];
    }
}

- (void) getTrackForUserID:(NSString *) userID 
{    
    //increment the comment counter when called.
    apiRequestCount++;
    
    //Download limit for incoming track
    NSUInteger incomingTrackDwnLimit = 2;
    NSUInteger incomingTrackDwnOffset = 0;
    
    SCAccount *account = [SCSoundCloud account];
    if (account != nil)
    {
        NSString *requestURLStr = [NSString stringWithFormat:@"%@/users/%@/tracks.json?limit=%d&offset=%d",API_HOST, userID,incomingTrackDwnLimit , incomingTrackDwnOffset];
        
        //Means user have valid access token
        [SCRequest performMethod:SCRequestMethodGET
                      onResource:[NSURL URLWithString:requestURLStr]
                 usingParameters:nil
                     withAccount:account
          sendingProgressHandler:nil
                 responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                     
                     //Response received so decrease the request count
                     apiRequestCount--;
                     
                     // Handle the response
                     if (error) 
                     {
                         NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                         [self showError:[error localizedDescription]];
                         [self stopSpinner];
                     } 
                     else 
                     {                         
                         // Check the statuscode and parse the data
                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                         int statusCode = [httpResponse statusCode]; 
                         if(statusCode > HTTP_ERROR_STATES_CODE_MAX || statusCode < HTTP_ERROR_STATES_CODE_MIN)
                         {
                             NSLog(@"Error Getting the data");
                             [self showError:@"Please try after some time."];
                         }	
                         else
                         {                             
                             //Update Data Structure, and get the comments on the each tracks                             
                             NSArray *followingTracks = [[JSONDecoder decoderWithParseOptions:JKParseOptionValidFlags] objectWithData:data];
                             
                             if (followingTracks.count) 
                             {                                 
                                 //Means tracks are received, Update the track data structure
                                 [self.tracks addObjectsFromArray:followingTracks];
                                 
                                 if (apiRequestCount == 0) {
                                     
                                     //Comment request are called So set the request count to zero
                                     
                                     //Get the track comments if commenct count is greater then zero
                                     for (NSDictionary *track in self.tracks) 
                                     {
                                         id commentCount = [track objectForKey:TRACK_COMMENT_COUNT_KEY];
                                         if(![commentCount isEqual:[NSNull null]])
                                         {
                                             if ([commentCount intValue]) 
                                             {
                                                 [self getCommentsForTrack:track];
                                             }
                                         }
                                     }         
                                 }                                 
                            }
                        }
                     }
                 }];
    }
    else 
    {
        //Appear the login Screen
        [self checkAuthentication];
    }
    
}

- (void) getCommentsForTrack:(NSDictionary *) track 
{
    
    SCAccount *account = [SCSoundCloud account];
    if (account != nil)
    {        
        //increment the comment counter when called.
        apiRequestCount++;
        
        NSString *trackId = [track objectForKey:TRACK_ID_KEY];
        NSString *requestURLStr = [NSString stringWithFormat:@"%@/tracks/%@/comments.json",API_HOST,trackId];
        
        //Means user have valid access token
        [SCRequest performMethod:SCRequestMethodGET
                      onResource:[NSURL URLWithString:requestURLStr]
                 usingParameters:nil
                     withAccount:account
          sendingProgressHandler:nil
                 responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                     
                     //Response received so decrease the request count
                     apiRequestCount--;
                     
                     if (error) 
                     {
                         [self showError:[error localizedDescription]];
                         [self stopSpinner];                         
                     }
                     else 
                     {
                         // Check the statuscode and parse the data
                         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                         int statusCode = [httpResponse statusCode]; 
                         if(statusCode > HTTP_ERROR_STATES_CODE_MAX || statusCode < HTTP_ERROR_STATES_CODE_MIN)
                         {
                             NSLog(@"Error Getting the data");
                             [self showError:@"Please try after some time."];
                         }	
                         else
                         {
                             NSArray *comments = [[JSONDecoder decoderWithParseOptions:JKParseOptionValidFlags] objectWithData:responseData];
                             
                             if (comments.count) 
                             {                                 
                                 [self.trackComments setObject:comments forKey:trackId];
                             }
                         }    
                     }
                     
                     if (apiRequestCount == 0) {
                         //Request count is zero means all data are now available update the UI
                         [self updateUI];
                     }
                     
                 }];
    }
}

#pragma mark - Update UI

- (void) updateUI
{
    if (reloading) 
    {
        [self dataSourceDidFinishLoadingNewData];
    }

    [self.tableview reloadData];
    [self stopSpinner];
}


#pragma mark State Changes

- (void) showReloadAnimationAnimated:(BOOL)animated
{
    self.tableview.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
	reloading = YES;
	[refreshHeaderView toggleActivityView:YES];
	[refreshHeaderView setLastUpdatedDate:[NSDate date]];
    
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableview.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
	else
	{
		self.tableview.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
	}
}


- (void) dataSourceDidFinishLoadingNewData
{
	reloading = NO;
	[refreshHeaderView flipImageAnimated:NO];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.tableview setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[refreshHeaderView setStatus:kPullToReloadStatus];
	[refreshHeaderView toggleActivityView:NO];
	[UIView commitAnimations];
}


#pragma mark - Scrolling Overrides

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (!reloading)
	{
		checkForRefresh = YES;  //  only check offset when dragging 
	}
} 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	if (reloading) return;
	
	if (checkForRefresh) {
		if (refreshHeaderView.isFlipped && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !reloading) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kPullToReloadStatus];
            
		} 
        else if (!refreshHeaderView.isFlipped && scrollView.contentOffset.y < -65.0f) {
			[refreshHeaderView flipImageAnimated:YES];
			[refreshHeaderView setStatus:kReleaseToReloadStatus];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (reloading) return;
	
	if (scrollView.contentOffset.y <= - 65.0f) 
    {
        [self showReloadAnimationAnimated:YES];
        [self setDnwDefaultValue];
        [self getTrackOfCurType];
	} 
    
	checkForRefresh = NO;
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if ((buttonIndex == 0 || buttonIndex == 1) && curTrackType != buttonIndex) 
    {
        curTrackType = buttonIndex;
        [self setDnwDefaultValue];
        self.tracks = [NSMutableArray arrayWithCapacity:1];
        self.trackComments = [NSMutableDictionary dictionaryWithCapacity:1];
        [self performSelector:@selector(getTrackOfCurType) 
                   withObject:nil afterDelay:.025];        
    }
}


@end
