//
//  ChooseTagsViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 3/11/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailViewController.h"
#import "GlobalParam.h"

@interface ChooseTagsViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *eventDetail;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (IBAction)confirmButtonAction:(id)sender;



@end
