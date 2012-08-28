//
//  BBAppDelegate.m
//  FBDemo
//
//  Created by Martin Volerich on 7/30/12.
//  Copyright (c) 2012 Bill Bear. All rights reserved.
//

#import "BBAppDelegate.h"
#import "BBViewController.h"


@implementation BBAppDelegate

@synthesize session = _session;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
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
    // this means the user switched back to this app without completing
    // a login in Safari/Facebook App
    if (self.session.state == FBSessionStateCreatedOpening) {
        [self.session close]; // so we close the session and start over
    }
}

#pragma mark Facebook helper methods

- (FBSession *)createNewSession
{
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream", @"publish_actions", @"email", nil];
    self.session = [[FBSession alloc] initWithPermissions:permissions];
    return self.session;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
{
    BBViewController *viewController = (BBViewController *)[self.window rootViewController];
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // we have a valid session
                NSLog(@"User session found.");
                [viewController.loginButton setTitle:@"Logout from Facebook" forState: UIControlStateNormal];
                viewController.publishButton.enabled = YES;
                viewController.likeButton.enabled = YES;

            }
            break;
            
        case FBSessionStateClosed:
           
        case FBSessionStateClosedLoginFailed:
            [session closeAndClearTokenInformation];
            self.session = nil;
            [self createNewSession];
            [viewController.loginButton setTitle:@"Login to Facebook" forState: UIControlStateNormal];
            viewController.publishButton.enabled = NO;
            viewController.likeButton.enabled = NO;
            break;
            
        default:
            break;
    }
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)openSessionCheckCache:(BOOL)check
{
    // Create a new session object
    if (![self.session isOpen]) {
        [self createNewSession];
    }
    
    // Open the session in two scenarios:
    // - When we are not loading from the cache, e.g. when a login
    //   button is clicked
    // - When we are checking cache and have an available token,
    //   e.g. when we need to show a logged vs. logged out display.
    if (!check ||
        (self.session.state == FBSessionStateCreatedTokenLoaded)) {
        [self.session openWithBehavior:FBSessionLoginBehaviorForcingWebView
                     completionHandler:
         ^(FBSession *session, FBSessionState status, NSError *error) {
            [self sessionStateChanged:session state:status error:error];
        }];
        
    }
}

- (void)publishStatus:(NSString *)message
{
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
//    NSDictionary *parms = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
//    FBRequest *request = [[FBRequest alloc] initWithSession:self.session graphPath:@"me/feed" parameters:parms HTTPMethod:@"POST"];
    FBRequest *request = [FBRequest requestForPostStatusUpdate:message];
    [request setSession:self.session];
    [connection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"Error Received: %@", error.localizedDescription);
        } else {
            NSLog(@"posted");
        }
    } ];
    [connection start];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [self.session handleOpenURL:url];
}

- (void)closeSession
{
    [self.session closeAndClearTokenInformation];
    NSLog(@"User session closed and cleared");
}

@end
