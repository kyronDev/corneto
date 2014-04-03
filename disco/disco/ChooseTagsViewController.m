//
//  ChooseTagsViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 3/11/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "ChooseTagsViewController.h"

@interface ChooseTagsViewController ()

@end

@implementation ChooseTagsViewController{
    NSMutableArray *choosenTags;
    NSArray *eventTags;
}

@synthesize eventDetail;

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
    
    choosenTags = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *ConfirmButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Confirm"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(ConfirmButtonAction)];
    self.navigationItem.rightBarButtonItem = ConfirmButton;
    
    eventTags = [[[eventDetail valueForKey:@"fields"] valueForKey:@"eventTags"] componentsSeparatedByString:@", "];
    NSLog(@" event Tags %@", eventTags);
    [self.tableView reloadData];
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
    NSString *eventId = [eventDetail valueForKey:@"pk"];
    
    NSDictionary *attendParam = @{@"email": email,
                                  @"eventId": eventId};
    
    
    [self.view makeToastActivity];
    [[[GlobalParam sharedManager] networkManager] GET:@"userChoosenTags/" parameters:attendParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view hideToastActivity];
        
        NSLog(@" userTags %@ ", responseObject);
        NSString *userTags = [responseObject valueForKey:@"userTags"];
        
        if (userTags != (id)[NSNull null] && userTags.length != 0) {
            [choosenTags addObjectsFromArray:[userTags componentsSeparatedByString:@", "]];
            NSLog(@"####");
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
        [self.view hideToastActivity];
        [self.view makeToast:@"No connection, please try again"];
    }];
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventTags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
    }
    
    cell.textLabel.text = [eventTags objectAtIndex:indexPath.row];
    NSLog(@"*** %@", [eventTags objectAtIndex:indexPath.row]);
    
    if ([[choosenTags componentsJoinedByString:@" "] rangeOfString:[eventTags objectAtIndex:indexPath.row]].location == NSNotFound) {
    }else{
        NSLog(@"true");
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:
         UITableViewScrollPositionNone];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"selected row %@ ", [eventTags objectAtIndex:indexPath.row]);
    [choosenTags addObject:[eventTags objectAtIndex:indexPath.row]];
    NSLog(@" choosenTags %@ ", choosenTags);
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"Unselected row %@ ", [eventTags objectAtIndex:indexPath.row]);
    [choosenTags removeObject:[eventTags objectAtIndex:indexPath.row]];
    NSLog(@" choosenTags %@ ", choosenTags);
}


- (void)ConfirmButtonAction{
    
    if ([choosenTags count] == 0) {
        [self.view makeToast:@" PLease choose atleast one tag"];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setValue:[choosenTags componentsJoinedByString:@", "] forKey:@"choosenTags"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
        NSString *eventId = [eventDetail valueForKey:@"pk"];
        
        NSDictionary *attendParam = @{@"email": email,
                                      @"eventId": eventId,
                                      @"userTags": [choosenTags componentsJoinedByString:@", "]};
        
        
        
        [self.view makeToastActivity];
        [[[GlobalParam sharedManager] networkManager] POST:@"confirmTags/" parameters:attendParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.view hideToastActivity];
            [self.view makeToast:@"Your tags have been updated"];
            NSLog(@" userTags response %@ ", responseObject);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", operation);
            [self.view hideToastActivity];
            [self.view makeToast:@"No connection, please try again"];
        }];
        
        
    }
 
    

    //EventDetailViewController *eventDetailViewController = [[EventDetailViewController alloc] init ];
    //eventDetailViewController.choosenTags = ;
    
    //[self.navigationController popViewControllerAnimated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
