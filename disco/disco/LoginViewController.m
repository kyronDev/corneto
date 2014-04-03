//
//  LoginViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 1/7/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"



@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkedInLogin;
- (IBAction)loginLinkedInAction:(id)sender;


@end

@implementation LoginViewController {
    LIALinkedInHttpClient *_client;
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
    _client = [self client];
    
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.readPermissions = @[@"basic_info", @"email"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonAction:(id)sender {
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically

        [self logoutUser];
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];

         }];
    }
    
}

- (void) logoutUser
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //clear the session and access token. Logout the user.
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (IBAction)loginLinkedInAction:(id)sender {
    
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            
            //NSLog(@"code : %@", code);
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            NSString *tokenTimestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            
            [[NSUserDefaults standardUserDefaults] setValue:tokenTimestamp forKey:@"tokenTime"];
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"linkedInAuthCode"];
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"linkedinToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self fetchLinkedInData:accessToken];
            
        } failure:^(NSError *error) {
            
            NSLog(@"Quering accessToken failed %@", error);
            
        }];
    } cancel:^{
        
        NSLog(@"Authorization was cancelled by user");
        
    } failure:^(NSError *error) {
        
        NSLog(@"Authorization failed %@", error);
        
    }];
    
}

/*
- (void)linkedAccessToken{
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"L" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:[accessTokenData objectForKey:@"access_token"] forKey:@"linkedinToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self requestMeWithToken:accessToken];
            
        } failure:^(NSError *error) {
            
            NSLog(@"Quering accessToken failed %@", error);
            
        }];
    } cancel:^{
        
        NSLog(@"Authorization was cancelled by user");
        
    } failure:^(NSError *error) {
        
        NSLog(@"Authorization failed %@", error);
        
    }];
}
*/

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.experencia.me/linkedInRedirect/"
                                                                                    clientId:@"75qedd675epii0"
                                                                                clientSecret:@"aKHwpRLwVT96w9pU"
                                                                                       state:@"kyronWF45453sdffef424"
                                                                               grantedAccess:@[@"r_basicprofile", @"r_emailaddress", @"r_fullprofile"]];
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:self];
}


- (void)refreshAccessToken{
    NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:@"linkedInAuthCode"];
    [self.client POST:[NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@",code,@"http://www.experencia.me/linkedInRedirect/",@"75qedd675epii0",@"aKHwpRLwVT96w9pU"] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"result %@", result);
        
        NSString *tokenTimestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [[NSUserDefaults standardUserDefaults] setValue:tokenTimestamp forKey:@"tokenTime"];
        [[NSUserDefaults standardUserDefaults] setObject:result[@"access_token"] forKey:@"linkedinToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
}

- (void)checkTokenExpiry{
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenTime"];
    double difference = [time doubleValue] - [[NSDate date] timeIntervalSince1970];
    
    if (difference >= 5183999 ) {
        [self refreshAccessToken];
    }
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"linkedinToken"];
    [self fetchLinkedInData:accessToken];    
}



-(void)fetchLinkedInData:(NSString *)accessToken{
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,location:(name),industry,summary,specialties,positions,picture-url,public-profile-url,email-address,interests,skills,educations)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        //NSLog(@"current user %@", result);
        
        NSDictionary *linkedInProfile = @{@"linkedinId": result[@"id"],
                                          @"email": result[@"emailAddress"],
                                          @"firstName": result[@"firstName"],
                                          @"lastName": result[@"lastName"],
                                          @"location": result[@"location"][@"name"],
                                          @"headline": result[@"headline"],
                                          @"industry": result[@"industry"],
                                          @"company": @{@"id": result[@"positions"][@"values"][0][@"company"][@"id"],
                                                        @"industry": result[@"positions"][@"values"][0][@"company"][@"industry"],
                                                        @"name": result[@"positions"][@"values"][0][@"company"][@"name"],
                                                        @"isCurrent": result[@"positions"][@"values"][0][@"isCurrent"],
                                                        @"title": result[@"positions"][@"values"][0][@"title"]},
                                          @"pubUrl": result[@"publicProfileUrl"],
                                          @"picUrl": result[@"pictureUrl"],
                                          @"summary": result[@"summary"]};
        
        [[NSUserDefaults standardUserDefaults] setObject:linkedInProfile forKey:@"userProfile"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"LinkedIn info %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"]);
        
        
        
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate continueLogin:linkedInProfile];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
}

@end
