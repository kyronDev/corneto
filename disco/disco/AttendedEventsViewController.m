//
//  AttendedEventsViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 1/31/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "AttendedEventsViewController.h"

@interface AttendedEventsViewController ()

@end

@implementation AttendedEventsViewController{
    NSMutableArray *attendedEventList;
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
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
    NSLog(@"email %@", email);
    NSDictionary *param = @{@"email": email};
    
    [[[GlobalParam sharedManager] networkManager] GET:@"myAttendedEvents/" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        attendedEventList = responseObject;
        [self.tableView reloadData];
        //NSLog(@"JSON: %lu", (unsigned long)[eventList count]);
        NSLog(@"json %@", attendedEventList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"count %d", [eventList count]);
    return [attendedEventList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"eventTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    
    NSLog(@"object row %@", [[attendedEventList objectAtIndex:indexPath.row] objectForKey:@"pk"]);
    cell.textLabel.text = [[attendedEventList objectAtIndex:indexPath.row] objectForKey:@"pk"];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    
    //show event detail view conytroller
    AttDetailViewController *attDetailViewController = (AttDetailViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"attDetailViewController"];
    
    attDetailViewController.attEventDetail = [attendedEventList objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:attDetailViewController animated:YES];
    
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
