//
//  LoginViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 1/7/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "EventsListViewController.h"
#import <IOSLinkedInAPI/LIALinkedInApplication.h>
#import <IOSLinkedInAPI/LIALinkedInHttpClient.h>
#import <IOSLinkedInAPI/LIALinkedInAuthorizationViewController.h>


@interface LoginViewController : UIViewController <FBLoginViewDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


- (IBAction)loginButtonAction:(id)sender;

- (void) logoutUser;

- (void)checkTokenExpiry;

- (void)linkedAccessToken;

@end
