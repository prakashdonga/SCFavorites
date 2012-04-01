//
//  ViewController.m
//  SCFavorites
//
//  Created by Prakash Donga on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginVC.h"
#import "SCUI.h"

@implementation LoginVC
@synthesize completionHandler;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bumpPattern.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


+ (LoginVC *) loginViewControllerWithHandler:(LoginViewControllerComletionHandler) handler
{
    LoginVC *loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:[NSBundle mainBundle]];
    loginVC.completionHandler = handler;
    return loginVC;
}


- (IBAction) login:(id)sender 
{
    if ([SCSoundCloud account] == nil) 
    {
        [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
            
            SCLoginViewController *loginViewController;
            loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                          completionHandler:^(NSError *error){
                                                                              
                                                                              if (SC_CANCELED(error)) {
                                                                                  NSLog(@"Canceled!");
                                                                                  if (self.completionHandler) {
                                                                                      self.completionHandler(NO);                                                                                      
                                                                                  }
                                                                              } 
                                                                              else if (error) 
                                                                              {
                                                                                  NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                                                                  if (self.completionHandler) {
                                                                                      self.completionHandler(NO);                                                                                      
                                                                                  }
                                                                              } 
                                                                              else {
                                                                                  NSLog(@"Done!");
                                                                                  //Success means tell the login caller that it is log in
                                                                                  if (self.completionHandler) {
                                                                                      self.completionHandler(YES);                                                                                      
                                                                                  }
                                                                                  [self dismiss];
                                                                              }
                                                                          }];
            
            [self presentModalViewController:loginViewController
                                    animated:YES];
            
        }];   
    }
}

- (void) dismiss 
{
    [self.modalPresentingViewController dismissModalViewControllerAnimated:NO];
}

@end
