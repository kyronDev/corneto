//
//  AttendedEventsViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 1/31/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalParam.h"
#import "AttDetailViewController.h"

@interface AttendedEventsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
