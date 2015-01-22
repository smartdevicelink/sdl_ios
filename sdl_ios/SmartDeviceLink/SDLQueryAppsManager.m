//
//  SDLQueryAppsManager.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/22/15.
//  Copyright (c) 2015 FMC. All rights reserved.
//

#import "SDLQueryAppsManager.h"

NSString *const SDLErrorDomainQueryApps = @"SDLErrorDomainQueryApps";
NSString *const SDLQueryAppsQueueIdentifier = @"com.smartdevicelink.queryapps.parser";


@interface SDLQueryAppsManager ()

@end


@implementation SDLQueryAppsManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

+ (dispatch_queue_t)queryAppsQueue {
    static dispatch_queue_t queryAppsQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queryAppsQueue = dispatch_queue_create([SDLQueryAppsQueueIdentifier cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    });
    
    return queryAppsQueue;
}

+ (void)filterQueryResponse:(NSDictionary *)responseData completionBlock:(void (^)(NSDictionary *filteredResponseData, NSError *error))completionBlock {
    dispatch_async([self.class queryAppsQueue], ^{
        // Clear and set up the filteredQueryResponse
        NSMutableDictionary *filteredQueryResponse = [[NSMutableDictionary alloc] initWithCapacity:responseData.allKeys.count];
        filteredQueryResponse[@"status"] = responseData[@"status"];
        filteredQueryResponse[@"responseType"] = responseData[@"responseType"];
        NSMutableArray *filteredResponses = [[NSMutableArray alloc] init];
        
        // Make sure we have data within the response. If we don't, throw an error
        NSArray *apps = responseData[@"response"];
        if (apps == nil) {
            NSError *error = [NSError errorWithDomain:SDLErrorDomainQueryApps code:SDLErrorDomainQueryAppsCodeResponseDataInvalid userInfo:@{@"responseData": responseData}];
            completionBlock(nil, error);
        }
        
        // Loop through the response array, pull out all of the iOS data
        for (NSDictionary *appData in apps) {
            NSDictionary *iOSAppData = appData[@"ios"];
            if (iOSAppData == nil) {
                continue;
            }
            
            // Check the URL scheme to see if it is installed
            NSString *iOSURLSchemeString = iOSAppData[@"urlScheme"];
            NSURL *iOSURLScheme = [NSURL URLWithString:iOSURLSchemeString];
            if ([[UIApplication sharedApplication] canOpenURL:iOSURLScheme]) {
                [filteredResponses addObject:appData];
            }
        }
        
        // Add the installed applications to the filtered response dictionary, pass it back on the main queue
        filteredQueryResponse[@"response"] = filteredResponses;
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([NSDictionary dictionaryWithDictionary:filteredQueryResponse], nil);
        });
    });
}

@end
