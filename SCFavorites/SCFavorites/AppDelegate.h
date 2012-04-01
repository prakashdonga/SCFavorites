//
//  AppDelegate.h
//  SCFavorites
//
//  Created by Prakash Donga on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJObjManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabViewController;
@property (strong, nonatomic) HJObjManager *objMan;

+ (void)initialize;
- (void) createImageDownloader;
@end
