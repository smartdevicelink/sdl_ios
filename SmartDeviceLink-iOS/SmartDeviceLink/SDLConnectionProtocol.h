//
//  SDLConnectionProtocol.h
//  SmartDeviceLink-iOS
//
//  Created by CHDSEZ318988DADM on 11/08/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLConnectionDelegate

- (void)SyncPDataNetworkRequestCompleteWithData:(NSData*) data;
- (void)handleSystemResponseProprietary:(NSData*) data;
- (void)handleSystemQueryAppsResponse:(NSData *)data andTask:(id)connectionTask ;

@end

@interface SDLConnectionProtocol : NSObject

- (id) initWithDelegate:(id<SDLConnectionDelegate>)delegate withDebugConsoleGroup:(NSString*)debugConsoleGroupName ;

- (void) uploadTaskWithPData:(NSData*)data withRequest:(NSMutableURLRequest*)request withTimeout:(NSNumber *)timeout;

- (void) uploadTaskWithSystemProprietaryDictionary:(NSDictionary*)dictionary withURLString:(NSString*) urlString;

- (void) dataTaskForSystemRequestURLString:(NSString *)urlString;

- (void) cancelAndInvalidate;
@end
