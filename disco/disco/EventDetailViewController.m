//
//  EventDetailViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 1/31/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController{
    
    NSString *RSVP;
    NSMutableArray *attendeeList;
}

@synthesize eventDetail, choosenTagsNew;

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
    
    //choosenTagsNew = [[NSString alloc] init];
    
    NSLog(@"event Detail %@", eventDetail );
    
    //self.attendeeView.hidden = YES;
    
    //TODO : Check if the user has already RSVPed the event. Show the event response.
    
    self.eventName.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventName"];
    
    self.eventHeadline.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventHeadline"];
    
    self.eventHighlight.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventHighlight"];
    
    self.eventCompanyName.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventCompanyName"];
    
    self.eventDescription.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventDescription"];
    
    self.eventAgenda.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventAgenda"];
    
    self.eventCity.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventCity"];
    
    self.eventAddress.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventAddress"];
    
    //self.phoneNumber.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"contactNumber"];
    
    //self.email.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"contactEmail"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[[eventDetail valueForKey:@"fields"] valueForKey:@"eventTime"] doubleValue]];
    // Divided by 1000 (i.e. removed three trailing zeros) ^^^^^^^^
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    // Fri, 28 Jun 2013 11:26:29 GMT
    NSLog(@"formattedDateString: %@", formattedDateString);
    
    self.eventDate.text = formattedDateString;
    
    self.eventExpectedFootfall.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"expectedFootfall"];
    
    self.eventTags.text = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventTags"];
    
    //check for current RSVP
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
    NSString *eventId = [eventDetail valueForKey:@"pk"];
    NSDictionary *param = @{@"email": email,
                            @"eventId": eventId};
    [self.view makeToastActivity];
    NSLog(@"rsvp check : %@",param);
    [[[GlobalParam sharedManager] networkManager] GET:@"checkRSVP" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.view hideToastActivity];
        
        NSLog(@"current RSVP %@", responseObject[@"rsvp"]);
        
        if([responseObject[@"rsvp"] isEqualToString:@"YES"]){
            
            self.yesButton.backgroundColor = [UIColor lightGrayColor];
            
        }else if ([responseObject[@"rsvp"] isEqualToString:@"NO"]){
            
            self.noButton.backgroundColor = [UIColor lightGrayColor];
            
        }else if ([responseObject[@"rsvp"] isEqualToString:@"MAYBE"]){
            
            self.maybeButton.backgroundColor = [UIColor lightGrayColor];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
        [self.view hideToastActivity];
        [self.view makeToast:@"No connection, please try again"];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)yesButtonAction:(id)sender {
    NSLog(@"eventID %@", [eventDetail valueForKey:@"pk"]);
    
    choosenTagsNew = [[NSUserDefaults standardUserDefaults] objectForKey:@"choosenTags"];
    
    NSLog(@" *** %@", choosenTagsNew);
    
    if ([choosenTagsNew length] == 0) {
        choosenTagsNew = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventTags"];
    }
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
    NSString *eventId = [eventDetail valueForKey:@"pk"];
    RSVP = @"YES";
    NSString *picUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"picUrl"];
    NSString *pubUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"pubUrl"];
    NSString *firstName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"firstName"];
    NSString *lastName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"lastName"];
    
    NSDictionary *attendParam = @{@"email": email,
                                  @"eventId": eventId,
                                  @"rsvp": RSVP,
                                  @"choosenTags": choosenTagsNew,
                                  @"picUrl": picUrl,
                                  @"pubUrl": pubUrl,
                                  @"firstName": firstName,
                                  @"lastName": lastName};
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"choosenTags"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"attend %@", attendParam);
    
    NSDictionary *param = @{@"email": email};
    
    [self.view makeToastActivity];
    
    [[[GlobalParam sharedManager] networkManager] GET:@"checkProfile/" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.view hideToastActivity];
        
        NSLog(@"response %@", responseObject[@"response"]);
        
        if ([responseObject[@"response"] isEqualToString:@"true"]) {
            
            //show toast spinner
            [self.view makeToastActivity];
            
            [[[GlobalParam sharedManager] networkManager] POST:@"attendEvent/" parameters:attendParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSLog(@"attend response %@", responseObject);
                
                //hide toast spinner
                [self.view hideToastActivity];
                
                self.yesButton.backgroundColor = [UIColor lightGrayColor];
                self.maybeButton.backgroundColor = [UIColor whiteColor];
                self.noButton.backgroundColor = [UIColor whiteColor];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error attend: %@", operation);
                
                //hide toast spinner and show error message
                [self.view hideToastActivity];
                [self.view makeToast:@"No connection, please try again"];
            }];
            
            
        }else if([responseObject[@"response"] isEqualToString:@"false"]){
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
            EditProfileViewController *editProfileViewController = (EditProfileViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"editProfileViewController"];
            [self presentViewController:editProfileViewController animated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
        //hide spinner
        [self.view makeToast:@"No connection, please try again"];
    }];
    
}

- (void) assignTag:(NSString*)newTags {
    choosenTagsNew = [newTags copy];
    NSLog(@"!!!!!! %@", choosenTagsNew);
}

