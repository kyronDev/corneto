//
//  EditEventViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 4/1/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "GlobalParam.h"
#import <Toast/Toast+UIView.h>
#import "UIImageView+WebCache.h"


@interface EditEventViewController : UIViewController

@property (nonatomic,retain) NSMutableArray *myEvent;

@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITextView *eventHeadline;
@property (weak, nonatomic) IBOutlet UITextView *eventHighlight;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (weak, nonatomic) IBOutlet UITextView *eventAddress;
@property (weak, nonatomic) IBOutlet UITextField *eventCity;
@property (weak, nonatomic) IBOutlet UITextView *companyName;
@property (weak, nonatomic) IBOutlet UIImageView *eventLogo;
@property (weak, nonatomic) IBOutlet UIButton *uploadLogo;
- (IBAction)uploadLogoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *expectedFootfall;
@property (weak, nonatomic) IBOutlet UITextView *eventTags;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextView *eventAgenda;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *contactEmail;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonAction:(id)sender;


@end
