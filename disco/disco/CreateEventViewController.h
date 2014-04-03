//
//  CreateEventViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 1/19/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "GlobalParam.h"
#import <Toast/Toast+UIView.h>

@interface CreateEventViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

/*
 actualAttendeeCount = "";
 eventAddress = "";
 eventAgenda = wefewfgew;
 eventCity = "";
 eventCompanyName = "";
 eventCoordinates = "";
 eventDescription = dafw;
 eventHeadline = wefwe;
 eventHighlight = SDFWE;
 eventImages = "";
 eventName = SDFDS;
 eventOrganizer = "";
 eventTags = efewq;
 eventTime = "1390737334.000000";
 expectedFootfall = DSFW;
 registeredAttendeeCount = "";
 */

@property (weak, nonatomic) IBOutlet UITextField *eventName;

@property (weak, nonatomic) IBOutlet UITextView *eventHeadline;

@property (weak, nonatomic) IBOutlet UITextView *eventHighlight;

@property (weak, nonatomic) IBOutlet UITextView *eventDescription;

@property (weak, nonatomic) IBOutlet UITextView *eventCompanyName;

@property (weak, nonatomic) IBOutlet UITextField *expectedFootfall;

@property (weak, nonatomic) IBOutlet UITextView *eventTags;

@property (weak, nonatomic) IBOutlet UIDatePicker *eventTimeDate;

@property (weak, nonatomic) IBOutlet UITextView *eventAgenda;

@property (weak, nonatomic) IBOutlet UITextField *eventCity;

@property (weak, nonatomic) IBOutlet UITextView *eventAddress;

@property (weak, nonatomic) IBOutlet UIImageView *eventLogo;

- (IBAction)uploadLogoButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *uploadBUtton;

@property (weak, nonatomic) IBOutlet UIButton *createButton;
- (IBAction)createButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *email;



@end
