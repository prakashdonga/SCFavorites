//
//  FavoritesTableself.m
//  SCFavorites
//
//  Created by Prakash Donga on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesTableCell.h"
#import "AppDelegate.h"

@implementation FavoritesTableCell
@synthesize waveView;
@synthesize trackTitleLabel;
@synthesize playCountLabel;
@synthesize commentCountLabel;
@synthesize favoriteCountLabel;
@synthesize playImageView;
@synthesize commentImageView;
@synthesize favoritesImageView;
@synthesize track;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        
        self.trackTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.0, 2.0, TitleLabel_W, 0.0)];
        self.trackTitleLabel.font = TitleLableFont;
        self.trackTitleLabel.backgroundColor = [UIColor clearColor];
        self.trackTitleLabel.numberOfLines = 0;
        self.trackTitleLabel.adjustsFontSizeToFitWidth = NO;
        self.trackTitleLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:self.trackTitleLabel];
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setFrame:CGRectMake(320 - PLAY_BUTTON_H_W - VARIABLE_SPACE_X, VARIABLE_SPACE_Y, PLAY_BUTTON_H_W, PLAY_BUTTON_H_W)];
        [playButton setImage:[UIImage imageNamed:@"play_large.png"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playButtonPressed:) 
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton];
        
        
        self.playCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CountLabel_W, CountLabel_H)];
        self.playCountLabel.font = CountLabelfFont;
        self.playCountLabel.adjustsFontSizeToFitWidth = YES;
        self.playCountLabel.minimumFontSize = 10;
        self.playCountLabel.textColor = [UIColor whiteColor];
        self.playCountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.playCountLabel];
        
        self.commentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CountLabel_W, CountLabel_H)];
        self.commentCountLabel.font = CountLabelfFont;
        self.commentCountLabel.adjustsFontSizeToFitWidth = YES;
        self.commentCountLabel.minimumFontSize = 10;
        self.commentCountLabel.textColor = [UIColor whiteColor];
        self.commentCountLabel.backgroundColor = [UIColor clearColor];        
        [self addSubview:self.commentCountLabel];
        
        self.favoriteCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CountLabel_W, CountLabel_H)];
        self.favoriteCountLabel.font = CountLabelfFont;
        self.favoriteCountLabel.adjustsFontSizeToFitWidth = YES;
        self.favoriteCountLabel.minimumFontSize = 10;
        self.favoriteCountLabel.textColor = [UIColor whiteColor];
        self.favoriteCountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.favoriteCountLabel];
        
        self.playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_count.png"]];
        self.playImageView.frame = CGRectMake(0.0, 0.0, Image_H, Image_H);
        [self addSubview:self.playImageView];
        
        self.commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_count.png"]];
        self.commentImageView.frame = CGRectMake(0.0, 0.0, Image_H, Image_H);
        [self addSubview:self.commentImageView];
        
        self.favoritesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart_deselect.png"]];
        self.favoritesImageView.frame = CGRectMake(0.0, 0.0, Image_H, Image_H);
        [self addSubview:self.favoritesImageView];
       
        self.waveView = [[WaveView alloc] initWithFrame:WaveViewFrame];
        [self addSubview:self.waveView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews 
{
    [super layoutSubviews];
    
    //Set the top position
    CGRect waveFrmRect = self.waveView.frame;
    waveFrmRect.origin.y = self.frame.size.height - waveFrmRect.size.height;
    
    self.waveView.frame = waveFrmRect;

    //Set the top position
    CGRect titleLabelRect = self.trackTitleLabel.frame;
    titleLabelRect.origin.y = VARIABLE_SPACE_Y;
    titleLabelRect.size.height = self.frame.size.height - FAVORITES_CELL_HEIGHT;
    
    self.trackTitleLabel.frame = titleLabelRect;
    
    CGRect iconFrame = self.playImageView.frame;
    iconFrame.origin.x = PlayImage_X;
    iconFrame.origin.y = titleLabelRect.origin.y + titleLabelRect.size.height + VARIABLE_SPACE_Y;
    
    self.playImageView.frame = iconFrame;

    CGRect countLblFrame = self.playCountLabel.frame;
    countLblFrame.origin.x = iconFrame.origin.x + iconFrame.size.width + VARIABLE_SPACE_X;
    countLblFrame.origin.y = titleLabelRect.origin.y + titleLabelRect.size.height + VARIABLE_SPACE_Y;
    
    self.playCountLabel.frame = countLblFrame;
    
    iconFrame.origin.x = countLblFrame.origin.x + countLblFrame.size.width + 2 * VARIABLE_SPACE_X;
    self.commentImageView.frame = iconFrame;
    
    countLblFrame.origin.x = iconFrame.origin.x + iconFrame.size.width + VARIABLE_SPACE_X;
    self.commentCountLabel.frame = countLblFrame;

    iconFrame.origin.x = countLblFrame.origin.x + countLblFrame.size.width + 2 * VARIABLE_SPACE_X;
    self.favoritesImageView.frame = iconFrame;
    
    countLblFrame.origin.x = iconFrame.origin.x + iconFrame.size.width + VARIABLE_SPACE_X;
    self.favoriteCountLabel.frame = countLblFrame;

}

- (void) setFavoriteImage:(BOOL) isUserFav 
{
    if (isUserFav) 
    {
        self.favoritesImageView.image = [UIImage imageNamed:@"heart_select.png"];
    }
    else 
    {
        self.favoritesImageView.image = [UIImage imageNamed:@"heart_deselect.png"];   
    }
}

- (void) setValuesForTrack:(NSDictionary *) tmptrack
{
    self.track = tmptrack;
    
    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSURL *waveFormURL = [NSURL URLWithString:[track objectForKey:TRACK_WAVEFORM_URL_KEY]];
    [self.waveView setHjImage:waveFormURL forMangeObj:appDel.objMan];

    [self.waveView clearOrangeView];
    
    NSString *trackTitle = [track objectForKey:TRACK_TITLE_KEY];
    self.trackTitleLabel.text = trackTitle;
    
    //Set its user favorites
    id isUserFavorite = [track objectForKey:TRACK_USER_FAV_KEY];
    if(![isUserFavorite isEqual:[NSNull null]])
    {
        [self setFavoriteImage:[isUserFavorite boolValue]];
    }
    else 
    {
        [self setFavoriteImage:NO];
    }    
    
    //Set play count
    id playCount = [track objectForKey:TRACK_PLAY_COUNT_KEY];
    if (![playCount isEqual:[NSNull null]]) 
    {
        self.playCountLabel.text = [playCount stringValue];
    }
    else 
    {
        self.playCountLabel.text = @"0";
    }
    
    //Set Comment count
    id commentCount = [track objectForKey:TRACK_COMMENT_COUNT_KEY];
    if (![commentCount isEqual:[NSNull null]]) 
    {
        self.commentCountLabel.text = [commentCount stringValue];
    }
    else 
    {
        self.commentCountLabel.text = @"0";
    }
    
    //Set play count
    id favorCount = [track objectForKey:TRACK_FAV_COUNT_KEY];
    if (![favorCount isEqual:[NSNull null]]) 
    {
        self.favoriteCountLabel.text = [favorCount stringValue];
    }
    else 
    {
        self.favoriteCountLabel.text = @"0";
    }

    id trackDuration = [track objectForKey:TRACK_DURATION_KEY];
    if (![trackDuration isEqual:[NSNull null]]) 
    {
        [self.waveView setTrackDuration:[trackDuration floatValue]];
    }
}

- (void) setTrackComments:(NSArray *) trackComments 
{
    self.waveView.trackComments = trackComments;
}

- (void) playButtonPressed:(id) sender 
{
    UIApplication *app = [UIApplication sharedApplication];
    
    NSString *trackID = [self.track objectForKey:TRACK_ID_KEY];
    NSURL *soundCloudAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"soundcloud:track:%@",trackID]];
    if ([app canOpenURL:soundCloudAppURL]) 
    {
        [app openURL:soundCloudAppURL];
    }
    else 
    {
        id urlString = [track objectForKey:TRACK_SC_URL];
        if (![urlString isEqual:[NSNull null]]) 
        {
            soundCloudAppURL = [NSURL URLWithString:urlString];
            [app openURL:soundCloudAppURL];
        }    
    }
}

@end
