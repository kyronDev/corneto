//
//  EventDetailViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 1/31/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalParam.h"
#import "EditProfileViewController.h"
#import "AttendeeListViewController.h"
#import <Toast/Toast+UIView.h>
#import "ChooseTagsViewController.h"
#import "UIImageView+WebCache.h"
#import "MapsViewController.h"

@interface EventDetailViewController : UIViewController

@property (nonatomic, retain) NSMutableArray *eventDetail;
@property (atomic, retain) NSString *choosenTagsNew;
- (void) assignTag:(NSString*)newTags; 

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventHeadline;
@property (weak, nonatomic) IBOutlet UILabel *eventHighlight;
@property (weak, nonatomic) IBOutlet UILabel *eventCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet UILabel *eventAgenda;
@property (weak, nonatomic) IBOutlet UILabel *eventCity;
@property (weak, nonatomic) IBOutlet UILabel *eventAddress;
@property (weak, nonatomic) IBOutlet UILabel *eventDate;
@property (weak, nonatomic) IBOutlet UILabel *eventExpectedFootfall;
@property (weak, nonatomic) IBOutlet UILabel *eventTags;

@property (weak, nonatomic) IBOutlet UIButton *attendeeListButton;
- (IBAction)attendeeListAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *yesButton;
- (IBAction)yesButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *maybeButton;
- (IBAction)maybeButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
- (IBAction)noButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *chooseTags;
- (IBAction)chooseTagsAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
- (IBAction)mapButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *email;


@end
