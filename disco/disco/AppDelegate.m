//
//  AppDelegate.m
//  disco
//
//  Created by Abhigyan Raghav on 12/20/13.
//  Copyright (c) 2013 Kyron. All rights reserved.
//

#import "AppDelegate.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    NSLog(@"entered");

    //Google API key
    [GMSServices provideAPIKey:@"AIzaSyDf3ppzFfXSR491V3uHFQewVa6W4RV42LY"];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"linkedinToken"] length] !=0 ) {
        
        NSLog(@"linkedIn found");
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [loginViewController checkTokenExpiry];
        
    }
    return YES;
}

- (void)continueLogin:(NSDictionary *)userData{
    
    [[[GlobalParam sharedManager] networkManager] POST:@"login/" parameters:userData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[0]);
        
        //Load Events List controller
        self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
        
        //set reveal View controller as the root view controller
        SWRevealViewController *revealViewController = (SWRevealViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"revealViewController"];
        
        [self.window setRootViewController:revealViewController];
        //set navigation controller as root view controller
        //[self.window setRootViewController:navigationController];
        
        [self.window makeKeyAndVisible];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog (@" operation %@",operation.responseString);
        NSLog(@"Error: %@", error);
    }];
    /*
    //Load Events List controller
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    
    //set reveal View controller as the root view controller
    SWRevealViewController *revealViewController = (SWRevealViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"revealViewController"];
    
    [self.window setRootViewController:revealViewController];
    //set navigation controller as root view controller
    //[self.window setRootViewController:navigationController];
    
    [self.window makeKeyAndVisible];
    */
}

- (void)checkFacebookLogin
{
    // Create a LoginUIViewController instance where we will put the login button
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    self.loginViewController = loginViewController;
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        UIButton *loginButton = [loginViewController loginButton];
        [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    }
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        
        
        [self requestNewPermissions];
        
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

-(void)requestNewPermissions
{

    // We will request the user's public profile and the user's birthday
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"email"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  // These are the current permissions the user has:
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  
                                  // We will store here the missing permissions that we will have to request
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession
                                       requestNewReadPermissions:requestPermissions
                                       completionHandler:^(FBSession *session, NSError *error) {
                                           if (!error) {
                                               // Permission granted
                                               NSLog(@"new permissions %@", [FBSession.activeSession permissions]);
                                               // We can request the user information
                                               [self userLoggedIn];
                                               //[self requestUserData];
                                           } else {
                                               // An error occurred, we need to handle the error
                                               // See: https://developers.facebook.com/docs/ios/errors
                                           }
                                       }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self userLoggedIn];
                                      //[self requestUserData];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];

    
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    UIButton *loginButton = [self.loginViewController loginButton];
    [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    
    // Confirm logout message
    [self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    UIButton *loginButton = self.loginViewController.loginButton;
    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"F" forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self requestUserData];
    
    // Welcome message
    [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}

-(void)requestUserData
{
    [FBRequestConnection startWithGraphPath:@"me/"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Sucess! Include your code to handle the results here
                                  NSLog(@"user Data: %@", result[@"location"][@"name"]);
                                  NSDictionary *userData = @{@"fbId":result[@"id"],
                                                         @"firstName":result[@"first_name"],
                                                         @"lastName":result[@"last_name"],
                                                         @"email":result[@"email"],
                                                         @"location":result[@"location"][@"name"]};
                                  
                                  [self authUser:userData];
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
}

-(void) authUser:(NSDictionary *) userData{
    //NSLog(@"user %@", userData );
    
    [[[GlobalParam sharedManager] networkManager] POST:@"login/" parameters:userData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject[0]);
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[0][@"fields"] forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[0][@"pk"] forKey:@"userEmail"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        //Load Events List controller
        self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];

        //set reveal View controller as the root view controller
        SWRevealViewController *revealViewController = (SWRevealViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"revealViewController"];

        [self.window setRootViewController:revealViewController];
        //set navigation controller as root view controller
        //[self.window setRootViewController:navigationController];
        
        [self.window makeKeyAndVisible];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog (@" operation %@",operation.responseString);
        NSLog(@"Error: %@", error);
    }];
    
}


// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Background");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"Active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"Terminate");
}

@end
