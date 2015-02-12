//
//  SDLQueryAppsManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/22/15.
//  Copyright (c) 2015 FMC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SDLErrorDomainQueryApps;

typedef void (^QueryResponseCompletionBlock)(NSData *filteredResponseData, NSError *error);

typedef NS_ENUM(NSInteger, SDLErrorDomainQueryAppsCode) {
    SDLErrorDomainQueryAppsCodeResponseDataInvalid
};

@interface SDLQueryAppsManager : NSObject

- (instancetype)init;

/**
 *  Filter a Query Apps Response from a Query Apps request sent via OnSystemRequest
 *
 *  @param responseData    The dictionary of data returned by the Query Apps server
 *  @param completionBlock The filtered data to be returned to the Head Unit, or an error if the method encountered an error parsing the responseData
 */
+ (void)filterQueryResponse:(NSDictionary *)responseData completionBlock:(QueryResponseCompletionBlock)completionBlock;

@end
