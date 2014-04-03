//
//  MapsViewController.m
//  disco
//
//  Created by Abhigyan Raghav on 3/17/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "MapsViewController.h"

@interface MapsViewController ()

@end

@implementation MapsViewController

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
    
    CLLocationCoordinate2D center = [self getLocation:self.address];
    
    NSLog(@"Latitude = %f, Longitude = %f", center.latitude, center.longitude);

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:center.latitude
                                                                                 longitude:center.longitude
                                                                                      zoom:16];
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.GMap.bounds camera:camera];
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(center.latitude, center.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = @"Hello World";
    marker.map = mapView;
                         
    [self.GMap addSubview:mapView];

}

- (CLLocationCoordinate2D)getLocation:(NSString *)address {
    
    CLLocationCoordinate2D center;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.co.in/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSData *responseData = [[NSData alloc] initWithContentsOfURL:
                            [NSURL URLWithString:req]];    NSError *error;
    NSMutableDictionary *responseDictionary = [NSJSONSerialization
                                               JSONObjectWithData:responseData
                                               options:nil
                                               error:&error];
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
        center.latitude = 0;
        center.longitude = 0;
        return center;
    }
    else {
        NSArray *results = (NSArray *) responseDictionary[@"results"];
        NSDictionary *firstItem = (NSDictionary *) [results objectAtIndex:0];
        NSDictionary *geometry = (NSDictionary *) [firstItem objectForKey:@"geometry"];
        NSDictionary *location = (NSDictionary *) [geometry objectForKey:@"location"];
        NSNumber *lat = (NSNumber *) [location objectForKey:@"lat"];
        NSNumber *lng = (NSNumber *) [location objectForKey:@"lng"];
        
        center.latitude = [lat doubleValue];
        center.longitude = [lng doubleValue];
        return center;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mapsButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
