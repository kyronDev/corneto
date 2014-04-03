//
//  MenuViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 1/29/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface MenuViewController : UIViewController

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)logoutAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *editButtonAction;

@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;



@end