- (IBAction)noButtonAction:(id)sender {
    NSLog(@"eventID %@", [eventDetail valueForKey:@"pk"]);
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
    NSString *eventId = [eventDetail valueForKey:@"pk"];
    RSVP = @"NO";
    NSString *picUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"picUrl"];
    NSString *pubUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"pubUrl"];
    NSString *firstName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"firstName"];
    NSString *lastName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"lastName"];
    
    NSDictionary *attendParam = @{@"email": email,
                                  @"eventId": eventId,
                                  @"rsvp": RSVP,
                                  @"picUrl": picUrl,
                                  @"pubUrl": pubUrl,
                                  @"firstName": firstName,
                                  @"lastName": lastName};
    
    [self.view makeToastActivity];
    
    [[[GlobalParam sharedManager] networkManager] POST:@"attendEvent/" parameters:attendParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.view hideToastActivity];
        
        self.yesButton.backgroundColor = [UIColor whiteColor];
        self.noButton.backgroundColor = [UIColor lightGrayColor];
        self.maybeButton.backgroundColor = [UIColor whiteColor];
        
        NSLog(@"attend response %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
        [self.view hideToastActivity];
        [self.view makeToast:@"No connection, please try again"];
    }];
    
}


- (IBAction)maybeButtonAction:(id)sender {
    NSLog(@"eventID %@", [eventDetail valueForKey:@"pk"]);
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
    NSString *eventId = [eventDetail valueForKey:@"pk"];
    NSString *picUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"picUrl"];
    NSString *pubUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"pubUrl"];
    NSString *firstName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"firstName"];
    NSString *lastName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"lastName"];
    RSVP = @"MAYBE";
    NSLog(@"param %@ ** %@ ** %@ ** %@ ** %@ ** %@",email,eventId,RSVP,picUrl,firstName,lastName);
    NSDictionary *attendParam = @{@"email": email,
                                  @"eventId": eventId,
                                  @"rsvp": RSVP,
                                  @"picUrl": picUrl,
                                  @"pubUrl": pubUrl,
                                  @"firstName": firstName,
                                  @"lastName": lastName};
    
    NSLog(@"attend %@", attendParam);
    
    [self.view makeToastActivity];
    
    [[[GlobalParam sharedManager] networkManager] POST:@"attendEvent/" parameters:attendParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.view hideToastActivity];
        
        self.yesButton.backgroundColor = [UIColor whiteColor];
        self.maybeButton.backgroundColor = [UIColor lightGrayColor];
        self.noButton.backgroundColor = [UIColor whiteColor];
        
        NSLog(@"attend response %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
        [self.view hideToastActivity];
        [self.view makeToast:@"No connection, please try again"];
    }];
    
}


- (IBAction)attendeeListAction:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    
    NSLog(@"pointer 1");
    
    //show event detail view conytroller
    AttendeeListViewController *attendeeListViewController = (AttendeeListViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"attendeeListViewController"];
    
    attendeeListViewController.eventId = [eventDetail valueForKey:@"pk"];
    
    [self.navigationController pushViewController:attendeeListViewController animated:YES];
    
    
    //self.attendeeView.hidden = NO;
    /*
    NSDictionary *attendParam = @{@"eventId": [eventDetail valueForKey:@"pk"]};
    
    [self.view makeToastActivity];
    [[[GlobalParam sharedManager] networkManager] GET:@"attendeeList/" parameters:attendParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        
        NSLog(@" attendeeList %@ ", responseObject);
        attendeeList = responseObject;
        
        [self.attendeeCollection reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
        [self.view hideToastActivity];
        [self.view makeToast:@"No connection, please try again"];
    }];
    */
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"attendee count %lu", attendeeList.count);
    return attendeeList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *picUrl = [[[attendeeList objectAtIndex:indexPath.row] objectForKey:@"fields"]  objectForKey:@"picUrl"];
    
    UIImageView *attendeeImage = (UIImageView *)[cell viewWithTag:101];
    //attendeeImage.image = [UIImage imageNamed:[attendeeList objectAtIndex:indexPath.row]];
    [attendeeImage setImageWithURL:[NSURL URLWithString:picUrl]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

- (IBAction)chooseTagsAction:(id)sender {
    
    //if the user does not chooses any tags then send the tags from the default user profile
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    
    //show event detail view controller
    ChooseTagsViewController *chooseTagsViewController = (ChooseTagsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"chooseTagsViewController"];
    
    if ([[[eventDetail valueForKey:@"fields"] valueForKey:@"eventTags"] length] != 0) {
        
        chooseTagsViewController.eventDetail = eventDetail;
        
        [self.navigationController pushViewController:chooseTagsViewController animated:YES];
        
    }else{
        [self.view makeToast:@"No Tags associated with this event"];
    }

    
}


- (IBAction)mapButtonAction:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    
    //show event detail view controller
    MapsViewController *mapsViewController = (MapsViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"mapsViewController"];
    mapsViewController.address = [[eventDetail valueForKey:@"fields"] valueForKey:@"eventAddress"];
    
    [self.navigationController pushViewController:mapsViewController animated:YES];
    
}
@end
