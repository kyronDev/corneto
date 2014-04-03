//
//  AttendeeListViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 3/6/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "AttendeeListViewController.h"

@interface AttendeeListViewController ()

@end

@implementation AttendeeListViewController{
    NSMutableArray *attendeeList;
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
    NSLog(@"event ID : %@", self.eventId);
    
    NSDictionary *attendParam = @{@"eventId": self.eventId};
    
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
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return attendeeList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSString *picUrl = [[[attendeeList objectAtIndex:indexPath.row] objectForKey:@"fields"] objectForKey:@"picurl"];
    
    UIImageView *attendeeImage = (UIImageView *)[cell viewWithTag:101];
    //attendeeImage.image = [UIImage imageNamed:[attendeeList objectAtIndex:indexPath.row]];
    [attendeeImage setImageWithURL:[NSURL URLWithString:picUrl]
                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //UILabel *firstName = (UILabel *)[cell viewWithTag:102];
    //firstName.text = [[[attendeeList objectAtIndex:indexPath.row] objectForKey:@"fields"] objectForKey:@"firstName"];
    //UILabel *lastName = (UILabel *)[cell viewWithTag:103];
    //lastName.text = [[[attendeeList objectAtIndex:indexPath.row] objectForKey:@"fields"] objectForKey:@"lastName"];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
