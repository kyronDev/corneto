//
//  MyEventDetailViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 2/18/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "MyEventDetailViewController.h"

@interface MyEventDetailViewController ()

@end

@implementation MyEventDetailViewController{
    NSMutableArray *event;
}

@synthesize myEventDetail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Edit"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(EditButtonAction)];
    self.navigationItem.rightBarButtonItem = editButton;
    /*
    UIBarButtonItem *analyticsButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Analytics"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(analyticsButtonAction)];
    self.navigationItem.rightBarButtonItem = analyticsButton;
    */
    
    NSDictionary *param = @{@"eventId": [myEventDetail valueForKey:@"pk"]};
    
    [self.view makeToastActivity];
    [[[GlobalParam sharedManager] networkManager] GET:@"fetchEvent/" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.view hideToastActivity];
        
        event = responseObject[0];
        NSLog(@"json %@", event);
        
        self.eventName.text = [[event valueForKey:@"fields"] valueForKey:@"eventName"];
        
        self.eventHeadline.text = [[event valueForKey:@"fields"] valueForKey:@"eventHeadline"];
        
        self.eventHighlight.text = [[event valueForKey:@"fields"] valueForKey:@"eventHighlight"];
        
        self.eventCompany.text = [[event valueForKey:@"fields"] valueForKey:@"eventCompanyName"];
        
        self.eventDescription.text = [[event valueForKey:@"fields"] valueForKey:@"eventDescription"];
        
        self.eventAgenda.text = [[event valueForKey:@"fields"] valueForKey:@"eventAgenda"];
        
        self.eventCity.text = [[event valueForKey:@"fields"] valueForKey:@"eventCity"];
        
        self.eventAddress.text = [[event valueForKey:@"fields"] valueForKey:@"eventAddress"];
        
        self.phoneNumber.text = [[event valueForKey:@"fields"] valueForKey:@"contactNumber"];
        
        self.email.text = [[event valueForKey:@"fields"] valueForKey:@"contactEmail"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[event valueForKey:@"fields"] valueForKey:@"eventTime"] doubleValue]];
        // Divided by 1000 (i.e. removed three trailing zeros) ^^^^^^^^
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        // Fri, 28 Jun 2013 11:26:29 GMT
        NSLog(@"formattedDateString: %@", formattedDateString);
        
        self.eventDate.text = formattedDateString;
        
        self.expectedFootfall.text = [[event valueForKey:@"fields"] valueForKey:@"expectedFootfall"];
        
        self.eventTags.text = [[event valueForKey:@"fields"] valueForKey:@"eventTags"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
    }];
    
    NSLog(@"my Event Detail %@", myEventDetail);
    
    
}

- (void)EditButtonAction{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    
    //show event detail view conytroller
    EditEventViewController *editEventViewController = (EditEventViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"editEventViewController"];
    
    editEventViewController.myEvent = myEventDetail;
    
    [self presentViewController:editEventViewController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
