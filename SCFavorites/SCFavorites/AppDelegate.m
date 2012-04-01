//
//  AppDelegate.m
//  SCFavorites
//
//  Created by Prakash Donga on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SCUI.h"
#import "FavoritesVC.h"
#import "YouVC.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabViewController = _tabViewController;
@synthesize objMan;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Intialize the SoundCloud access Token and URI
    [AppDelegate initialize];
    
    //Create/initiallize image downloader class
    [self createImageDownloader];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabViewController = [[UITabBarController alloc] init];
    
    // Override point for customization after application launch.
    FavoritesVC *favoritesVC = [[FavoritesVC alloc] initWithNibName:@"FavoritesVC" 
                                                             bundle:[NSBundle mainBundle]];
    favoritesVC.title = @"Favourites";
    UINavigationController *favoritesNavVC = [[UINavigationController alloc] initWithRootViewController:favoritesVC];
    [favoritesNavVC.navigationBar setBarStyle:UIBarStyleBlack];
    [favoritesNavVC.navigationBar setTranslucent:NO];    
    
    YouVC *youVC = [[YouVC alloc] initWithNibName:@"YouVC" bundle:[NSBundle mainBundle]];
    youVC.title = @"You";
    UINavigationController *youNavVC = [[UINavigationController alloc] initWithRootViewController:youVC];
    [youNavVC.navigationBar setBarStyle:UIBarStyleBlack];
    [youNavVC.navigationBar setTranslucent:NO];
        
    [self.tabViewController setViewControllers:[NSArray arrayWithObjects:favoritesNavVC, youNavVC, nil]];
    
    NSArray *tabItems = [self.tabViewController.tabBar items];
    
    UITabBarItem *firstItem = [tabItems objectAtIndex:0];
    firstItem.image = [UIImage imageNamed:@"star.png"];
    
    UITabBarItem *secondItem = [tabItems objectAtIndex:1];
    secondItem.image = [UIImage imageNamed:@"persondot.png"];
    
    self.window.rootViewController = self.tabViewController;
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)initialize
{
    [SCSoundCloud  setClientID:@"0c481b4c01e0e8b17e386212111f810a"
                        secret:@"b9ba71110523497b82047af6e88d545f"
                   redirectURL:[NSURL URLWithString:@"scfavorites://oauth2"]];
}

- (void) createImageDownloader
{
    // Create the object manager
	self.objMan = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20];
    
	// Create a file cache for the object manager to use
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/"] ;
    
	HJMOFileCache* fileCache = [[HJMOFileCache alloc] initWithRootPath:cacheDirectory];
	self.objMan.fileCache = fileCache;
	
    // Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 24*60*60; // 1 day
	[fileCache trimCacheUsingBackgroundThread];
    
    NSLog(@"self.obj %@",self.objMan);
}

@end
