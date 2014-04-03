//
//  GlobalParam.h
//  disco
//
//  Created by Abhigyan Raghav on 1/13/14.
//  Copyright (c) 2014 Kyron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFURLRequestSerialization.h>
#import <AFNetworking/AFURLResponseSerialization.h>

@interface GlobalParam : NSObject {
    NSString *someProperty;
    NSDictionary *userData;
}

@property (nonatomic, retain) NSDictionary *userData;
@property (nonatomic, retain) NSString *someProperty;
@property (nonatomic, retain) NSURL *baseUrl;
@property (nonatomic,retain) NSString *choosenTags;
@property (nonatomic, retain) AFHTTPRequestOperationManager *networkManager;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

+ (id)sharedManager;


@end
