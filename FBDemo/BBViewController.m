//
//  BBViewController.m
//  FBDemo
//
//  Created by Martin Volerich on 7/30/12.
//  Copyright (c) 2012 Bill Bear. All rights reserved.
//

#import "BBViewController.h"
#import "BBAppDelegate.h"
#import <FacebookSDK/FBRequest.h>

@interface BBViewController ()
@end

@implementation BBViewController
@synthesize loginButton = _loginButton;
@synthesize publishButton = _publishButton;
@synthesize likeButton = _likeButton;


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

- (IBAction)publishStuff:(id)sender
{
    BBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = kCFDateFormatterMediumStyle;
    formatter.dateStyle = kCFDateFormatterShortStyle;
    NSString *message = [NSString stringWithFormat:@"Hello World! at %@", [formatter stringFromDate:now]];
    [appDelegate publishStatus:message];
    NSLog(@"Message: %@", message);
}

- (IBAction)likeApp:(id)sender {
}



@end
