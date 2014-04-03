//
//  MyEventsViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 1/30/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "MyEventsViewController.h"

@interface MyEventsViewController ()

@end

@implementation MyEventsViewController{
    NSMutableArray *myEventList;
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
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(cancelAction)];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    self.title = @"My created events";
    
    
}

- (void) viewDidAppear:(BOOL)animated{
    [self fetchMyEventList];
}

- (void) cancelAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)fetchMyEventList{
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
    NSLog(@"email %@", email);
    NSDictionary *param = @{@"email": email};
    
    [self.view makeToastActivity];
    [[[GlobalParam sharedManager] networkManager] GET:@"listMyEvents/" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        myEventList = responseObject;
        [self.tableView reloadData];
        //NSLog(@"JSON: %lu", (unsigned long)[eventList count]);
        NSLog(@"json %@", myEventList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"count %d", [eventList count]);
    return [myEventList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"eventTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    NSMutableArray *event = [[myEventList objectAtIndex:indexPath.row] valueForKey:@"fields"];
    
    UIImageView *eventLogo = (UIImageView *)[cell viewWithTag:101];
    [eventLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://www.experencia.me/media/",[event valueForKey:@"eventLogo"]]]
              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    UILabel *eventName = (UILabel *)[cell viewWithTag:102];
    eventName.text = [event valueForKey:@"eventName"];
    
    UILabel *eventHeadline = (UILabel *)[cell viewWithTag:103];
    eventHeadline.text = [event valueForKey:@"eventHeadline"];
    
    //NSLog(@"object row %@", [[myEventList objectAtIndex:indexPath.row] objectForKey:@"pk"]);
    //cell.textLabel.text = [[myEventList objectAtIndex:indexPath.row] objectForKey:@"pk"];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"my event selected");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    
    //show event detail view conytroller
    MyEventDetailViewController *myEventDetailViewController = (MyEventDetailViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"myEventDetailViewController"];
    
    myEventDetailViewController.myEventDetail = [myEventList objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:myEventDetailViewController animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
