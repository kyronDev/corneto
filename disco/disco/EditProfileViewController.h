//
//  EditProfileViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 1/30/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalParam.h"

@interface EditProfileViewController : UIViewController{
    CGFloat animatedDistance;
}
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *userIntroduction;
@property (weak, nonatomic) IBOutlet UITextView *userIndustry;
@property (weak, nonatomic) IBOutlet UITextView *userInterestTags;
@property (weak, nonatomic) IBOutlet UITextView *userLocation;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@end
