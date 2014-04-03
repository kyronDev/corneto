//
//  GlobalParam.m
//  disco
//
//  Created by Abhigyan Raghav on 1/13/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import "GlobalParam.h"


@implementation GlobalParam

@synthesize someProperty, baseUrl, networkManager, operationQueue, choosenTags;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static GlobalParam *sharedParam = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedParam = [[self alloc] init];
    });
    return sharedParam;
}

- (id)init {
    if (self = [super init]) {
        someProperty = @"Default Property Value";
        
        baseUrl = [NSURL URLWithString:@"http://www.experencia.me/"];
        // The URL can be any login screen, or any CSRF protected form
        NSString *csrf = [self CSRFTokenFromURL:@"http://www.experencia.me/token/"];
        NSLog(@"CSRF TOKEN  %@",csrf);
        
        networkManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
        
        networkManager.requestSerializer = [AFHTTPRequestSerializer serializer]; //URL Form Parameter Encoding
        networkManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [networkManager.requestSerializer setValue:@"http://www.experencia.me" forHTTPHeaderField:@"Referer"];
        [networkManager.requestSerializer setValue:csrf forHTTPHeaderField:@"X-CSRFToken"];
        
        operationQueue = networkManager.operationQueue;
        
        [networkManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    [operationQueue setSuspended:NO];
                    NSLog(@"ops queue not suspended");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    [operationQueue setSuspended:YES];
                    NSLog(@"ops queue suspended");
                    break;
            }
        }];
        
    }
    return self;
}


- (NSString *)CSRFTokenFromURL:(NSString *)url
{
    
    // Pass in any url with a CSRF protected form
    NSURL *baseURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:baseURL];
    //NSLog(@"cookies %@", cookies);
    
    for (NSHTTPCookie *cookie in cookies)
    {
        if ([[cookie name] isEqualToString:@"csrftoken"])
            //NSLog(@"csrf token %@", [cookie value]);
            return [cookie value];
    }
    //NSLog(@"no cookie");
    
    return nil;
}


@end
