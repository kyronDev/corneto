//
//  AttDetailViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 2/18/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "AttDetailViewController.h"

@interface AttDetailViewController ()

@end

@implementation AttDetailViewController

@synthesize attEventDetail;

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
    
    NSLog(@"att Event Detail %@", attEventDetail);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
