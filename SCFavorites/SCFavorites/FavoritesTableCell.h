//
//  FavoritesTableCell.h
//  SCFavorites
//
//  Created by Prakash Donga on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaveView.h"
#import "HJObjManager.h"

#define VARIABLE_SPACE_Y 4
#define VARIABLE_SPACE_X 2
#define LikeCommentCountLabel_H 12
#define TitleLabel_W 278
#define TitleLableFont [UIFont boldSystemFontOfSize:16.0]
#define FAVORITES_CELL_HEIGHT (3 * VARIABLE_SPACE_Y + WaveView_H + LikeCommentCountLabel_H)
#define Image_H 12
#define PlayImage_X 10
#define CountLabelfFont [UIFont systemFontOfSize:12]
#define CountLabel_W 40
#define CountLabel_H 12

#define PLAY_BUTTON_H_W 30

@interface FavoritesTableCell : UITableViewCell
{
    WaveView *waveView;
    UILabel *trackTitleLabel;
    
    UILabel *playCountLabel;
    UILabel *commentCountLabel;
    UILabel *favoriteCountLabel;
    
    UIImageView *playImageView;
    UIImageView *commentImageView;
    UIImageView *favoritesImageView;
    
    NSDictionary *track;
}

@property (nonatomic, strong) WaveView *waveView;
@property (nonatomic, strong) UILabel *trackTitleLabel;
@property (nonatomic, strong) UILabel *playCountLabel;
@property (nonatomic, strong) UILabel *commentCountLabel;
@property (nonatomic, strong) UILabel *favoriteCountLabel;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *favoritesImageView;
@property (nonatomic, strong) NSDictionary *track;

//Set the favorite image respectively
- (void) setFavoriteImage:(BOOL) isUserFav;
- (void) setValuesForTrack:(NSDictionary *) tmptrack;
- (void) setTrackComments:(NSArray *) trackComments;
- (void) playButtonPressed:(id) sender;

@end