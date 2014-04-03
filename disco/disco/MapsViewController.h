//
//  MapsViewController.h
//  disco
//
//  Created by Abhigyan Raghav on 3/17/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>

@interface MapsViewController : UIViewController

@property (nonatomic,retain) NSString *address;
@property (weak, nonatomic) IBOutlet UIView *GMap;



@end
