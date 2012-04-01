//
//  WaveView.m
//  SCFavorites
//
//  Created by Prakash Donga on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaveView.h"
#import "UIColor+SoundCloudUI.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "HJManagedImageV.h"

#define One_MIN_EQ_SEC 60

#define ONE_MILI_SEC 1000

@implementation WaveView
@synthesize hjImageView;
@synthesize trackComments;
@synthesize orangeView;
@synthesize durShowView;
@synthesize durLabel;
@synthesize commentImageContainer;
@synthesize commentMapWithDur;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.clipsToBounds = NO;
        
        self.orangeView = [[UIView alloc] initWithFrame:HJImageViewFrame];      
        self.orangeView.backgroundColor = [UIColor soundCloudOrange];
        [self addSubview:self.orangeView];
        
        [self clearOrangeView];  
        
        // Initialization code
        self.hjImageView = [[HJManagedImageV alloc] initWithFrame:HJImageViewFrame];
        [self addSubview:self.hjImageView];
        
        self.durShowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -1.0 * DUR_VIEW_H, DUR_VIEW_W, DUR_VIEW_H)];
        self.durShowView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
        self.durShowView.layer.borderWidth = 1.0;
        self.durShowView.alpha = 0.0;
        self.durShowView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self addSubview:self.durShowView];
        
        self.durLabel = [[UILabel alloc] initWithFrame:CGRectMake(2.0, 2.0, DUR_VIEW_W - 4.0, DUR_VIEW_H - 4.0)];
        self.durLabel.font = [UIFont systemFontOfSize:12.0];
        self.durLabel.textColor = [UIColor soundCloudOrange];
        self.durLabel.adjustsFontSizeToFitWidth = YES;
        self.durLabel.minimumFontSize = 10.0;
        [self.durShowView addSubview:self.durLabel];
        
    }
    return self;
}

- (void) setHjImage:(NSURL *) url forMangeObj:(HJObjManager *) manager
{
    [self.hjImageView needCropingToSize:CGSizeMake(320.0, 25.0)];
    [self.hjImageView clear];
    [self.hjImageView showLoadingWheel];
    [self.hjImageView setUrl:url];
    [manager manage:self.hjImageView];
}

- (void) setTrackDuration:(float) duration 
{
    trackDuration = duration;
    onePxEqlsToDuration = trackDuration / HJImageView_W;

//    trackDurationInSec = duration / ONE_MILI_SEC;
//    onePxEqlsToDurInSec = trackDurationInSec / HJImageView_W;
//    trackDurationInMin = trackDurationInSec / One_MIN_EQ_SEC;
//    onePxEqlsToDurInMin = trackDurationInMin / HJImageView_W;
    //NSLog(@"trackDuration %f  onePxEqlsToDuration %f", trackDurationInSec, onePxEqlsToDurInSec);
}

