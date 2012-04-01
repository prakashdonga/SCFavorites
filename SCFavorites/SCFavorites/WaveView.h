//
//  WaveView.h
//  SCFavorites
//
//  Created by Prakash Donga on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJManagedImageV.h"
#import "HJObjManager.h"

#define WaveView_H 35
#define CommentUseImage_H 10

#define HJImageView_W 320.0

#define WaveViewFrame CGRectMake(0.0, 0.0, 320.0, WaveView_H)
#define HJImageViewFrame CGRectMake(0.0, 0.0, HJImageView_W, WaveView_H - CommentUseImage_H)

#define DUR_VIEW_W 60
#define DUR_VIEW_H 16

@interface WaveView : UIView
{
    HJManagedImageV *hjImageView;
    NSArray *trackComments;
    
    //This indicates that one pixel is equal to how many seconds/duration of track
    float onePxEqlsToDuration;
    
    //This indicates the total duration
    float trackDuration;

    UIView *orangeView;
    
    BOOL didBeganTouch;
    CGPoint beganTouchPoint;
    
    UIView *durShowView;
    UILabel *durLabel;
    
    UIView *commentImageContainer;
    
    NSMutableDictionary *commentMapWithDur;
}

@property (nonatomic, strong) HJManagedImageV *hjImageView;
@property (nonatomic, strong) NSArray *trackComments;
@property (nonatomic, strong) UIView *orangeView;
@property (nonatomic, strong) UIView *durShowView;
@property (nonatomic, strong) UILabel *durLabel;
@property (nonatomic, strong) UIView *commentImageContainer;
@property (nonatomic, strong) NSMutableDictionary *commentMapWithDur;

//Set the waveform URL and set manager to manage and download it
- (void) setHjImage:(NSURL *) url forMangeObj:(HJObjManager *) manager;
//Set the track duration
- (void) setTrackDuration:(float) duration;
//Clear the color that is fill in the track waveform
- (void) clearOrangeView;
//Get the display duration on basis of touch pixel/point
- (NSString *) getDisplayDuration:(CGFloat) x;
@end
