//
//  SDLQueryAppsManager.m


#import "SDLQueryAppsManager.h"

#import <UIKit/UIKit.h>

#import "SDLDebugTool.h"


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

+ (void)filterQueryResponse:(NSDictionary *)responseData completionBlock:(QueryResponseCompletionBlock)completionBlock {
    dispatch_async([self.class queryAppsQueue], ^{
        NSError *error = nil;

        // Clear and set up the filteredQueryResponse
        NSMutableDictionary *filteredQueryResponse = [[NSMutableDictionary alloc] initWithCapacity:responseData.allKeys.count];
        filteredQueryResponse[@"status"] = responseData[@"status"];
        filteredQueryResponse[@"responseType"] = responseData[@"responseType"];
        NSMutableArray *filteredResponses = [[NSMutableArray alloc] init];

        // Make sure we have data within the response. If we don't, throw an error
        NSArray *apps = responseData[@"response"];
        if (apps == nil) {
            error = [NSError errorWithDomain:SDLErrorDomainQueryApps code:SDLErrorDomainQueryAppsCodeResponseDataInvalid userInfo:@{ @"responseData" : responseData }];

            [self dispatchError:error forCompletionBlock:completionBlock];
            return;
        }

        // Loop through the response array, pull out all of the iOS data
        for (NSDictionary *appData in apps) {
            @autoreleasepool {
                NSDictionary *iOSAppData = appData[@"ios"];
                if (iOSAppData == nil) {
                    continue;
                }

                // Check the URL scheme to see if it is installed
                NSString *iOSURLSchemeString = iOSAppData[@"urlScheme"];
                NSURL *iOSURLScheme = [NSURL URLWithString:iOSURLSchemeString];
                if ([[UIApplication sharedApplication] canOpenURL:iOSURLScheme]) {
                    // If it's an iOS app that is installed, it is part of the filtered response we want to send back
                    [filteredResponses addObject:appData];
                }
            }
        }

        // Replace the response dictionary that contained every app with the filtered list
        filteredQueryResponse[@"response"] = filteredResponses;
        [SDLDebugTool logInfo:[NSString stringWithFormat:@"Filtered Query Apps data from cloud: %@", filteredQueryResponse] withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All];

        // Serialize the list and pass it to the completion block
        NSData *filteredQueryResponseData = [NSJSONSerialization dataWithJSONObject:filteredQueryResponse options:kNilOptions error:&error];
        if (error != nil) {
            [self dispatchError:error forCompletionBlock:completionBlock];
            return;
        }

        // Send back the data through the completion block
        [self dispatchData:filteredQueryResponseData forCompletionBlock:completionBlock];
    });
}

+ (void)dispatchError:(NSError *)error forCompletionBlock:(QueryResponseCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(nil, error);
    });
}

+ (void)dispatchData:(NSData *)data forCompletionBlock:(QueryResponseCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(data, nil);
    });
}

@end
