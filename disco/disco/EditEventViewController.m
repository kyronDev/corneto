//
//  EditEventViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 4/1/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "EditEventViewController.h"

@interface EditEventViewController ()

@end

@implementation EditEventViewController

@synthesize myEvent;

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
    
    self.eventName.text = [[myEvent valueForKey:@"fields"] valueForKey:@"eventName"];
    self.eventHeadline.text = [[myEvent valueForKey:@"fields"] valueForKey:@"eventHeadline"];
    self.eventHighlight.text = [[myEvent valueForKey:@"fields"] valueForKey:@"eventHighlight"];
    self.eventAddress.text = [[myEvent valueForKey:@"fields"] valueForKey:@"eventAddress"];
    self.eventCity.text = [[myEvent valueForKey:@"fields"] valueForKey:@"eventCity"];
    self.eventDescription.text = [[myEvent valueForKey:@"fields"] valueForKey:@"eventDescription"];
    self.eventAgenda.text = [[myEvent valueForKey:@"fields"] valueForKey:@"eventAgenda"];
    self.eventTags.text = [[myEvent valueForKey:@"fields"] valueForKey:@"eventTags"];
    self.expectedFootfall.text = [[myEvent valueForKey:@"fields"] valueForKey:@"expectedFootfall"];
    NSTimeInterval time = [[[myEvent valueForKey:@"fields"] valueForKey:@"eventTime"] doubleValue];
    [self.datePicker setDate:[NSDate dateWithTimeIntervalSince1970:time] animated:YES];
    
    [self.eventLogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://www.experencia.me/media/",[[myEvent valueForKey:@"fields"] valueForKey:@"eventLogo"]]]
              placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)uploadLogoAction:(id)sender {
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

- (IBAction)saveButtonAction:(id)sender {
    
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
    
    NSString *date = [NSString stringWithFormat:@"%f",self.datePicker.date.timeIntervalSince1970];
    NSString *currentDate = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSLog(@"date %@s", currentDate);
    
    NSString *email = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userProfile" ] objectForKey:@"email"];
    
    NSDictionary *editEventData = @{@"eventName": self.eventName.text,
                                      @"eventHeadline": self.eventHeadline.text,
                                      @"eventHighlight": self.eventHighlight.text,
                                      @"eventDescription": self.eventDescription.text,
                                      @"eventOrganizer": email,
                                      @"eventCompanyName": self.companyName.text,
                                      @"expectedFootfall": self.expectedFootfall.text,
                                      @"eventTags": self.eventTags.text,
                                      @"eventTimeDate": date,
                                      @"eventAgenda": self.eventAgenda.text,
                                      @"eventCity": self.eventCity.text,
                                      @"eventAddress": self.eventAddress.text,
                                      @"contactNumber": self.phoneNumber.text,
                                      @"contactEmail": self.contactEmail.text,
                                      @"eventId": [myEvent valueForKey:@"pk"]};
    NSLog(@"created event Data %@", editEventData);
    
    NSData *imageData = UIImageJPEGRepresentation(self.eventLogo.image, 0.5);
    NSLog(@"Image Data %@", imageData);
    
    [self.view makeToastActivity];
    
    AFHTTPRequestOperation *op = [[[GlobalParam sharedManager] networkManager] POST:@"editEvent/" parameters:editEventData constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary, but append it!
        [formData appendPartWithFileData:imageData name:@"eventLogo" fileName:@"logo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.view hideToastActivity];
        [self.view makeToast:@"Event Edited !!" duration:3.0 position:@"center"];
        
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        
        [self.view hideToastActivity];
        [self.view makeToast:@"No connection, please try again"];
    }];
    [op start];
    
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
