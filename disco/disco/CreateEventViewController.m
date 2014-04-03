//
//  CreateEventViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 1/19/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController ()

@end

@implementation CreateEventViewController

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
    
}



-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createButtonAction:(id)sender {
    
    /*
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int year   =    [[calendar components:NSYearCalendarUnit    fromDate:[self.eventTimeDate date]] year];
    int month  =    [[calendar components:NSMonthCalendarUnit   fromDate:[self.eventTimeDate date]] month];
    int day    =    [[calendar components:NSDayCalendarUnit     fromDate:[self.eventTimeDate date]] day];
    int hour   =    [[calendar components:NSHourCalendarUnit    fromDate:[self.eventTimeDate date]] hour];
    int minute =    [[calendar components:NSMinuteCalendarUnit  fromDate:[self.eventTimeDate date]] minute];
    
    NSDate *date;
    */
    
    NSString *date = [NSString stringWithFormat:@"%f",self.eventTimeDate.date.timeIntervalSince1970];
    NSString *currentDate = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSLog(@"date %@s", currentDate);
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile" ] objectForKey:@"email"];
    
    NSData *imageData = UIImageJPEGRepresentation(self.eventLogo.image, 0.5);
    NSLog(@"Image Data %@", imageData);
    
    if ([self.eventName.text length] == 0) {
        [self.view makeToast:@"Please fill in the event name"];
    }else if([self.eventHeadline.text length] == 0){
        [self.view makeToast:@"Please fill in the event headline"];
    }else if([self.eventHighlight.text length] == 0){
        [self.view makeToast:@"Please fill in the event hihlight"];
    }else if([self.eventDescription.text length] == 0){
        [self.view makeToast:@"Please fill in the event description"];
    }else if([self.eventCompanyName.text length] == 0){
        [self.view makeToast:@"Please fill in the event organizing company name"];
    }else if([self.expectedFootfall.text length] == 0){
        [self.view makeToast:@"Please fill in the event expected footfall"];
    }else if([self.eventTags.text length] == 0){
        [self.view makeToast:@"Please fill in the event tags"];
    }else if([self.eventAgenda.text length] == 0){
        [self.view makeToast:@"Please fill in the event agenda"];
    }else if([self.eventCity.text length] == 0){
        [self.view makeToast:@"Please fill in the event city and country"];
    }else if([self.eventAddress.text length] == 0){
        [self.view makeToast:@"Please fill in the proper event address"];
    }else if([self.phoneNumber.text length] == 0){
        [self.view makeToast:@"Please fill in the event contact phone number"];
    }else if([self.email.text length] == 0){
        [self.view makeToast:@"Please fill in the event contact E-mail"];
    }else if(imageData == (id)[NSNull null]){
        [self.view makeToast:@"Please add a logo for the event"];
    }else{
        
        NSDictionary *createEventData = @{@"eventName": self.eventName.text,
                                          @"eventHeadline": self.eventHeadline.text,
                                          @"eventHighlight": self.eventHighlight.text,
                                          @"eventDescription": self.eventDescription.text,
                                          @"eventOrganizer": email,
                                          @"eventCompanyName": self.eventCompanyName.text,
                                          @"expectedFootfall": self.expectedFootfall.text,
                                          @"eventTags": self.eventTags.text,
                                          @"eventTimeDate": date,
                                          @"eventAgenda": self.eventAgenda.text,
                                          @"eventCity": self.eventCity.text,
                                          @"eventAddress": self.eventAddress.text,
                                          @"eventCreatedTime": currentDate,
                                          @"contactNumber": self.phoneNumber.text,
                                          @"contactEmail": self.email.text};
        NSLog(@"created event Data %@", createEventData);
        
        [self.view makeToastActivity];
        AFHTTPRequestOperation *op = [[[GlobalParam sharedManager] networkManager] POST:@"create/" parameters:createEventData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary, but append it!
            [formData appendPartWithFileData:imageData name:@"eventLogo" fileName:@"logo.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self.view hideToastActivity];
            [self.view makeToast:@"Event Created !!" duration:3.0 position:@"center"];
            
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
            
            [self.view hideToastActivity];
            [self.view makeToast:@"No connection, please try again"];
        }];
        [op start];
        
    }

    //TODO add a notification dialog on success or faliure of an event
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSLog(@"textViewDidBeginEditing");
    // never called...
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView == self.eventHeadline) {
        NSInteger newTextLength = [textView.text length] - range.length + [text length];
        if (newTextLength > 200) {
            return NO;
        }
    }
    
    if (textView == self.eventHighlight) {
        NSInteger newTextLength = [textView.text length] - range.length + [text length];
        if (newTextLength > 100) {
            return NO;
        }
    }
    
    if (textView == self.eventCompanyName) {
        NSInteger newTextLength = [textView.text length] - range.length + [text length];
        if (newTextLength > 50) {
            return NO;
        }
    }
    
    if (textView == self.eventTags) {
        NSInteger newTextLength = [textView.text length] - range.length + [text length];
        if (newTextLength > 500) {
            return NO;
        }
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.eventName) {
        NSInteger newTextLength = [textField.text length] - range.length + [string length];
        if (newTextLength > 20) {
            return NO;
        }
    }
    
    if (textField == self.eventCity) {
        NSInteger newTextLength = [textField.text length] - range.length + [string length];
        if (newTextLength > 20) {
            return NO;
        }
    }
    
    if (textField == self.expectedFootfall) {
        NSInteger newTextLength = [textField.text length] - range.length + [string length];
        if (newTextLength > 20) {
            return NO;
        }
    }
    
    return YES;

}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)uploadLogoButton:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.eventLogo.contentMode = UIViewContentModeScaleAspectFit;
    self.eventLogo.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
