//
//  FavoritesVC.h
//  SCFavorites
//
//  Created by Prakash Donga on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJObjManager.h"
#import "EGORefreshTableHeaderView.h"

typedef enum {
    
    UserIncomingTrackType = 0,
    UserFavoriteTrackType = 1
    
}TrackListingTypes;

@interface FavoritesVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView *tableview;
    NSMutableArray *tracks;
    NSMutableDictionary *trackComments;
    
    NSUInteger trackDnwOffset;
    NSUInteger followingDnwOffset;
    NSUInteger trackDnwLimit;
    BOOL isMoreTrackToLoad;

    NSUInteger apiRequestCount;
    
    HJObjManager *objMan;

    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL checkForRefresh;
	BOOL reloading;

    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    TrackListingTypes curTrackType;
}

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *tracks;
@property (nonatomic, strong) NSMutableDictionary *trackComments;
@property (nonatomic, strong) HJObjManager *objMan;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

//Method to check the authentication with SoundCloud
- (void) checkAuthentication;
//Method to fetch the tracks
- (void) getNextFavoriteTrack;
//Method to fetch comments of a track
- (void) getCommentsForTrack:(NSDictionary *) track;
//Method to update the UI
- (void) updateUI;
//Method to set default values for the downloads
- (void) setDnwDefaultValue;
//Get the required to set text in given width
+ (float) heightForString:(NSString *) string withFont:(UIFont *)wfont andWidth:(float) width;
//Shows the Error Message
- (void) showError:(NSString *) errorMsg;
//Gets the users following list
- (void) getFollowingList;
//Get the tracks for particular user
- (void) getTrackForUserID:(NSString *) userID;
//Calls the resqective API call/method on basis of current type
- (void) getTrackOfCurType;
//
- (void) leftBarButtonPressed:(id) sender;
@end
