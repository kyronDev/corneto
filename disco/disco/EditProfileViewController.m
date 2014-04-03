//
//  EditProfileViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 1/30/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "EditProfileViewController.h"


@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

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
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
    NSLog(@"email %@", email);
    NSDictionary *param = @{@"email": email};
    
    [[[GlobalParam sharedManager] networkManager] GET:@"fetchUserProfile/" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"user edit %@", responseObject);
        self.userIntroduction.text = responseObject[0][@"fields"][@"userIntroduction"];
        self.userIndustry.text = responseObject[0][@"fields"][@"userIndustry"];
        self.userInterestTags.text = responseObject[0][@"fields"][@"userInterestTags"];
        self.userLocation.text = responseObject[0][@"fields"][@"locationCity"];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
    }];
    

}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) textViewShouldBeginEditing:(UITextView *)textView {
    
    CGRect textFieldRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
    }else{
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
/*
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}
 */

- (IBAction)saveButtonAction:(id)sender {
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile"] objectForKey:@"email"];
    NSDictionary *userDetails = @{@"email":email,
                                  @"userIntroduction": self.userIntroduction.text,
                                  @"userIndustry": self.userIndustry.text,
                                  @"userInterestTags": self.userInterestTags.text,
                                  @"locationCity": self.userLocation.text};
    [[[GlobalParam sharedManager] networkManager] POST:@"saveUserProfile/" parameters:userDetails success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation);
    }];
    
}


@end
