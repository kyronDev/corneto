//
//  AttendeeListViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 3/6/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailViewController.h"
#import "GlobalParam.h"
#import "UIImageView+WebCache.h"

@interface AttendeeListViewController : UIViewController

@property (nonatomic, retain) NSString *eventId;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *attendeeCollection;


@end
