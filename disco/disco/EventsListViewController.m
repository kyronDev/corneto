//
//  EventsListViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 1/17/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "EventsListViewController.h"
#import "SWRevealViewController.h"

@interface EventsListViewController ()

@end

@implementation EventsListViewController{
    NSMutableArray *eventList;
    
}

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
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                        style:UIBarButtonItemStyleBordered
                                                                        target:revealController
                                                                        action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    /*
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                              style:UIBarButtonItemStyleBordered target:revealController action:@selector(rightRevealToggle:)];
    
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    */
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self fetchEventList];
}

- (void)fetchEventList{
    [self.view makeToastActivity];
    [[[GlobalParam sharedManager] networkManager] GET:@"list" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        eventList = responseObject;
        [self.tableView reloadData];
        NSLog(@"JSON: %lu", (unsigned long)[eventList count]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
        [self.view hideToastActivity];
        [self.view makeToast:@"No connection, please try again"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"count %d", [eventList count]);
    return [eventList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"eventTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    //NSLog(@"object row %@",eventList );
    NSMutableArray *event = [[eventList objectAtIndex:indexPath.row] valueForKey:@"fields"];
    
    UIImageView *eventLogo = (UIImageView *)[cell viewWithTag:101];
    [eventLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://www.experencia.me/media/",[event valueForKey:@"eventLogo"]]]
              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    UILabel *eventName = (UILabel *)[cell viewWithTag:102];
    eventName.text = [event valueForKey:@"eventName"];
    
    UILabel *eventHeadline = (UILabel *)[cell viewWithTag:103];
    eventHeadline.text = [event valueForKey:@"eventHeadline"];
    
    //cell.textLabel.text = [[eventList objectAtIndex:indexPath.row] objectForKey:@"pk"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    
    //show event detail view conytroller
    EventDetailViewController *eventDetailViewController = (EventDetailViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"eventDetailViewController"];
    
    eventDetailViewController.eventDetail = [eventList objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:eventDetailViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)LogoutButtonAction:(id)sender {
    //logout the user
    LoginViewController *logoutObject = [[LoginViewController alloc] init];
    [logoutObject logoutUser];
    
    //load the login View Controller
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    
    LoginViewController *loginViewController = (LoginViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    
    [self.window setRootViewController:loginViewController];
    
    [self.window makeKeyAndVisible];
    
}

- (IBAction)createEventButtonAction:(id)sender {
}
*/

- (IBAction)refreshButtonAction:(id)sender {
    
    [self fetchEventList];
    
}
- (IBAction)checkInButton:(id)sender {
    
    
    
}



@end
