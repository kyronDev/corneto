//
//  MenuViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 1/29/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    
    NSString *picUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"picUrl"];
    
    NSLog(@"url -- %@ ", picUrl);
    
    [self.profilePic setImageWithURL:[NSURL URLWithString:picUrl]
              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    self.firstName.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"firstName"];
    self.lastName.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"lastName"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutAction:(id)sender {
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
@end
