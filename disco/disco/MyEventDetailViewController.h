//
//  MyEventDetailViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 2/18/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapsViewController.h"
#import "EditEventViewController.h"

@interface MyEventDetailViewController : UIViewController

@property (nonatomic,retain) NSMutableArray *myEventDetail;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventHeadline;
@property (weak, nonatomic) IBOutlet UILabel *eventHighlight;
@property (weak, nonatomic) IBOutlet UILabel *eventCompany;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet UILabel *eventAgenda;
@property (weak, nonatomic) IBOutlet UILabel *eventCity;
@property (weak, nonatomic) IBOutlet UILabel *eventAddress;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *expectedFootfall;
@property (weak, nonatomic) IBOutlet UILabel *eventTags;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *email;



@end
