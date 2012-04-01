//
//  ViewController.h
//  SCFavorites
//
//  Created by Prakash Donga on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAPI.h"
#import "SCUI.h"
#import "UIViewController+SoundCloudUI.h"

typedef void(^LoginViewControllerComletionHandler)(BOOL isSuccess);

@interface LoginVC : UIViewController
{
    LoginViewControllerComletionHandler completionHandler;
}

@property (nonatomic, strong) LoginViewControllerComletionHandler completionHandler;

+ (LoginVC *) loginViewControllerWithHandler:(LoginViewControllerComletionHandler) handler;
- (void) dismiss;
@end
