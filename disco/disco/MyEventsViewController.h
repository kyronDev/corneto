//
//  MyEventsViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 1/30/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalParam.h"
#import "MyEventDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <Toast/Toast+UIView.h>

@interface MyEventsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
