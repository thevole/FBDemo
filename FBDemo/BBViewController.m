//
//  BBViewController.m
//  FBDemo
//
//  Created by Martin Volerich on 7/30/12.
//  Copyright (c) 2012 Bill Bear. All rights reserved.
//

#import "BBViewController.h"
#import "BBAppDelegate.h"
//#import <FacebookSDK/FBRequest.h>

@interface BBViewController () <FBDialogDelegate>
@property (strong, nonatomic) Facebook *facebook;
@end

@implementation BBViewController
@synthesize loginButton = _loginButton;
@synthesize publishButton = _publishButton;
@synthesize likeButton = _likeButton;
@synthesize facebook = _facebook;


- (void)viewDidLoad
{
    [super viewDidLoad];

    BBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionCheckCache:YES];
}

- (void)viewDidUnload
{
    [self setLoginButton:nil];
    [self setPublishButton:nil];
    [self setLikeButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)loginToFacebook:(id)sender
{
    BBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.session isOpen]) {
        [appDelegate closeSession];
     
    } else {
        [appDelegate openSessionCheckCache:NO];
    }
    
}
- (IBAction)forcedLoginToFacebook:(id)sender
{
    BBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //    [appDelegate closeSession];
    if (appDelegate.session.isOpen) {
        NSLog(@"Closing existing");
        [appDelegate closeSession];
    }
    NSLog(@"Forced opening");
    [appDelegate openSessionCheckCache:NO];
}

- (IBAction)publishStuff:(id)sender
{
    BBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (nil == self.facebook) {
        self.facebook = [[Facebook alloc] initWithAppId:appDelegate.session.appID andDelegate:nil];
        self.facebook.accessToken = FBSession.activeSession.accessToken;
        self.facebook.expirationDate = FBSession.activeSession.expirationDate;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Facebook SDK for iOS", @"name",
                                   @"Build great social apps and get more installs.", @"caption",
                                   @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
                                   @"https://developers.facebook.com/ios", @"link",
                                   @"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png", @"picture",
                                   nil];
    
    // Invoke the dialog
    [self.facebook dialog:@"feed" andParams:params andDelegate:self];
    
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- (void)dialogCompleteWithUrl:(NSURL *)url
{
    NSDictionary *results = [self parseURLParams:[url query]];
    NSString *msg = [NSString stringWithFormat:@"Posted story, id: %@", [results valueForKey:@"post_id"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Results" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    self.facebook = nil;
}

- (IBAction)likeApp:(id)sender {
}



@end
