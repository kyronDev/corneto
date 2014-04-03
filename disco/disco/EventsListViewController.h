//
//  EventsListViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 1/17/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "GlobalParam.h"
#import "EventDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <Toast/Toast+UIView.h>

@interface EventsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
- (IBAction)refreshButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
- (IBAction)checkInButton:(id)sender;


@end
