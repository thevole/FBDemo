//
//  BBAppDelegate.h
//  FBDemo
//
//  Created by Martin Volerich on 7/30/12.
//  Copyright (c) 2012 Bill Bear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
//#import "Facebook.h"

@interface BBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *session;

- (void)openSessionCheckCache:(BOOL)check;
- (void)closeSession;
- (void)publishStatus:(NSString *)message;
@end
