//
//  AppDelegate.h
//  disco
//
//  Created by Abhigyan Raghav on 12/20/13.
//  Copyright (c) 2013 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "GlobalParam.h"
#import "LoginViewController.h"
#import "EventsListViewController.h"
#import "SWRevealViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>



@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *loginViewController;

//@property (strong, nonatomic) SWRevealViewController *revealViewController;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;
- (void)continueLogin:(NSDictionary *)userData;
@end