- (void) setTrackComments:(NSArray *) tmpTrackComments
{
    trackComments = tmpTrackComments;
    
    //Comment showing on user move hand
    
    
/*
    //Image showing Logic not working as it create the sluggish UI.
    //Image rendering is on Main thread, on each cell, So need to find best approach
    //As on scrolling each cell will set its on comment images for appear on Visible Area
 
    self.commentImageContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0, HJImageViewFrame.size.height, HJImageView_W, CommentUseImage_H)];
    [self.commentImageContainer setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.commentImageContainer];
    
    self.commentMapWithDur = [NSMutableDictionary dictionaryWithCapacity:1];
    
    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSBundle *scBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"SoundCloud" 
                                                                                  ofType:@"bundle"]];
    NSString *avtarImagePath = [scBundle pathForResource:@"default-avatar" ofType:@"png"];
    for (NSDictionary *comment in self.trackComments) 
    {
        id userURLstr = [[comment objectForKey:USER_KEY] objectForKey:AVATAR_KEY];
        id commentTimeStamp = [comment objectForKey:COMMENT_TIMESTAMP_KEY];
        if (![userURLstr isEqual:[NSNull null]] && ![commentTimeStamp isEqual:[NSNull null]])
        {
            NSUInteger x = [self getPointFromDuration:[commentTimeStamp floatValue]];
            
            HJManagedImageV *userAvtar = [[HJManagedImageV alloc] initWithFrame:CGRectMake(x, 0.0, CommentUseImage_H, CommentUseImage_H)];
            [userAvtar setUrl:[NSURL URLWithString:userURLstr]];
            userAvtar.image = [UIImage imageWithContentsOfFile:avtarImagePath];
            [appDel.objMan manage:userAvtar];
            
            [self.commentImageContainer addSubview:userAvtar];
        }
    }
 */
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesBegan:touches withEvent:event];
    didBeganTouch = YES;
    
    UITouch *touch = [[event allTouches] anyObject];
    beganTouchPoint = [touch locationInView:self];
    
    CGRect orangeViewFrame = self.orangeView.frame;
    orangeViewFrame.size.width = beganTouchPoint.x;

    CGRect durShowViewFrame = self.durShowView.frame;
    float halfOfWidth =  durShowViewFrame.size.width / 2.0;
    if (beganTouchPoint.x >  halfOfWidth && beganTouchPoint.x <  HJImageView_W - halfOfWidth) 
    {
        durShowViewFrame.origin.x = beganTouchPoint.x - halfOfWidth;
    }
    else 
    {
        durShowViewFrame.origin.x  = (beganTouchPoint.x <= halfOfWidth)?0:(HJImageView_W - durShowViewFrame.size.width);
    }
    
    self.durShowView.alpha = 1.0;
    self.durLabel.text = [self getDisplayDuration:beganTouchPoint.x];
    
    
    [UIView animateWithDuration:.15 
                     animations:^{
                         self.durShowView.frame = durShowViewFrame;
                         self.orangeView.frame = orangeViewFrame;
                     }];
    
    self.durLabel.text = [self getDisplayDuration:beganTouchPoint.x];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesMoved:touches withEvent:event];
    //NSLog(@"touchesMoved");
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint movedPoint = [touch locationInView:self];
    
    CGRect orangeViewFrame = self.orangeView.frame;

    if (movedPoint.x > HJImageView_W - 3)
        movedPoint.x = HJImageView_W;
    if (movedPoint.x < 3) 
        movedPoint.x = 0;
        
    orangeViewFrame.size.width = movedPoint.x;
    self.orangeView.frame = orangeViewFrame;
    
    CGRect durShowViewFrame = self.durShowView.frame;
    float halfOfWidth =  durShowViewFrame.size.width / 2.0;
    if (movedPoint.x >  halfOfWidth && movedPoint.x < HJImageView_W - halfOfWidth) 
    {
        durShowViewFrame.origin.x = movedPoint.x - halfOfWidth;
    }
    else 
    {
        durShowViewFrame.origin.x = (movedPoint.x <= halfOfWidth)?0:(HJImageView_W - durShowViewFrame.size.width);
    }
    
    self.durShowView.frame = durShowViewFrame;
    self.durLabel.text = [self getDisplayDuration:movedPoint.x];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesEnded:touches withEvent:event];
    didBeganTouch = NO;

    [UIView animateWithDuration:2.5 
                     animations:^{
                         self.durShowView.alpha = 0.0;
                     }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesCancelled:touches withEvent:event];
    didBeganTouch = NO;
    [UIView animateWithDuration:2.5 
                     animations:^{
                         self.durShowView.alpha = 0.0;
                     }];
}

#pragma mark - GeneralMethod

- (void) clearOrangeView
{
    CGRect orangeViewFrame = self.orangeView.frame;
    orangeViewFrame.size.width = 0.0;
    self.orangeView.frame = orangeViewFrame;
}

- (NSString *) getDisplayDuration:(CGFloat) x 
{
    //NSLog(@"%lf",x);
    return [NSString stringWithFormat:@"%.2f/%.2f", x * (onePxEqlsToDuration / (1000  * 60)) , trackDuration / (1000 * 60)];
}

- (NSUInteger) getPointFromDuration:(float) duratoin
{
    NSUInteger x = (NSUInteger)(duratoin / onePxEqlsToDuration);
    NSLog(@"%d %f",x,duratoin);
    return x;
}

@end
